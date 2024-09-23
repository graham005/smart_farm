// ignore_for_file: prefer_const_constructors, file_names, unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_farm/models/weather_model.dart';
import 'package:smart_farm/services/weather_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _farmingTip = 'Loading tips...';
  Weather? _weather;
  final WeatherServices _weatherServices = WeatherServices('7b0405875c94434d9b0c05d6247e1222');

  @override
  void initState(){
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    String cityName = await _weatherServices.getCurrentCity();

    try{
      final weather = await _weatherServices.getWeather(cityName);
      setState(() {
        _weather = weather;
        _farmingTip = getFarmingTips(weather.mainCondition);
      });
    } catch (e) {
      setState(() {
        _farmingTip = 'Error fetching weather data. Please try again later.';
      });
    }
  }
  String getFarmingTips(String? mainCondition){
    if (mainCondition == null)return 'No tips available.';

    switch (mainCondition.toLowerCase()){
      case 'clear':
        return 'Great day for planting seeds!';
      case 'rain':
        return 'Check soil moisture; watering is not necessary.';
      case 'snow':
        return 'Ensure crops are protected from frost.';
      case 'cloud':
        return 'Ideal for working in the fields, consider preparing for planting.';
      default:
        return 'Stay updated on the weather for optimal farming.';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("HomePage",style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
            Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
            //showToast(message: "Successfully signed out");
          }, 
          icon: Icon(Icons.logout))
          ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/farm_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment:  MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Text(
              'Welcome to Smart Farm ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white.withOpacity(0.6),
                  ),
              child: Lottie.asset('assets/homepage.json')
            ),
            SizedBox(height: 30),
            Text('Farming tips',style: TextStyle(color: Colors.white),),
            Text(
              _farmingTip, style: TextStyle(
                fontSize: 18, color: Colors.white)),
          ],
            ),
      ));
  }
}