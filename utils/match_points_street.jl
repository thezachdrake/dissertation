import Meshes: KNearestSearch, searchdists
import Unitful: ustrip
import Distances: Cityblock

function match_points_streets(points::GeoTable, streets::GeoTable)::DataFrame

    knn::KNearestSearch = KNearestSearch(streets.geometry, 1, metric=Cityblock())
    distnace_lookups = Vector{Dict}()
    for point in points.geometry
        point_lookup = nearest_street_to_point(point, knn)
        push!(distnace_lookups, point_lookup)
    end

    return DataFrame(distnace_lookups)
end

function nearest_street_to_point(p::Point, search::KNearestSearch)::Dict{String,Any}
    neighbors, distances = searchdists(p, search)
    neighbors_distance_lookup = Dict{String,Any}()
    num_neighbors::Int64 = length(neighbors)
    for i in num_neighbors
        neighbors_distance_lookup["point"] = p
        neighbors_distance_lookup["street_idx"] = @inbounds neighbors[i]
        neighbors_distance_lookup["distance"] = @inbounds ustrip(distances[i])
    end

    return neighbors_distance_lookup
end