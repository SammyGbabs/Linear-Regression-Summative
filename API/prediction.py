import pickle
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import numpy as np

# Load the trained model and scaler from disk
with open('temperature.pkl', 'rb') as f:
    temperature = pickle.load(file)

# Define the FastAPI app
app = FastAPI()

# Define the data model for the input
class PredictRequest(BaseModel):
    population: float
    coastline: int
    latitude: float

# Define the prediction endpoint
@app.post("/predict/")
def predict(data: PredictRequest):
    try:
        # Convert the input data to a numpy array
        input_data = np.array([[
            data.population,
            data.coastline,
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
