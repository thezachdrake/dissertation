using GeoStats
import GeoIO: load
import CairoMakie: hist, set_theme!, theme_dark
import DataFrames: filter
include("./utils/load_utils.jl")
set_theme!(theme_dark())

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

places =
    build_place_table("data/places/") |>
    Map(:primary_type => map_top_place_category => "top_cat")

streets =
    load("data/streets.geojson") |>
    Filter(filter_streets_manhattan) |>
    Select("physicalid")

### spatial joins to create street level counts

street_to_points = match_points_streets(incidents, streets)
median_street_dist_center = calc_median_street_dist_center(streets.geometry)
filter!(x -> x.distance < 10, street_to_points)

hist(street_to_points[!, :distance], bins=100)

