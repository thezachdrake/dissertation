import requests
import pandas
import geopandas

url_params ={"$$app_token":"PoXtpm9UpT6UnvUOK8F0lp3Sp", 
                "$where":"(borocode='1' AND rw_type='1')",
                "$limit": "10000000"}

streets = geopandas.read_file(
    requests.get("https://data.cityofnewyork.us/resource/8rma-cm9c.geojson", 
    params=url_params).text).to_crs(epsg=2263)

url_params ={"$$app_token":"PoXtpm9UpT6UnvUOK8F0lp3Sp", 
                "$where":"(boro_nm='MANHATTAN')",
                "$limit": "10000000"}

incidents = geopandas.read_file(
    requests.get("https://data.cityofnewyork.us/resource/5uac-w243.geojson", 
    params=url_params).text).to_crs(epsg=2263)

test_df = geopandas.sjoin_nearest(streets, incidents, max_distance=5, distance_col="dist")

test_df.groupby(['physicalid']).count()["cmplnt_num"].min()