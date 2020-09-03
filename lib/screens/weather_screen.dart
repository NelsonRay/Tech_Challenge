import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:weather_app/services/weather.dart';

import 'package:weather_app/components/add_location_sheet.dart';
import 'package:weather_app/components/location_tile.dart';

import 'package:weather_app/screens/page.dart';

class WeatherScreen extends StatefulWidget {
  final String locality;
  final double lon;
  final double lat;
  final String errorMessage;

  WeatherScreen({this.locality, this.lon, this.lat, this.errorMessage});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool isLoading;
  Weather weather = Weather();

  PageController _controller = PageController(initialPage: 0, keepPage: true);
  int position = 0;

  @override
  void initState() {
    getWeather();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void getWeather() async {
    setState(() {
      isLoading = true;
    });

    await weather.getWeatherData(lat: widget.lat, lon: widget.lon);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      backgroundColor: Color(0xFFE5F0FC),
      drawer: Container(
        width: 200,
        child: Drawer(
          elevation: 5,
          child: Container(
            color: Color(0xFFE5F0FC),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100, bottom: 50),
                  child: Text(
                    'Weather App',
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
                      color: Colors.blueGrey,
                    ),
                    padding: EdgeInsets.all(5),
                    child: Text(
                      'Add Location',
                      style: TextStyle(color: Colors.black, fontSize: 20),
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
                        enableDrag: false,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return AddLocationSheet();
                        });
                  },
                ),
                Divider(
                  indent: 30,
                  endIndent: 30,
                  thickness: 1,
                ),
                Expanded(
                  child: Container(
                    child: ListView(
                      padding: EdgeInsets.only(top: 0),
                      children: [
                        LocationTile(
                          location: 'Paris',
                          weather: '9',
                        ),
                        LocationTile(
                          location: 'Lake Geneva',
                          weather: '27',
                        ),
                        LocationTile(
                          location: 'Chicago',
                          weather: '30',
                        ),
                        LocationTile(
                          location: 'Palo Alto',
                          weather: '32',
                        ),
                      ],
                    ),
                  ),
                ),
                Text('h/f')
              ],
            ),
          ),
        ),
      ),
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
                            child: Icon(Icons.menu),
                            onTap: () => scaffoldKey.currentState.openDrawer(),
                          ),
                        ),
                        Text(
                          'Weather App',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Icon(Icons.notifications),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  widget.locality,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
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
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: GestureDetector(
                          child: Icon(Icons.location_on),
                          onTap: () {},
                        ),
                      ),
//                      DotsIndicator(
//                        dotsCount: 8,
//                        position: 0,
//                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Icon(Icons.arrow_drop_up),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
