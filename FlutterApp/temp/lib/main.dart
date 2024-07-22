import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Prediction App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: PredictionPage(),
    );
  }
}

class PredictionPage extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _populationController = TextEditingController();
  final TextEditingController _coastlineController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  String _result = '';

  Future<void> _predict() async {
    if (_formKey.currentState!.validate()) {
      final String population = _populationController.text;
      final String coastline = _coastlineController.text;
      final String latitude = _latitudeController.text;

      final double populationValue = double.parse(population);
      final int coastlineValue = int.parse(coastline);
      final double latitudeValue = double.parse(latitude);

      final String apiUrl = 'https://linear-regression-summative.onrender.com/predict/';
      final Map<String, dynamic> requestData = {
        'population': populationValue,
        'coastline': coastlineValue,
        'latitude': latitudeValue,
      };

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(requestData),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          setState(() {
            _result = 'Prediction: ${responseData['temperature']}';
          });
        } else {
          setState(() {
            _result = 'Error: ${response.statusCode}';
          });
        }
      } catch (e) {
        setState(() {
          _result = 'Failed to get prediction.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Prediction App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.whatshot,
                  size: 100,
                  color: Colors.teal,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _populationController,
                  decoration: InputDecoration(
                    labelText: 'Population',
                    prefixIcon: Icon(Icons.input),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.teal.shade50,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _coastlineController,
                  decoration: InputDecoration(
                    labelText: 'Coastline',
                    prefixIcon: Icon(Icons.input),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.teal.shade50,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _latitudeController,
                  decoration: InputDecoration(
                    labelText: 'Latitude',
                    prefixIcon: Icon(Icons.input),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.teal.shade50,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _predict,
                  child: Text('Predict'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _result,
                    style: TextStyle(fontSize: 18, color: Colors.teal.shade900),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
