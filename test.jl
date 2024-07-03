using Meshes: Point, coords, PointSet, Domain, GeometrySet
using CoordRefSystems
using Unitful

x = Point(45.2, -73.1)


y = Point(LatLon(-73.2, 45.2))
Cartesian{WGS84Latest}()
"°"
