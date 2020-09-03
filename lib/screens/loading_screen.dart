import 'package:flutter/material.dart';

import 'package:weather_app/services/location.dart';

import 'package:weather_app/screens/weather_screen.dart';
import 'package:weather_app/services/weather.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    nextScreen();
    super.initState();
  }

  Future<void> nextScreen() async {
    Location location = Location();
    await location.getCurrentLocation();

    await Future.delayed(Duration(seconds: 3));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeatherScreen(
          lat: location.latitude,
          lon: location.longitude,
          locality: location.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5F0FC),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Weather App',
              style: TextStyle(
                color: Colors.black,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Image.asset('assests/icons/02d.png'),
          ],
        ),
      ),
    );
  }
}
