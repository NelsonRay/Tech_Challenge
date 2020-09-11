import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:weather_app/services/locationData.dart';

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
    final location = await LocationData().getCurrentLocation();
    final prefs = await SharedPreferences.getInstance();

    // assigns preferences if the user hasn't made any thus far
    if (!prefs.containsKey('isFullMoon')) {
      prefs.setBool('isFullMoon', true);
    }
    if (!prefs.containsKey('isF')) {
      prefs.setBool('isF', true);
    }

    for (int index = 0; index < 10; index++) {
      prefs.remove('$index');
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
            const Text(
              'Weather App',
              style: TextStyle(
                color: Colors.black,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Image.asset('assests/icons/02d.png'),
          ],
        ),
      ),
    );
  }
}
