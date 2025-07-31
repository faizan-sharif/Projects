from fastapi import FastAPI
from pydantic import BaseModel
import pandas as pd

app = FastAPI()

# Load CSV files
df = pd.read_csv('predictions.csv')
df2 = pd.read_csv('typhoon_name.csv')

# Pydantic model to structure the response
class CyclonePath(BaseModel):
    latitude: float
    longitude: float
    year: int
    name: str  # Add name to the response model

@app.get("/cyclone-path/", response_model=list[CyclonePath])
async def get_cyclone_path():
    cyclone_path = df[["Year",'Predicted_Latitude', 'Predicted_Longitude']].dropna()

    names = df2['en'].tolist()
    path = []

    for i, (_, row) in enumerate(cyclone_path.iterrows()):
        name = names[i] if i < len(names) else "Unnamed"  # Use "Unnamed" if name is not available
        path.append(CyclonePath(
            latitude=row['Predicted_Latitude'],
            longitude=row['Predicted_Longitude'],
            year=row['Year'],
            name=name
        ))

    return path
