using GeoTables
import GeoIO: save, load
import HTTP: Response, get
using JSON

function GetStreetData()
    response::Response = get(
        "https://data.cityofnewyork.us/resource/8rma-cm9c.geojson";
        query = ["\$\$app_token" => ENV["SODA_KEY"], "\$limit" => 100000000],
    )

    rawdata = load(String(response.body))
    return save("data/streets.geojson", rawdata)
end
