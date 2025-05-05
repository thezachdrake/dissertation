using GeoStats
using GeoIO
using CairoMakie
using DataFrames: DataFrame, leftjoin, describe, groupby, combine, transform, sort!, leftjoin!, select, Not, insertcols! # Added describe
using CSV
using GLM
using StatsModels
using Chain: @chain
using FileIO

include("./utils/load_utils.jl")
include("modeling.jl")
include("utils/summary_stats.jl")
include("utils/calc_crime_groups.jl")

using .Modeling
using .SummaryStats

const MODELING_CRIME_CATEGORIES = ["VIOLENCE", "LARCENY", "DRUGS", "BURGLARY"]

set_theme!(theme_dark())

incidents_geo =
    GeoIO.load("data/incidents.geojson") |>
    Map(:law_cat_cd => map_law_cat => "law_cat") |>
    Map([:ofns_desc, :law_cat] => map_crime_cat => "crime_cat") |>
    Select("crime_cat" => "crime")

# Calculate Incident Crime Category Summary (using mapped, renamed, pre-filtered data)
println("Calculating incident crime category summary...")
incidents_df_for_summary = DataFrame(incidents_geo) # Use the geo object before filtering
incident_summary_full_df = @chain incidents_df_for_summary begin # Calculate full summary
    groupby(:crime)
    combine(nrow => :count)
    transform(:count => (x -> x / sum(x)) => :proportion)
    sort(:count, rev=true)
end
# Get the grand total BEFORE filtering the summary df
incident_grand_total_count = sum(incident_summary_full_df.count)

# Filter the summary DF to only include modeling categories
incident_summary_df = filter(:crime => crime -> crime in MODELING_CRIME_CATEGORIES, incident_summary_full_df)

# Add Total row using the grand total
push!(incident_summary_df, (crime="Total", count=incident_grand_total_count, proportion=1.0))

println("Finished calculating incident summary.")

# Continue the pipeline for incidents data used in analysis
incidents_geo = incidents_geo |>
                Filter(filter_crime_types) |>
                OneHot("crime")

arrests_geo =
    GeoIO.load("data/arrests.geojson") |>
    DropMissing() |>
    Map(:law_cat_cd => map_law_cat => "law_cat") |>
    Map([:ofns_desc, :law_cat] => map_crime_cat => "crime_cat") |>
    Select("crime_cat" => "crime")

# Calculate Arrest Crime Category Summary (using mapped, renamed, pre-filtered data)
println("Calculating arrest crime category summary...")
arrests_df_for_summary = DataFrame(arrests_geo) # Use the geo object before filtering
arrest_summary_full_df = @chain arrests_df_for_summary begin # Calculate full summary
    groupby(:crime)
    combine(nrow => :count)
    transform(:count => (x -> x / sum(x)) => :proportion)
    sort(:count, rev=true)
end
# Get the grand total BEFORE filtering the summary df
arrest_grand_total_count = sum(arrest_summary_full_df.count)

# Filter the summary DF to only include modeling categories
arrest_summary_df = filter(:crime => crime -> crime in MODELING_CRIME_CATEGORIES, arrest_summary_full_df)

# Add Total row using the grand total
push!(arrest_summary_df, (crime="Total", count=arrest_grand_total_count, proportion=1.0))

println("Finished calculating arrest summary.")

# Continue the pipeline for arrests data used in analysis
arrests_geo = arrests_geo |>
              Filter(filter_crime_types) |>
              OneHot("crime")

places_geo =
    build_place_table("data/places/") |>
    DropMissing(["primary_type"]) |>
    Map(:primary_type => map_top_place_category => "top_cat") |>
    Select("top_cat" => "category") |>
    OneHot("category")

streets_geo =
    GeoIO.load("data/streets.geojson") |>
    Filter(filter_streets_manhattan) |>
    Select("physicalid" => "street_id")
median_street_dist_center = calc_median_street_dist_center(streets_geo.geometry)

### spatial joins to match point data with streets
### group points by matched streets
### aggregate sums of points by street
incidents = @chain incidents_geo begin
    match_points_streets(streets_geo)
    groupby(:street_id)
    combine(
        :crime_VIOLENCE => sum => :incidents_VIOLENCE,
        :crime_LARCENY => sum => :incidents_LARCENY,
        :crime_DRUGS => sum => :incidents_DRUGS,
        :crime_BURGLARY => sum => :incidents_BURGLARY,
    )
end

places = @chain places_geo begin
    match_points_streets(streets_geo)
    groupby(:street_id)
    combine(
        :category_AUTOMOTIVE => sum => :category_AUTOMOTIVE,
        :category_BUSINESS => sum => :category_BUSINESS,
        :category_CULTURE => sum => :category_CULTURE,
        :category_EDUCATION => sum => :category_EDUCATION,
        :category_ENTERTAINMENT_RECREATION => sum => :category_ENTERTAINMENT_RECREATION, # Updated
        :category_FACILITIES => sum => :category_FACILITIES, # Added
        :category_FINANCE => sum => :category_FINANCE,
        :category_FOOD_DRINK => sum => :category_FOOD_DRINK, # Updated
        :category_GOVERNMENT => sum => :category_GOVERNMENT,
        :category_HEALTH_WELLNESS => sum => :category_HEALTH_WELLNESS, # Updated
        :category_LODGING => sum => :category_LODGING,
        :category_PLACE_OF_WORSHIP => sum => :category_PLACE_OF_WORSHIP, # Added
        :category_SERVICES => sum => :category_SERVICES,
        :category_SHOPPING => sum => :category_SHOPPING,
        :category_SPORTS => sum => :category_SPORTS, # Added
        :category_TRANSPORTATION => sum => :category_TRANSPORTATION,
    )
