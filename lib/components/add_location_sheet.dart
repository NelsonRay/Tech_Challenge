import 'package:flutter/material.dart';
import 'package:weather_app/screens/weather_screen.dart';

import 'package:weather_app/services/locationData.dart';

import 'package:weather_app/models/location.dart';

class AddLocationSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
          color: Color(0xFFE5F0FC),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            Text(
              'Add Location:',
              style: TextStyle(
                fontSize: 25,
                color: Colors.blueGrey.shade700,
              ),
            ),
            Divider(
              endIndent: 100,
              indent: 100,
              thickness: 1,
            ),
            Container(
              child: TextField(
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blueGrey.shade700,
                ),
                autofocus: true,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'New Location',
                  hintStyle: TextStyle(
                    color: Colors.blueGrey.shade300,
                    fontSize: 20,
                  ),
                ),
                onSubmitted: (locality) async {
                  final locationData = LocationData();
                  final location = Location();

                  try {
                    location.updateValues(values: await locationData.getALocation(locality: locality));

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WeatherScreen(
                          location: location,
                        ),
                      ),
                    );
                  } catch (e) {
                    location.updateValues(values:  await locationData.getCurrentLocation());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WeatherScreen(
                          location: location,
                          isCurrentLocation: true,
                          hasError: true,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
