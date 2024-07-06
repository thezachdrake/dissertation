using DotEnv: load!

load!()

include("download_crime.jl")
include("download_places.jl")
include("download_streets.jl")

GetCrimeData()
GetStreetData()
# GetPlaceData()