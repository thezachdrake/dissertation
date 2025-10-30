
module Dissertation

using Dates, Logging, Statistics, Printf
using DataFrames, CSV
using JSON
using HTTP

using GeoStats, GeoTables, GeoIO, GeoJSON
using Meshes, CoordRefSystems
using Distances, NearestNeighbors

using StatsBase, StatsModels, GLM
using CategoricalArrays, Chain, Missings
using MultivariateStats, Distributions

using CairoMakie, Colors, ColorSchemes

using FileIO, Glob, DotEnv, Unitful

if isfile(".env")
    DotEnv.config()
end

DATA_DIR = get(ENV, "DATA_DIR", "data")
OUTPUT_DIR = get(ENV, "OUTPUT_DIR", "output")
FILES::String =
    function set_output_dir(dir::String)
        global OUTPUT_DIR = dir
        mkpath(dir)
        @info "Output directory set to: $dir"
        return dir
    end

function set_data_dir(dir::String)
    global DATA_DIR = dir
    @info "Data directory set to: $dir"
    return dir
end

const CRIME_CATEGORIES::Vector{String} = ["LARCENY", "VIOLENCE", "BURGLARY", "DRUGS"]

# Data acquisition layer - interfaces with external APIs
include("download.jl")          # NYC Open Data & Google Places API functions

# Data processing layer - standardization and categorization
include("processing.jl")        # Crime categorization, place type mapping

# Spatial analysis layer - geographic computations
include("spatial.jl")          # K-NN matching, distance filtering, spatial stats

# Feature engineering layer - variable creation
include("features.jl")         # Target variables, Jenks breaks, feature matrix

# Analysis layers - research question implementations
include("cooccurrence.jl")     # RQ1: Place type co-location patterns
include("modeling.jl")         # RQ2&3: Logistic regression models

# Output layer - results and visualization
include("output.jl")           # Tables, figures, summary reports

# Orchestration layer - workflow management
include("pipeline.jl")         # Main run() function coordinating all analyses

end # module Dissertation
