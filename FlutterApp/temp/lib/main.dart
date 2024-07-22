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
  final TextEditingController _input1Controller = TextEditingController();
  final TextEditingController _input2Controller = TextEditingController();
  final TextEditingController _input3Controller = TextEditingController();
  String _result = '';
  String _coastlineValue = ''; // No default value

  // Function to encode the coastline value
  int _encodeCoastline(String value) {
    if (value == 'yes') {
      return 1;
    } else {
      return 0; // Default value for 'no'
    }
  }

  Future<void> _predict() async {
    if (_formKey.currentState!.validate()) {
      final String input1 = _input1Controller.text;
      final String input2 = _input2Controller.text;
      final String input3 = _input3Controller.text;

      final double value1 = double.parse(input1);
      final int value2 = _encodeCoastline(_coastlineValue);
      final double value3 = double.parse(input3);

      final String apiUrl = 'https://linear-regression-summative.onrender.com/predict/'; // Adjust URL as needed
      final Map<String, dynamic> requestData = {
        'population': value1,
        'coastline': value2,
        'latitude': value3,
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
                  controller: _input1Controller,
                  decoration: InputDecoration(
                    labelText: 'Input Value 1',
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
                DropdownButtonFormField<String>(
                  value: _coastlineValue.isEmpty ? null : _coastlineValue,
                  decoration: InputDecoration(
                    labelText: 'Coastline',
                    prefixIcon: Icon(Icons.map),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.teal.shade50,
                  ),
                  items: ['yes', 'no'].map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _coastlineValue = value ?? '';
                    });
                  },
                  hint: Text('Select coastline'), // Placeholder text when no option is selected
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _input3Controller,
                  decoration: InputDecoration(
                    labelText: 'Input Value 3',
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