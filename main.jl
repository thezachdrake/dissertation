using GeoStats
import GeoIO: load
include("./utils/clean_crime.jl")
include("./utils/clean_place.jl")
include("./utils/clean_streets.jl")

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

incidents_on_street = streets |> Transfer(incidents.geometry)

incidents_on_street = hcat(incidents, incidents_on_street)

incidents