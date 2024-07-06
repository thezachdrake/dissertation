using GeoStats
import GeoIO: load
import CairoMakie: barplot, density, set_theme!, theme_dark
import DataFrames: filter, leftjoin, groupby, combine, transform!
using GLM
include("./utils/load_utils.jl")
set_theme!(theme_dark())

### load and clean datasets
incidents =
    load("data/incidents.geojson") |>
    Map(:law_cat_cd => map_law_cat => "law_cat") |>
    Map([:ofns_desc, :law_cat] => map_crime_cat => "crime_cat") |>
    Filter(filter_crime_types) |>
    Select("crime_cat" => "crime") |>
    OneHot("crime")
incidents = georef(DataFrame(values(incidents)), domain(incidents))

arrests =
    load("data/arrests.geojson") |>
    DropMissing() |>
    Map(:law_cat_cd => map_law_cat => "law_cat") |>
    Map([:ofns_desc, :law_cat] => map_crime_cat => "crime_cat") |>
    Filter(filter_crime_types) |>
    Select("crime_cat" => "crime") |>
    OneHot("crime")
arrests = georef(DataFrame(values(arrests)), domain(arrests))

places =
    build_place_table("data/places/") |>
    DropMissing(["primary_type"]) |>
    Map(:primary_type => map_top_place_category => "top_cat") |>
    Select("top_cat" => "category") |>
    OneHot("category")
places = georef(DataFrame(values(places)), domain(places))

streets =
    load("data/streets.geojson") |>
    Filter(filter_streets_manhattan) |>
    Select("physicalid" => "street_id")
streets = georef(DataFrame(values(streets)), domain(streets))


### spatial joins to match point data with streets
incidents = match_points_streets!(incidents, streets)
places = match_points_streets!(places, streets)
arrests = match_points_streets!(arrests, streets)

median_street_dist_center = calc_median_street_dist_center(streets.geometry)

### group and aggregate by street
incidents = combine(groupby(incidents, :street_id),
    :crime_VIOLENCE => sum,
    :crime_LARCENY => sum,
    :crime_DRUGS => sum,
    :crime_BURGLARY => sum)

places = combine(groupby(places, :street_id),
    :category_AUTOMOTIVE => sum,
    :category_BUSINESS => sum,
    :category_CULTURE => sum,
    :category_EDUCATION => sum,
    :category_FINANCE => sum,
    :category_FOODBEV => sum,
    :category_GOVERNMENT => sum,
    :category_HEALTH => sum,
    :category_LODGING => sum,
    :category_RECREATION => sum,
    :category_SERVICES => sum,
    :category_SHOPPING => sum,
    :category_TRANSPORTATION => sum,
    :category_WORSHIP => sum)

arrests = combine(groupby(arrests, :street_id),
    :crime_VIOLENCE => sum,
    :crime_LARCENY => sum,
    :crime_DRUGS => sum,
    :crime_BURGLARY => sum)

### join aggregate tables back to streets
streets = tablejoin(streets, incidents, kind=:left, on=:street_id)
streets = tablejoin(streets, places, kind=:left, on=:street_id)
streets = tablejoin(streets, arrests, kind=:left, on=:street_id)

### convert missing values to zero counts
streets = georef(coalesce.(values(streets), 0), streets.geometry)