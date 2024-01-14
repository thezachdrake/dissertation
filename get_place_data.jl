include("PlaceDetailsSearch.jl")
using .PlaceDetailsSearch
using JSON


PlaceDetailsSearch.get_place_details()
JSON.json(PlaceDetailsSearch.places)