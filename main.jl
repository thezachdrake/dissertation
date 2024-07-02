using GeoStats
import JSON: parsefile
import GeoIO: load
import CairoMakie as Mke
import Base.Threads: @threads
using BenchmarkTools
# include("GoogleMapsPlaceSearch.jl")
# using .GoogleMapsPlaceSearch
include("./utils/clean_crime.jl")

### load and clean datasets
incidents =
    load("data/incidents.geojson") |>
    Map(:law_cat_cd => map_law_cat => "law_cat") |>
    Map([:ofns_desc, :law_cat] => map_crime_cat => "crime_cat") |>
    Filter(filter_crime_types) |>
    Select("crime_cat")

arrests =
    load("data/arrests.geojson") |>
    DropMissing() |>
    Map(:law_cat_cd => map_law_cat => "law_cat") |>
    Map([:ofns_desc, :law_cat] => map_crime_cat => "crime_cat") |>
    Filter(filter_crime_types) |>
    Select("crime_cat")

place_data = []
@threads for place in readdir("data/places/")
    push!(place_data, parsefile("data/places/" * place))
end

places = georef(DataFrame(GoogleMapsPlaceSearch.flattenplace.(place_data)), [:lon, :lat])

streets = load("data/streets.geojson")
filter!([:borocode, :rw_type, :physicalid] => filter_streets_manhattan, streets)

street_to_point = streets |> Transfer(incidents.geometry)
incidents_street =
    hcat(street_to_point, georef(select(incidents, Not(:geometry)), incidents.geometry)) |>
    DataFrame

x = combine(groupby(incidents_street, :physicalid), :physicalid => length => :count)

sort(x, :count)
