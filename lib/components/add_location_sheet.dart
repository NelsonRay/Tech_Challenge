import 'package:flutter/material.dart';
import 'package:weather_app/screens/weather_screen.dart';

import 'package:weather_app/services/location.dart';

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
              style: TextStyle(fontSize: 20),
            ),
            Divider(
              endIndent: 100,
              indent: 100,
              thickness: 1,
            ),
            Container(
              child: TextField(
                autofocus: true,
                textAlign: TextAlign.center,
                onSubmitted: (locality) async {
                  try {
                    Location location = Location();
                    await location.getALocation(locality: locality);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WeatherScreen(
                          lat: location.latitude,
                          lon: location.longitude,
                          cityName: location.cityName,
                          countryName: location.countyName,
                        ),
                      ),
                    );
                  } catch (e) {
                    print(e);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WeatherScreen(
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
