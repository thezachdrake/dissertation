#set up environment
using DataFrames
using CSV
using Pipe
using Missings
using StatsPlots
using PlotThemes
theme(:ggplot2)
gr(size = (1000,750))

boros = ["MANHATTAN"]

#years to be considered in analysis
years = ["2006", "2007", "2008", "2009", "2010", "2011", 
        "2012", "2013", "2014", "2015", "2016", "2017", 
        "2018", "2019", "2020"]

#crimes to be considered in analysis
crimeList = ["BURGLARY", "GRAND LARCENY", "GRAND LARCENY OF MOTOR VEHICLE",
        "MURDER & NON-NEGL. MANSLAUGHTE", "MURDER & NON-NEGL. MANSLAUGHTER",
        "PETIT LARCENY", "RAPE", "ROBBERY", "DANGEROUS DRUGS", 
        "ALL OTHER MISDEMEANORS", "ALL OTHER FELONIES", "ALL OTHER VIOLATIONS", "ARSON"]


topOfns = @pipe CSV.read("data/NYPD_Complaint_Data_Historic.csv", DataFrame) |>
                        groupby(_, [:OFNS_DESC, :LAW_CAT_CD]) |> 
                        combine(_, nrow => :TOTAL) |> 
                        transform(_ , :TOTAL => (TOTAL -> TOTAL/sum(TOTAL)) => :PERC) |>
                        sort(_, :PERC, rev= true) |>
                        first(_, 25) |>
                        _[!, :OFNS_DESC]


function convertCrimeType(OFNS_DESC::Any, LAW_CAT_CD::Any)
        #Label all MISDEMEANORS that are not in crime list
        !(OFNS_DESC in crime_list) & (LAW_CAT_CD == "MISDEMEANOR") ? "ALL OTHER MISDEMEANORS" :
        #Label all FELONIES that are not in crime list
        !(OFNS_DESC in crime_list) & (LAW_CAT_CD == "FELONY") ? "ALL OTHER FELONIES" :
        #Label all VIOLATIONS that are not in crime list
        !(OFNS_DESC in crime_list) & (LAW_CAT_CD == "VIOLATION") ? "ALL OTHER VIOLATIONS" :
        #Fix naming truncation for murder
        OFNS_DESC == "MURDER & NON-NEGL. MANSLAUGHTE" ? "MURDER & NON-NEGL. MANSLAUGHTER" :
        #combine all LARCENY
        
        #Keep OFNS_DESC for all remining options
        string(OFNS_DESC)
end

#read in CSV data from OpenDataNYC
cleanCrimeData = @pipe CSV.read("data/NYPD_Complaint_Data_Historic.csv", DataFrame) |>
        #drop all columns not needed for analysis
        select(_, [:CMPLNT_FR_DT, :PREM_TYP_DESC, :OFNS_DESC, :LAW_CAT_CD, :Lat_Lon, :BORO_NM]) |>
        #drop columns with missing data in the kept columns
        dropmissing(_) |>       
        #reformate dataframe without missings
        disallowmissing(_) |>   
        #add new year column with last 4 digits of report date
        transform(_, :CMPLNT_FR_DT => (CMPLNT_FR_DT -> last.(CMPLNT_FR_DT, 4)) => :YEAR) |>  
        #select analysis crimes
        filter(:OFNS_DESC => in(topOfns), _) |>
        transform(_, convertCrimeType(:OFNS_DESC,:LAW_CAT_CD) => :TYPE) |>
        #Select just the analysis year
        filter(:YEAR => in(years), _) |>     
        #Select analysis boro
        filter(:BORO_NM => in(boros), _) |>    
        #Select final columns for analysis
        select(_, [:Lat_Lon, :BORO_NM, :PREM_TYP_DESC, :TYPE, :YEAR])


crimeByPlace = @pipe cleanCrimeData |>
    groupby(_, :PREM_TYP_DESC) |> 
    combine(_, nrow => :TOTAL) |>
    transform(_, :TOTAL => (TOTAL -> TOTAL ./ sum(TOTAL)) => :PROP) |>
    sort(_, :PROP, rev =true)

percRes = @pipe filter(:PREM_TYP_DESC => startswith("RESIDENCE"), crimeByPlace) |> sum(_.PROP)
percHouse = @pipe filter(:PREM_TYP_DESC => startswith("RESIDENCE-HOUSE"), crimeByPlace) |> sum(_.PROP)