include("GoogleMapsPlaceSearch.jl")
using .GoogleMapsPlaceSearch
import GeoIO
import Meshes
import HTTP as HTTP

google_api::GoogleAPI = GoogleAPI(
    base = "https://places.googleapis.com/v1/",
    key = "AIzaSyB7lJ3rfPvqYp8xbHGUEkoSEBx86Qy1lls",
)

response::HTTP.Response = HTTP.get(
    "https://data.cityofnewyork.us/resource/7t3b-ywvw.geojson",
    query = ["\$\$app_token" => "PoXtpm9UpT6UnvUOK8F0lp3Sp"],
)

manhattan::Meshes.MultiPolygon = GeoIO.load(String(response.body))[2, :geometry]

GoogleMapsPlaceSearch.placedetails(google_api, manhattan)