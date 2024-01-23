include("PlaceDetailsSearch.jl")
using .PlaceDetailsSearch
import GeoIO
import HTTP as HTTP

google_api::GoogleAPI = GoogleAPI(
    base="https://places.googleapis.com/v1/",
    key="AIzaSyB7lJ3rfPvqYp8xbHGUEkoSEBx86Qy1lls"
)

response::HTTP.Response = HTTP.get("https://data.cityofnewyork.us/resource/7t3b-ywvw.geojson",
    query=[
        "\$\$app_token" => "PoXtpm9UpT6UnvUOK8F0lp3Sp",
        # "\$query" => query_statement
    ]
)

test = GeoIO.load(String(response.body))


placedetails(google_api, test[2, :geometry], 100)

