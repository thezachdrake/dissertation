using Meshes: Point, coords, PointSet, Domain, GeometrySet
using CoordRefSystems
using Unitful

x = Point(45.2, -73.1)


y = Point(LatLon(-73.2, 45.2))
Cartesian{WGS84Latest}()
"°"
for (i, v) in enumerate(eachrow(values(incidents)))
    println(i)
end

function test_print(x::String, y::Int64)
    println(x)
    println(y)
end

test_print(43, "some text")