import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flushbar/flushbar.dart';

import 'package:weather_app/services/locationData.dart';

import 'package:weather_app/components/weather_drawer.dart';
import 'package:weather_app/components/page.dart';

import 'package:weather_app/screens/notifaction_screen.dart';

import 'package:weather_app/models/location.dart';
import 'package:weather_app/models/weather.dart';

class WeatherScreen extends StatefulWidget {
  final Location location;
  final bool hasError; // if true, an error snackbar will appear
  final bool
      isCurrentLocation; //used to know if the weather shown is the user's current location or not so the app can know what to add to the disk with Shared Preferences
  final bool onDisk;

  WeatherScreen({
    this.location,
    this.hasError = false,
    this.isCurrentLocation = false,
    this.onDisk = false,
  });

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool isLoading = true; // used to display a spinning ring while data comes in

  Weather weather;

  PageController _controller = PageController(initialPage: 0, keepPage: true);

  GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // used to open scaffold drawer

  // stores initial preferences for comparison later if they are changes from the drawer
  bool preferredMoon;
  bool preferredDegrees;

  @override
  void initState() {
    super.initState();
    getWeather();
    if (widget.hasError) _showError();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // function is used to provide a stream of isDrawerOpen bool values
  Stream<bool> _isOpenStream() async* {
    while (true) {
      await Future.delayed(Duration(microseconds: 3));
      yield _scaffoldKey.currentState.isDrawerOpen;
      if (!_scaffoldKey.currentState.isDrawerOpen) break;
    }
  }

  // uses above function to know when the drawer eventually closes and sees if there were any preference changes in the drawer. If so, it will update the UI.
  void _wereChanges() async {
    await for (bool value in _isOpenStream()) {
      if (!value) {
        break;
      }
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('isF') != preferredDegrees ||
        prefs.getBool('isFullMoon') != preferredMoon) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherScreen(
            isCurrentLocation: widget.isCurrentLocation,
            location: widget.location,
            onDisk: true,
          ),
        ),
      );
    }
  }

  // uses the coordinates that constructed this screen to assign the weather with the user's preferences to the weather instance
  // it also loops through the user's stored locations to add another location at the end
  void getWeather() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    weather = Weather(
      isFahrenheit: prefs.getBool('isF'),
      isFullMoon: prefs.getBool('isFullMoon'),
    );

    await weather.updateValues(
        lat: widget.location.latitude, lon: widget.location.longitude);

    // assign preferred values to variables that will be checked in function _wereChanges() to see if UI needs to update
    preferredMoon = prefs.getBool('isFullMoon');
    preferredDegrees = prefs.getBool('isF');

    if (!widget.onDisk) {
      if (widget.isCurrentLocation) {
        await prefs.setStringList('current', [
          widget.location.city,
          widget.location.country,
          widget.location.latitude.toString(),
          widget.location.longitude.toString(),
          weather.iconPaths[0],
          weather.temperatures[0],
          DateTime.now().hour.toString(),
        ]);
      } else {
        for (int index = 0; index >= 0; index++) {
          if (!prefs.containsKey(index.toString())) {
            await prefs.setStringList('$index', [
              widget.location.city,
              widget.location.country,
              widget.location.latitude.toString(),
              widget.location.longitude.toString(),
              weather.iconPaths[0],
              weather.temperatures[0],
              DateTime.now().hour.toString(),
            ]);
            break;
          }
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  void _showError() async {
    await Future.delayed(Duration(milliseconds: 1));
    Flushbar(
      duration: Duration(seconds: 4),
      flushbarPosition: FlushbarPosition.TOP,
      padding: EdgeInsets.all(10),
      titleText: Text(
        'Error',
        style: TextStyle(color: Colors.red.shade700),
      ),
      messageText: Text(
        'No Location Was Entered or No Such Entered Location',
        style: TextStyle(color: Colors.white),
      ),
      forwardAnimationCurve: Curves.decelerate,
      backgroundColor: Colors.blueGrey.shade400,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      drawer: WeatherDrawer(),
      body: isLoading
          ? SpinKitRing(color: Colors.blueGrey)
          : Column(
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
                            child: Icon(Icons.menu),
                            onTap: () {
                              _scaffoldKey.currentState.openDrawer();
                              _wereChanges();
                            },
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
                          child: GestureDetector(
                            child: Icon(Icons.notifications),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NotificationScreen(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${widget.location.city}, ${widget.location.country}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.blueGrey.shade800,
                            ),
                          ),
                          if (widget.isCurrentLocation)
                            Icon(
                              Icons.location_on,
                              size: 20,
                            )
                        ],
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: PageView.builder(
                          controller: _controller,
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          itemCount: 8,
                          itemBuilder: (context, index) {
                            return PageWidget(
                              weather: weather,
                              index: index,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: GestureDetector(
                          child: Icon(Icons.location_on),
                          // gets the user's current location and updates the UI
                          onTap: () async {
                            final locationData = LocationData();
                            final location = Location();
                            location.updateValues(
                                values:
                                    await locationData.getCurrentLocation());
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WeatherScreen(
                                  location: location,
                                  isCurrentLocation: true,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SmoothPageIndicator(
                        controller: _controller,
                        count: 8,
                        effect: ColorTransitionEffect(
                          dotHeight: 12,
                          dotWidth: 12,
                          spacing: 10,
                          activeDotColor: Colors.blueGrey.shade700,
                          dotColor: Colors.blueGrey.shade200,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: GestureDetector(
                          child: Icon(Icons.arrow_drop_up),
                          onTap: () => _showError(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
