using GeoTables
using GeoIO
using HTTP
using JSON

const BASEURL::String = "https://data.cityofnewyork.us/resource/8rma-cm9c.geojson"

response::HTTP.Response = HTTP.get(
    BASEURL,
    query = ["\$\$app_token" => "PoXtpm9UpT6UnvUOK8F0lp3Sp", "\$limit" => 100000000],
)

apidata = GeoIO.load(String(response.body))


GeoIO.save("data/streets.geojson", apidata)

