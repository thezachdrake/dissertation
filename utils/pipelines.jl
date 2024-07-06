using GeoStats

include("clean_crime.jl")

incidents_pipeline =
    Map(:law_cat_cd => map_law_cat => "law_cat") ->
        Map([:ofns_desc, :law_cat] => map_crime_cat => "crime_cat") ->
            Filter(filter_crime_types) ->
                Select("crime_cat" => "crime") ->
                    OneHot("crime")