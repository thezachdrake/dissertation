import Meshes: KNearestSearch, searchdists
import Unitful: ustrip
import Distances: Cityblock
import GeoTables: tablejoin

function match_points_streets!(points::GeoTable, streets::GeoTable)::DataFrame

    knn::KNearestSearch = KNearestSearch(streets.geometry, 1, metric=Cityblock())
    distances = []
    neighbors = []
    for point in points.geometry
        neighbor, distance = searchdists(point, knn)
        append!(neighbors, neighbor)
        append!(distances, ustrip(distance))
    end

    data_table::DataFrame = deepcopy(values(points))
    data_table[!, :distance] .= distances
    data_table[!, :street_id] .= string.(neighbors)

    return data_table
end
