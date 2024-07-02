using GeoTables
import GeoIO: save, load
import HTTP: Response, get
using JSON

const BASE_URL::String = "https://data.cityofnewyork.us/resource/8rma-cm9c.geojson"

response::Response = get(
    BASE_URL;
    query = ["\$\$app_token" => "PoXtpm9UpT6UnvUOK8F0lp3Sp", "\$limit" => 100000000],
)

rawdata = load(String(response.body))
save("data/streets.geojson", rawdata)
