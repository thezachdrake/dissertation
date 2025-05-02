using GeoStats
using GeoIO
using CairoMakie
using DataFrames
using CSV
using GLM
using StatsModels
using Chain: @chain
using FileIO

include("./utils/load_utils.jl")
include("modeling.jl")
include("utils/summary_stats.jl")

using .Modeling
using .SummaryStats

set_theme!(theme_dark())

incidents_geo =
    GeoIO.load("data/incidents.geojson") |>
    Map(:law_cat_cd => map_law_cat => "law_cat") |>
    Map([:ofns_desc, :law_cat] => map_crime_cat => "crime_cat") |>
    Filter(filter_crime_types) |>
    Select("crime_cat" => "crime") |>
    OneHot("crime")

arrests_geo =
    GeoIO.load("data/arrests.geojson") |>
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

# Define output directory
output_dir = "output"
mkpath(output_dir) # Use mkpath to avoid error if dir exists

# --- Calculate and Save Place Category Stats using Utility Function ---
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

# --- Model fitting part ---
println("Fitting logistic regression models...")
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