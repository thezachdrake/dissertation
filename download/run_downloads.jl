using DotEnv: load!
using Logging

load!()


include("download_crime.jl")
include("download_places.jl")
include("download_streets.jl")

@info "Downloading crime data..."
GetCrimeData()
@info "Downloading street data..."
GetStreetData()
@info "Downloading place data..."
GetPlaceData()
