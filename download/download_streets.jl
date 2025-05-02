using GeoTables
import GeoIO
import HTTP
using JSON

function GetStreetData()
    response::HTTP.Response = get(
        "https://data.cityofnewyork.us/resource/inkn-q76z.geojson";
        query=["\$\$app_token" => ENV["SODA_KEY"], "\$limit" => 100000000],
    )
    filepath = "data/streets.geojson"
    write(filepath, response.body)
    @info "Saved data to '$filepath'"
end
