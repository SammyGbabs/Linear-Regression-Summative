# Temperature Prediction API

## Overview

This project provides a RESTful API that predicts temperature based on input values. The API is publicly available and can be used to get temperature predictions using a pre-trained model.

## API Endpoints
- Base URL: https://linear-regression-summative.onrender.com/predict/

- Endpoint for Predictions: /predict/

### Predict Route

**`POST /predict/`**

- **Description:** Makes a prediction based on the provided information.
- **Request Body:**
  ```json
  {
    "population": <population here>,  // (float) The population value
    "coastline": "<coastline status here>", // (string) "yes" or "no"
    "latitude": <latitude here>      // (float) The latitude value
  }

Response Body:

{
"temperature": <temperature here>  // (float) The predicted temperature
}