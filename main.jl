using GeoStats
import GeoIO: load
import Chain: @chain
import CairoMakie: barplot, density, set_theme!, theme_dark
import DataFrames: filter, groupby, combine, transform!, leftjoin, rename!
using GLM
include("./utils/load_utils.jl")
set_theme!(theme_dark())

incidents_geo =
    load("data/incidents.geojson") |>
    Map(:law_cat_cd => map_law_cat => "law_cat") |>
    Map([:ofns_desc, :law_cat] => map_crime_cat => "crime_cat") |>
    Filter(filter_crime_types) |>
    Select("crime_cat" => "crime") |>
    OneHot("crime")

arrests_geo =
    load("data/arrests.geojson") |>
    DropMissing() |>
    Map(:law_cat_cd => map_law_cat => "law_cat") |>
    Map([:ofns_desc, :law_cat] => map_crime_cat => "crime_cat") |>
    Filter(filter_crime_types) |>
    Select("crime_cat" => "crime") |>
    OneHot("crime")

places_geo =
    build_place_table("data/places/") |>
    DropMissing(["primary_type"]) |>
    Map(:primary_type => map_top_place_category => "top_cat") |>
    Select("top_cat" => "category") |>
    OneHot("category")

streets_geo =
    load("data/streets.geojson") |>
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
        :category_FINANCE => sum => :category_FINANCE,
        :category_FOODBEV => sum => :category_FOODBEV,
        :category_GOVERNMENT => sum => :category_GOVERNMENT,
        :category_HEALTH => sum => :category_HEALTH,
        :category_LODGING => sum => :category_LODGING,
        :category_RECREATION => sum => :category_RECREATION,
        :category_SERVICES => sum => :category_SERVICES,
        :category_SHOPPING => sum => :category_SHOPPING,
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
    [:incidents_LARCENY, :incidents_VIOLENCE, :incidents_BURGLARY, :incidents_DRUGS],
)

place_terms = Term.(Symbol.(filter(x -> contains(x, "category"), names(model_data))))

pred_25_burglary = Term(:top_25_VIOLENCE) ~ sum(place_terms)

foldl(*, place_terms)

glm(pred_25_burglary, model_data, Bernoulli(), LogitLink())