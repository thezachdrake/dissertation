import Meshes: Point
using GeoStats
using DataFrames

struct TestType
    name::String
    age::Int64
end

testList = []

for i in range(1, 100)
    x = TestType("z", 32)
    push!(testList, x)
end

x = (
    NAME = ["John", "Mary", "Paul", "Anne", "Kate"],
    AGE = [34, 12, 23, 39, 28],
    HEIGHT = [1.78, 1.56, 1.70, 1.80, 1.72],
    GENDER = ["male", "female", "male", "female", "female"],
    POINT = [
        Point(-75.0, 45.0),
        Point(-75.0, 45.0),
        Point(-75.0, 45.0),
        Point(-75.0, 45.0),
        Point(-75.0, 45.0),
    ],
)

georef(x,x.POINT)
