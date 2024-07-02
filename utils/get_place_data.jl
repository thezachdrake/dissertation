import GeoIO: load, save
using Meshes
import HTTP: Response, get
import DotEnv: load!

load!()
const API_KEY::String = "AIzaSyB7lJ3rfPvqYp8xbHGUEkoSEBx86Qy1lls"
const BASE_URL::String =
    google_api::GoogleAPI = GoogleAPI(;
        base = "https://places.googleapis.com/v1/",
        key = "AIzaSyB7lJ3rfPvqYp8xbHGUEkoSEBx86Qy1lls",
    )

response::Response = get(
    "https://data.cityofnewyork.us/resource/7t3b-ywvw.geojson";
    query = ["\$\$app_token" => "PoXtpm9UpT6UnvUOK8F0lp3Sp"],
)

function createSampleSearchPoints(area::MultiPolygon, api_limit::Integer)::Vector{Point}
    sample_rate::Float64 = 0.1
    points::Vector{Any} = zeros(api_limit + 1)

    sampler::Meshes.HomogeneousSampling = Meshes.HomogeneousSampling(api_limit)
    points = Meshes.sample(area, sampler) |> collect

    return points
end

manhattan::Meshes.MultiPolygon = GeoIO.load(String(response.body))[2, :geometry]

GoogleMapsPlaceSearch.placedetails(google_api, manhattan)
