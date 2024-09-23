// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_farm/models/weather_model.dart';
import 'package:smart_farm/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  final _weatherService = WeatherServices('7b0405875c94434d9b0c05d6247e1222');
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try{
      final weather = await _weatherService.getWeather(cityName);
      if(mounted) {
         setState(() {
          _weather = weather;
        });
      }   
    }
    catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition){
    if(mainCondition == null)return 'assets/sunny.json';
    
    switch (mainCondition.toLowerCase()){
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunderstorm.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Weather")),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
       automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/farm_background.jpg'), // Add your farm background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // CityName
              Text(_weather?.cityName ?? "loading city..", 
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, 
              color: Colors.black),),
              
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
        
              // Temperature
              Text('${_weather?.temparature.round()}℃', 
              style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white),),
        
              // Weather condition
              Text(_weather?.mainCondition ?? "", 
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, 
              color: Colors.white),),
        
            ],),
        ),
      ),
    );
  }
}