from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from urllib.request import urlopen 
import json
import datetime
from pydantic import BaseModel

app = FastAPI()

origins = [
    "*",
]
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ISO 8601 format (e.g., "2024-05-23T00:00:00")
# {
#     "start_time": "2024-05-23T00:00:00",
#     "end_time": "2024-09-23T00:00:00"
# }
class TimeStamp(BaseModel):
    start_time: str
    end_time: str


def get_earthquake_data(url):
    with urlopen(url) as response:
        data = response.read()
        return json.loads(data)

def filter(json_data):
    filtered_data = {
        "count": json_data["metadata"]["count"],
        "features": []    
    }
    print("Filtering data...")
    for id_, feature in enumerate(json_data["features"]):        
        filtered_data["features"].append({
            "id": id_,
            "type": feature["properties"]["type"].lower(),
            "magnitude": feature["properties"]["mag"],
            "location": feature["properties"]["place"],
            "time": datetime.datetime.utcfromtimestamp(feature["properties"]["time"] / 1000),
            "felt": feature["properties"]["felt"],
            "cdi": feature["properties"]["cdi"],
            "mmi": feature["properties"]["mmi"],
            "sig": feature["properties"]["sig"],
            "nst": feature["properties"]["nst"],
            "rms": feature["properties"]["rms"],
            "dmin": feature["properties"]["dmin"],
            "gap": feature["properties"]["gap"] # TODO: Implement caching or pagination for larger datasets.
        })
    return filtered_data

@app.get("/")
async def root():
    return {"message": "Hello World" }

@app.get("/data_all")
async def data_all():
    start_time = "2024-05-23%2000:00:00"  
    end_time = "2024-10-23%2000:00:00"
    q_str = f"https://earthquake.usgs.gov/fdsnws/event/1/query.geojson?starttime={start_time}&endtime={end_time}&maxlatitude=42.003&minlatitude=37.006&maxlongitude=-109.05&minlongitude=-114.038&minmagnitude=2.5&orderby=time"
    res = get_earthquake_data(q_str)
    if res["metadata"]["status"] == 200:
        # print("success")
        filtered_data = filter(res)
        return filtered_data
        # return res
    else:
        return {"error": res["metadata"]["message"]}

@app.post("/get_data")
async def get_data(timestamp: TimeStamp):
    start_time = datetime.datetime.fromisoformat(timestamp.start_time)
    start_time = start_time.strftime("%Y-%m-%d %H:%M:%S").replace(" ", "%20")
    print(start_time)
    end_time = datetime.datetime.fromisoformat(timestamp.end_time)
    end_time = end_time.strftime("%Y-%m-%d %H:%M:%S").replace(" ", "%20")
    print(end_time)

    q_str = f"https://earthquake.usgs.gov/fdsnws/event/1/query.geojson?starttime={start_time}&endtime={end_time}&maxlatitude=42.003&minlatitude=37.006&maxlongitude=-109.05&minlongitude=-114.038&minmagnitude=2.5&orderby=time"
    res = get_earthquake_data(q_str)
    if res["metadata"]["status"] == 200:
        print("successfully scraped data")
        filtered_data = filter(res)
        print(filtered_data)
        return filtered_data
        # return res
    else:
        return {"error": res["metadata"]["message"]}
