import pickle
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import numpy as np

# Load the trained model and scaler from disk
with open('temperature_scaler.pkl', 'rb') as file:
    scaler = pickle.load(file)

with open('temperature_model.pkl', 'rb') as file:
    model = pickle.load(file)

# Define the FastAPI app
app = FastAPI()

# Define the data model for the input
class PredictRequest(BaseModel):
    population: float
    coastline: str  # Changed from int to str
    latitude: float

# Mapping of coastline values
COASTLINE_ENCODING = {
    "yes": 1,
    "no": 0
}

# Define the prediction endpoint
@app.post("/predict/")
def predict(data: PredictRequest):
    try:
        # Convert the coastline value to integer
        if data.coastline not in COASTLINE_ENCODING:
            raise HTTPException(status_code=400, detail="Invalid value for coastline")
        
        coastline_value = COASTLINE_ENCODING[data.coastline]
        
        # Convert the input data to a numpy array
        input_data = np.array([[
            data.population,
            coastline_value,
            data.latitude
        ]])
        
        # Scale the input data
        input_data_scaled = scaler.transform(input_data)
        
        # Make the prediction
        prediction = model.predict(input_data_scaled)
        
        # Return the prediction
        return {"temperature": prediction[0]}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
        
if __name__ == "__main__":
        import uvicorn
        uvicorn.run(app, host="0.0.0.0", port=8000)