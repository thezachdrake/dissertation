using GeoStats
using JSON
import GeoIO: load
import Base.Threads
using Match
import CairoMakie as Mke
# include("GoogleMapsPlaceSearch.jl")
# using .GoogleMapsPlaceSearch
include("cleaning_tools.jl")

### load and clean datasets
incdients =
    load("data/incidents.geojson") |>
    Map(:law_cat_cd => map_law_cat => "law_cat") |>
    Map([:ofns_desc, :law_cat] => map_crime_cat => "crime_cat") |>
    Filter(filter_crime_types)

arrests =
    load("data/arrests.geojson") |>
    Map(:law_cat_cd => map_law_cat => "law_cat") |>
    Map([:ofns_desc, :law_cat] => map_crime_cat => "crime_cat") |>
    Filter(filter_crime_types)

place_data = []
@sync for place in readdir("data/places/")
    Threads.@spawn push!(place_data, JSON.parsefile("data/places/" * place))
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
