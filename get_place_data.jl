using Shapefile
using DataFrames

table = Shapefile.Table("data/NYC Street Centerline (CSCL)/geo_export_5e9428cd-5d0e-4708-9fe2-5b104108e9e4.shp")

centerline = DataFrame(table)

streetTypes = [1]
filter!(:rw_type => in(streetTypes), centerline)

filter!(:borocode => ==("1"), centerline)