end
arrests = @chain arrests_geo begin
    match_points_streets(streets_geo)
    groupby(:street_id)
    combine(
        :crime_VIOLENCE => sum => :arrests_VIOLENCE,
        :crime_LARCENY => sum => :arrests_LARCENY,
        :crime_DRUGS => sum => :arrests_DRUGS,
        :crime_BURGLARY => sum => :arrests_BURGLARY,
    )
end

model_data::DataFrame = @chain DataFrame(values(streets_geo)) begin
    leftjoin(incidents, on=:street_id)
    leftjoin(places, on=:street_id)
    leftjoin(arrests, on=:street_id)
    coalesce.(0)
end

calc_top_crime_cols!(
    model_data,
    [
        :incidents_LARCENY, :arrests_LARCENY,
        :incidents_VIOLENCE, :arrests_VIOLENCE,
        :incidents_BURGLARY, :arrests_BURGLARY,
        :incidents_DRUGS, :arrests_DRUGS
    ],
)

# Add Jenks-based columns as well
calc_top_crime_cols_jenks_manual!(
    model_data,
    [
        :incidents_LARCENY, :arrests_LARCENY,
        :incidents_VIOLENCE, :arrests_VIOLENCE,
        :incidents_BURGLARY, :arrests_BURGLARY,
        :incidents_DRUGS, :arrests_DRUGS
    ],
)

# Define output directory
output_dir = "output"
mkpath(output_dir) # Use mkpath to avoid error if dir exists

# --- Print final shape of model_data ---
println("\nFinal shape of model_data DataFrame (rows, columns): ", size(model_data))

# --- Calculate and Save Overall Descriptive Stats for model_data ---
println("\nCalculating overall descriptive statistics for model_data...")
model_data_summary = describe(model_data)
model_data_summary_filename = joinpath(output_dir, "model_data_summary_stats.csv")
# Add transform to handle potential `nothing` values from describe()
CSV.write(model_data_summary_filename, model_data_summary; transform=(col, val) -> something(val, missing))
println("Saved model_data summary statistics to $model_data_summary_filename")

# --- Calculate and Save Place Category Stats using Utility Function ---
println("\nCalculating place category specific statistics...")
(place_distributions, cooccurrence_df, correlation_df) = SummaryStats.calculate_place_category_stats(model_data)
CSV.write(joinpath(output_dir, "place_category_distributions.csv"), place_distributions)
println("Saved place category distributions to output/place_category_distributions.csv")
CSV.write(joinpath(output_dir, "place_category_cooccurrence.csv"), cooccurrence_df)
println("Saved place category co-occurrence matrix to output/place_category_cooccurrence.csv")
CSV.write(joinpath(output_dir, "place_category_correlation.csv"), correlation_df)
println("Saved place category correlation matrix to output/place_category_correlation.csv")

# --- Generate Statistics Visualizations ---
println("\nIncluding statistics visualization script...")
include("visualize_stats.jl")

# --- Calculate and Save Distributions for 'top_' columns ---
top_cols_sym = Symbol.(filter(x -> startswith(x, "top_"), names(model_data)))

println("Calculating distributions for 'top_' columns...")
distributions = calculate_boolean_column_distributions(model_data, top_cols_sym)

# Save distributions to a CSV file
dist_filename = joinpath(output_dir, "top_crime_distributions.csv")
CSV.write(dist_filename, distributions)
println("Saved 'top_' column distributions to $dist_filename")

# --- Save Separate Incident/Arrest Category Summaries --- 
println("\nSaving incident and arrest category summaries...")

output_incident_summary_file = joinpath(output_dir, "incident_category_summary.csv")
CSV.write(output_incident_summary_file, incident_summary_df)
println("Saved incident category summary to $(output_incident_summary_file)")

output_arrest_summary_file = joinpath(output_dir, "arrest_category_summary.csv")
CSV.write(output_arrest_summary_file, arrest_summary_df)
println("Saved arrest category summary to $(output_arrest_summary_file)")

# --- Fit Models --- 
println("\nFitting logistic regression models...")
place_terms = Term.(Symbol.(filter(x -> contains(x, "category"), names(model_data))))

# Get target columns for modeling (ensure they exist)
target_cols_for_modeling = Symbol.(filter(x -> startswith(x, "top_") && x in names(model_data), names(model_data)))

fitted_logit_models = fit_logit_models(model_data, target_cols_for_modeling, place_terms)

println("Finished fitting models. Results stored in fitted_logit_models dictionary.")

# --- Save Model Summaries and Coefficients ---
Modeling.save_model_summaries(fitted_logit_models, output_dir)
Modeling.save_model_coefficients(fitted_logit_models, output_dir)

# --- Generate Model Visualizations ---
println("\nIncluding model visualization script...")
include("visualize_models.jl")

println("\nScript finished.")
