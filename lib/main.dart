import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherApp(),
      theme: ThemeData(
        primarySwatch: Colors.deepPurple
      ),
    );
  }
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final String apiKey = '856428df1ccd4f52a4f75237231909';
  final TextEditingController locationController = TextEditingController();
  String location = 'Chennai';
  String imageUrl = '';
  String name = '';
  String region = '';
  String country = '';
  String localtime = '';
  double tempCelsius = 0.0;
  String conditionText = '';

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    final response = await http.get(
      Uri.parse('http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$location&aqi=no'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        imageUrl = data['current']['condition']['icon'];
        name = data['location']['name'];
        region = data['location']['region'];
        country = data['location']['country'];
        localtime = data['location']['localtime'];
        tempCelsius = data['current']['temp_c'];
        conditionText = data['current']['condition']['text'];
      });
    }
  }

  void reloadWeatherData() {
    fetchWeatherData();
  }

  void changeLocation() {
    setState(() {
      location = locationController.text;
    });
    fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.cloud_circle,size: 35,),
            Text('WEATHER',style: TextStyle(fontSize: 25,fontStyle: FontStyle.italic),),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Image.network('http:$imageUrl',height: 100,width: 100,fit: BoxFit.cover,),
              SizedBox(height: 20),
              Text('Location: $name, $region, $country',style: TextStyle(fontSize: 18),),
              SizedBox(height: 8),
              Text('Local Time: $localtime',style: TextStyle(fontSize: 18),),
              SizedBox(height: 8),
              Text('Temperature: ${tempCelsius.toStringAsFixed(1)}°C',style: TextStyle(fontSize: 18),),
              SizedBox(height: 8),
              Text('Condition: $conditionText',style: TextStyle(fontSize: 18),),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 2, color: Colors.deepPurple),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        prefixIcon: Icon(Icons.location_on),
                        hintText: "Enter Location",
                        hintStyle: TextStyle(fontSize: 20),
                    ),),
                  )
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: changeLocation,
                    child: Text('Change Location',style: TextStyle(fontSize: 18),),
                  ),
                  ElevatedButton(
                    onPressed: reloadWeatherData,
                    child: Text('Refresh',style: TextStyle(fontSize: 18),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
