using GeoStats
import GeoIO
using JSON
using DataFrames
include("GoogleMapsPlaceSearch.jl")
using .GoogleMapsPlaceSearch
include("cleaning_tools.jl")

arrests = GeoIO.load("data/arrests.geojson") |> DataFrame
describe(arrests)

incidents = GeoIO.load("data/incidents.geojson") |> DataFrame
describe(incidents)

incidents.crime_cat = map_offense_desc.(incidents.ofns_desc, incidents.law_cat_cd)
filter!(:crime_cat => filter_types, incidents)
combine(
    groupby(incidents, :crime_cat),
    :crime_cat => length => :count
)
unique(incidents.geometry)


arrests.law_cat_cd = fix_law_cd.(arrests.law_cat_cd)
arrests.crime_cat = map_offense_desc.(arrests.ofns_desc, arrests.law_cat_cd)
filter!(:crime_cat => filter_types, arrests)
combine(
    groupby(arrests, :crime_cat),
    :crime_cat => length => :count
)

place_data = []
for place in readdir("data/places/")
    push!(place_data, JSON.parsefile("data/places/" * place))
end

places = georef(
    DataFrame(GoogleMapsPlaceSearch.flattenplace.(place_data)), [:lon, :lat]
) |> DataFrame


streets = GeoIO.load("data/streets.geojson") |> DataFrame
select_manhattan(borocode::String) = borocode == "1"
select_streets(rw_type::String) = rw_type == "1"
filter!(:borocode => select_manhattan, streets)
filter!(:rw_type => select_streets, streets)
select_bad_place(physicalid) = physicalid == "174150"
filter(:physicalid => select_bad_place, streets)

street_to_point = streets |> Transfer(incidents.geometry)
incidents_street = hcat(street_to_point, georef(select(incidents, Not(:geometry)), incidents.geometry)) |> DataFrame

x = combine(
    groupby(incidents_street, :physicalid),
    :physicalid => length => :count
)

sort(x, :count)
