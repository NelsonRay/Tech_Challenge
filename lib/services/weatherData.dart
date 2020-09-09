import 'package:dio/dio.dart';

const String apiKey = '769201b7fe3879503fd8f5ef98f76f95';

class WeatherData {
  WeatherData({this.isFahrenheit});

  // stores the user's preferences and is used to select the preferred type of data
  bool isFahrenheit;

  String _preferredUnits;

  Response _response;

  Future<dynamic> getWeatherData({double lon, double lat}) async {
    try {
      // changes url to get preferred data
      if (isFahrenheit) {
        _preferredUnits = 'units=imperial';
      } else {
        _preferredUnits = 'units=metric';
      }

      String url =
          'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=minutely&appid=$apiKey&$_preferredUnits';

//      print(url);

      //get response
      _response = await Dio().get(url);
      return _response.data;
    } catch (e) {
      print(_response.statusCode);
      print(e);
    }
  }
}
