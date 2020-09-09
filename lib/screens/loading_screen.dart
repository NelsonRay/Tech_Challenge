import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:weather_app/services/locationData.dart';
import 'package:weather_app/models/location.dart';

import 'package:weather_app/screens/weather_screen.dart';

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
    // assigns current coordinates to the location instance
    final locationData = LocationData();
    final location = Location();
    final prefs = await SharedPreferences.getInstance();

    final values = await locationData.getCurrentLocation();

    location.updateValues(values: values);

    // assigns preferences if the user hasn't made any thus far
    if (!prefs.containsKey('isFullMoon')) {
      prefs.setBool('isFullMoon', true);
    }
    if (!prefs.containsKey('isF')) {
      prefs.setBool('isF', true);
    }

    // pushes to the weather screen, providing the needed coordinates, name of location, and says it is providing the user's current location
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeatherScreen(
          location: location,
          isCurrentLocation: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
