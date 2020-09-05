import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:weather_app/services/weather.dart';
import 'package:weather_app/services/location.dart';

import 'package:weather_app/components/weather_drawer.dart';
import 'package:weather_app/components/error_card.dart';
import 'package:weather_app/components/page.dart';

class WeatherScreen extends StatefulWidget {
  final String cityName;
  final String countryName;
  final double lon;
  final double lat;
  final bool hasError; // if true, an ErrorCard will be shown
  final bool
      isCurrentLocation; //used to know if the weather shown is the user's current location or not so the app can know what to add to the disk with Shared Preferences

  WeatherScreen({
    this.cityName,
    this.countryName,
    this.lon,
    this.lat,
    this.hasError = false,
    this.isCurrentLocation = false,
  });

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool isLoading = true; // used to display a spinning ring while data comes in

  Weather weather;

  PageController _controller = PageController(initialPage: 0, keepPage: true);

  GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>(); // used to open scaffold drawer

  // stores initial preferences for comparison later if they are changes from the drawer
  bool preferredMoon;
  bool preferredDegrees;

  @override
  void initState() {
    if (widget.hasError)
      isLoading = false; // sets isLoading to false, so the ErrorCard is shown
    if (!widget.hasError) getWeather();
    super.initState();
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
      yield scaffoldKey.currentState.isDrawerOpen;
      if (!scaffoldKey.currentState.isDrawerOpen) break;
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
            countryName: widget.countryName,
            cityName: widget.cityName,
            lon: widget.lon,
            lat: widget.lat,
            hasError: widget.hasError,
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
        isFullMoon: prefs.getBool('isFullMoon'));

    await weather.getWeatherData(lat: widget.lat, lon: widget.lon);

    // assign preferred values to variables that will be checked in function _wereChanges() to see if UI needs to update
    preferredMoon = prefs.getBool('isFullMoon');
    preferredDegrees = prefs.getBool('isF');

    if (widget.isCurrentLocation) {
      await prefs.setStringList('current', [
        widget.cityName,
        widget.countryName,
        '${widget.lat}',
        '${widget.lon}',
        weather.iconPaths[0],
        weather.temperatures[0],
        DateTime.now().hour.toString(),
      ]);
    } else {
      for (int index = 0; index >= 0; index++) {
        if (prefs.containsKey(index.toString())) {
          await prefs.setStringList('${index + 1}', [
            widget.cityName,
            widget.countryName,
            '${widget.lat}',
            '${widget.lon}',
            weather.iconPaths[0],
            weather.temperatures[0],
            DateTime.now().hour.toString(),
          ]);
          break;
        } else {
          if (!prefs.containsKey('0')) {
            await prefs.setStringList('0', [
              widget.cityName,
              widget.countryName,
              '${widget.lat}',
              '${widget.lon}',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      backgroundColor: Color(0xFFE5F0FC),
      drawer: WeatherDrawer(),
      body: isLoading
          ? SpinKitRing(color: Colors.blueGrey)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
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
                            child: Icon(
                              Icons.menu,
                              size: 30,
                            ),
                            onTap: () {
                              scaffoldKey.currentState.openDrawer();
                              _wereChanges();
                            },
                          ),
                        ),
                        Text(
                          'Weather App',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Icon(Icons.notifications, size: 30),
                        ),
                      ],
                    ),
                  ),
                ),

                // if hasError is true, then an ErrorCard will be shown

                !widget.hasError
                    ? Expanded(
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            Text(
                              '${widget.cityName}, ${widget.countryName}',
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Expanded(
                              child: PageView.builder(
                                controller: _controller,
                                scrollDirection: Axis.vertical,
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
                      )
                    : ErrorCard(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: GestureDetector(
                          child: Icon(
                            Icons.location_on,
                            size: 30,
                          ),
                          // gets the user's current location and updates the UI
                          onTap: () async {
                            Location location = Location();
                            await location.getCurrentLocation();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WeatherScreen(
                                  cityName: location.cityName,
                                  countryName: location.countyName,
                                  lat: location.latitude,
                                  lon: location.longitude,
                                  isCurrentLocation: true,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // dot indicator will go away if hasError is true
                      if (!widget.hasError)
                        SmoothPageIndicator(
                          controller: _controller,
                          count: 8,
                          effect: ColorTransitionEffect(
                            dotHeight: 12,
                            dotWidth: 12,
                            spacing: 10,
                            activeDotColor: Colors.blueGrey,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: GestureDetector(
                          child: Icon(
                            Icons.arrow_drop_up,
                            size: 30,
                          ),
                          onTap: () {},
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
