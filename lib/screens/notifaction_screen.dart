import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather_app/models//weather.dart';
import 'package:weather_app/components/location_tile.dart';


class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  SharedPreferences prefs;

  bool isLoading = true; // used to have a ring spin while data comes in

  List<String>
      currentLocationValues; // stores the values from the current location stored on disk

  List<List<String>> storedLocationsValues =
      []; // // stores the values from the list of stored locations stored on disk

  // used to keep track of the user's notification
  int _selectedHour;
  int _selectedMinute;
  bool _isAMSelected;

  @override
  void initState() {
    _getValuesFromMemory();
    super.initState();
  }

  Future<void> _getValuesFromMemory() async {
    prefs = await SharedPreferences.getInstance();

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
          final weather = Weather(
              isFullMoon: prefs.getBool('isFullMoon'),
              isFahrenheit: prefs.getBool('isF'));
          await weather.updateValues(
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

  List<DropdownMenuItem<int>> _getHourItems() {
    List<DropdownMenuItem<int>> hourItems = [];
    for (int index = 1; index < 13; index++) {
      hourItems.add(DropdownMenuItem(
        child: Text('$index'),
        value: index,
      ));
    }
    return hourItems;
  }

  List<DropdownMenuItem<int>> _getMinuteItems() {
    List<DropdownMenuItem<int>> minuteItems = [];
    for (int index = 1; index < 60; index++) {
      minuteItems.add(DropdownMenuItem(
        child: Text('$index'),
        value: index,
      ));
    }
    return minuteItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: GestureDetector(
                      child: Icon(Icons.arrow_back_ios),
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  Text(
                    'Weather App',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade700,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.notifications,
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 150),
          Text(
            'Receive Notifications',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          Divider(
            thickness: 1,
            indent: 100,
            endIndent: 100,
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 105),
            child: Text(
              'Current Location:',
              textAlign: TextAlign.start,
            ),
          ),
          isLoading
              ? SpinKitRing(
                  color: Colors.blueGrey,
                  size: 50,
                )
              :
              // if touched, the UI will update the weather to the user's current location
              LocationTile(
                  padding: EdgeInsets.symmetric(horizontal: 100),
                  cityName: currentLocationValues[0],
                  countryName: currentLocationValues[1],
                  iconPath: currentLocationValues[4],
                  temperature: currentLocationValues[5],
                  callBack: () {},
                ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 105),
            child: Text('Stored Locations:'),
          ),
          isLoading
              ? SpinKitRing(
                  color: Colors.blueGrey,
                  size: 50,
                )
              :
              // if touched, the UI will update the weather to that location
              Container(
                  height: 175,
                  child: ListView.builder(
                    itemCount: storedLocationsValues.length,
                    padding: EdgeInsets.only(top: 0),
                    itemBuilder: (context, index) {
                      return LocationTile(
                        padding: EdgeInsets.symmetric(horizontal: 100),
                        cityName: storedLocationsValues[index][0],
                        countryName: storedLocationsValues[index][1],
                        iconPath: storedLocationsValues[index][4],
                        temperature: storedLocationsValues[index][5],
                        callBack: () {},
                      );
                    },
                  ),
                ),
          SizedBox(height: 30),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 100),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.blueGrey.shade400,
                borderRadius: BorderRadius.circular(30)),
            child: Material(
              elevation: 10,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 5),
                    child: DropdownButton<int>(
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        dropdownColor: Colors.blueGrey.shade700,
                        elevation: 5,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                        value: _selectedHour,
                        items: _getHourItems(),
                        onChanged: (val) {
                          setState(() {
                            _selectedHour = val;
                          });
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      ':',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: DropdownButton<int>(
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        dropdownColor: Colors.blueGrey.shade700,
                        elevation: 5,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                        value: _selectedMinute,
                        items: _getMinuteItems(),
                        onChanged: (val) {
                          setState(() {
                            _selectedMinute = val;
                          });
                        }),
                  ),
                  Container(
                    child: DropdownButton<bool>(
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        dropdownColor: Colors.blueGrey.shade700,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                        elevation: 5,
                        value: _isAMSelected,
                        items: [
                          DropdownMenuItem(
                            child: Text('AM'),
                            value: true,
                          ),
                          DropdownMenuItem(
                            child: Text('PM'),
                            value: false,
                          )
                        ],
                        onChanged: (val) {
                          setState(() {
                            _isAMSelected = val;
                          });
                        }),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: MaterialButton(
              elevation: 10,
              onPressed: () {},
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.blueGrey),
                child: Icon(
                  Icons.notifications,
                  color: Colors.blueGrey.shade400,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
