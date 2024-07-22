import numpy as np
import pandas as pd
import pickle as pk
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, mean_absolute_error
from sklearn.preprocessing import LabelEncoder
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import r2_score

df = pd.read_csv('Temperature.csv')

# Print some part of the dataset.
df.head()

# Initialize LabelEncoders for each categorical feature
le_city = LabelEncoder()
le_country = LabelEncoder()
le_eu = LabelEncoder()
le_coastline = LabelEncoder()

# Encode each feature and replace the original columns
df['city'] = le_city.fit_transform(df['city'])
df['country'] = le_country.fit_transform(df['country'])
df['EU'] = le_eu.fit_transform(df['EU'])
df['coastline'] = le_coastline.fit_transform(df['coastline'])

# Print the head of the dataframe to check the transformations
print(df.head())

#calculating correlation matrix and plot the heatmap in order to get the important colums
# Calculating the correlation matrix
correlation_matrix = df.corr()

# Plotting the heatmap using Seaborn
plt.figure(figsize=(8, 6))
sns.heatmap(correlation_matrix, annot=True, cmap='coolwarm', vmin=-1, vmax=1)
plt.title('Correlation Matrix Heatmap')
plt.show()

# Display the correlation with the target variable (temperature)
correlation_with_target = correlation_matrix['temperature'].sort_values(ascending=False)
print(correlation_with_target)

# Drop columns with low correlation
df1 = df.drop(['country', 'EU', 'city', 'longitude'], axis=1)

#Checkig the remaining columns that are not dropped
print(df1.columns)

# Define features and target
features = ['population', 'coastline', 'latitude']
target = 'temperature'

X = df1[features]
Y = df1[target]

#Train-Test split
X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.2, random_state=101)

# Initialize the Scaler
scaler = StandardScaler()

# Fit and transform the scaler on the training data, then transform the test data
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Initializing the Linear Regression Model
model = LinearRegression()

# Training the Model
model.fit(X_train_scaled, Y_train)

# Making Predictions
Y_train_pred = model.predict(X_train_scaled)
Y_test_pred = model.predict(X_test_scaled)

# Evaluate the model on the test set
mse_test = mean_squared_error(Y_test, Y_test_pred)
mae_test = mean_absolute_error(Y_test, Y_test_pred)
test_score = model.score(X_test_scaled, Y_test) * 100

# Evaluate the model on the training set
mse_train = mean_squared_error(Y_train, Y_train_pred)
mae_train = mean_absolute_error(Y_train, Y_train_pred)
train_score = model.score(X_train_scaled, Y_train) * 100

# Print the evaluation metrics for the test set
print(f"Test Mean Squared Error (MSE): {mse_test:.4f}")
print(f"Test Mean Absolute Error (MAE): {mae_test:.4f}")
print(f"Test R-squared (R²) score: {test_score:.4f}")

# Print the evaluation metrics for the training set
print(f"Train Mean Squared Error (MSE): {mse_train:.4f}")
print(f"Train Mean Absolute Error (MAE): {mae_train:.4f}")
print(f"Train R-squared (R²) score: {train_score:.4f}")

#Saving my model using pickle
with open('temperature.pkl', 'wb') as file:
    pk.dump(model, file)