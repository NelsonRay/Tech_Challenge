import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:weather_app/services/weather.dart';

import 'package:weather_app/components/location_tile.dart';
import 'package:weather_app/components/add_location_sheet.dart';
import 'package:weather_app/components/toggle_button.dart';

enum Moon { full, half }

enum Degrees { fahrenheit, celsius }

class WeatherDrawer extends StatefulWidget {
  @override
  _WeatherDrawerState createState() => _WeatherDrawerState();
}

class _WeatherDrawerState extends State<WeatherDrawer> {
  SharedPreferences prefs;

  bool isLoading = true; // used to have a ring spin while data comes in

  List<String>
      currentLocationValues; // stores the values from the current location stored on disk

  List<List<String>> storedLocationsValues =
      []; // // stores the values from the list of stored locations stored on disk

  Moon _selectedMoon; // used to know which of the toggle buttons is active
  Degrees
      _selectedDegrees; // used to know which of the toggle buttons is active

  @override
  void initState() {
    _getValuesFromMemory();
    super.initState();
  }

  Future<void> _getValuesFromMemory() async {
    prefs = await SharedPreferences.getInstance();

    // assign the preferred types of moons and degrees to variables that can be used throughout the component and passed into a weather object
    if (prefs.getBool('isFullMoon')) {
      _selectedMoon = Moon.full;
    } else {
      _selectedMoon = Moon.half;
    }

    if (prefs.getBool('isF')) {
      _selectedDegrees = Degrees.fahrenheit;
    } else {
      _selectedDegrees = Degrees.celsius;
    }

    // assignment the values from the user's current location saved on disk
    currentLocationValues = prefs.getStringList('current');

    // assign the values of the user's stored location to a list variable or update them if the hour has changed and then assign them
    for (int index = 0; index >= 0; index++) {
      if (prefs.containsKey(index.toString())) {
        if (int.parse(prefs.getStringList(index.toString())[6]) ==
            DateTime.now().hour) {
          // Problem: if the same hour the next day, this will be true
          storedLocationsValues.add(prefs.getStringList(index.toString()));
        } else {
          Weather weather = Weather(
              isFullMoon: prefs.getBool('isFullMoon'),
              isFahrenheit: prefs.getBool('isF'));
          await weather.getWeatherData(
              lon: double.parse(prefs.getStringList('$index')[3]),
              lat: double.parse(prefs.getStringList('$index')[2]));
          prefs.setStringList('$index', [
            prefs.getStringList('$index')[0],
            prefs.getStringList('$index')[1],
            prefs.getStringList('$index')[2],
            prefs.getStringList('$index')[3],
            weather.iconPaths[0],
            weather.temperatures[0],
            DateTime.now().hour.toString()
          ]);
          storedLocationsValues.add(prefs.getStringList(index.toString()));
        }
      } else {
        break;
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  // used to know which part of each toggle button is active
  bool isActive({Moon moon, Degrees degrees}) {
    if (degrees == null) {
      if (moon == Moon.full) {
        return _selectedMoon == Moon.full;
      } else {
        return _selectedMoon == Moon.half;
      }
    } else {
      if (degrees == Degrees.fahrenheit) {
        return _selectedDegrees == Degrees.fahrenheit;
      } else {
        return _selectedDegrees == Degrees.celsius;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Drawer(
        elevation: 5,
        child: Container(
          color: Color(0xFFE5F0FC),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100, bottom: 50),
                child: Text(
                  'Weather App',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              MaterialButton(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blueGrey.shade600,
                  ),
                  padding: EdgeInsets.all(5),
                  child: Text(
                    'Add Location',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  await Future.delayed(Duration(microseconds: 1));
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return AddLocationSheet();
                      });
                },
              ),
              SizedBox(height: 30),
              Text(
                'Current Location:',
                textAlign: TextAlign.start,
              ),
              isLoading
                  ? SpinKitRing(
                      color: Colors.blueGrey,
                      size: 50,
                    )
                  : LocationTile(
                      cityName: currentLocationValues[0],
                      countryName: currentLocationValues[1],
                      iconPath: currentLocationValues[4],
                      temperature: currentLocationValues[5],
                    ),
              SizedBox(height: 20),
              Text('Stored Locations:'),
              isLoading
                  ? SpinKitRing(
                      color: Colors.blueGrey,
                      size: 50,
                    )
                  : Expanded(
                      child: Container(
                        child: ListView.builder(
                          itemCount: storedLocationsValues.length,
                          padding: EdgeInsets.only(top: 0),
                          itemBuilder: (context, index) {
                            return LocationTile(
                              cityName: storedLocationsValues[index][0],
                              countryName: storedLocationsValues[index][1],
                              iconPath: storedLocationsValues[index][4],
                              temperature: storedLocationsValues[index][5],
                            );
                          },
                        ),
                      ),
                    ),
              Divider(
                height: 30,
                color: Colors.blueGrey,
                thickness: 1,
                indent: 25,
                endIndent: 25,
              ),
              ToggleButton(
                padding: EdgeInsets.only(bottom: 20),
                firstChild: Text(
                  '°F',
                  style: TextStyle(
                    fontSize: 20,
                    color: isActive(degrees: Degrees.fahrenheit)
                        ? Colors.white
                        : Colors.blueGrey,
                  ),
                ),
                firstColor: isActive(degrees: Degrees.fahrenheit)
                    ? Colors.blueGrey
                    : Colors.white,
                firstCallback: () {
                  setState(() {
                    _selectedDegrees = Degrees.fahrenheit;
                  });
                  prefs.setBool('isF', true);
                },
                secondChild: Text(
                  '°C',
                  style: TextStyle(
                    fontSize: 20,
                    color: isActive(degrees: Degrees.fahrenheit)
                        ? Colors.blueGrey
                        : Colors.white,
                  ),
                ),
                secondColor: isActive(degrees: Degrees.celsius)
                    ? Colors.blueGrey
                    : Colors.white,
                secondCallback: () {
                  setState(() {
                    _selectedDegrees = Degrees.celsius;
                  });
                  prefs.setBool('isF', false);
                },
              ),
              ToggleButton(
                padding: EdgeInsets.only(bottom: 100),
                firstChild: Image.asset('assests/icons/01n.png', height: 30),
                firstColor:
                    isActive(moon: Moon.full) ? Colors.blueGrey : Colors.white,
                firstCallback: () {
                  setState(() {
                    _selectedMoon = Moon.full;
                  });
                  prefs.setBool('isFullMoon', true);
                },
                secondChild: Image.asset('assests/icons/h01n.png', height: 30),
                secondColor:
                    isActive(moon: Moon.half) ? Colors.blueGrey : Colors.white,
                secondCallback: () {
                  setState(() {
                    _selectedMoon = Moon.half;
                  });
                  prefs.setBool('isFullMoon', false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
