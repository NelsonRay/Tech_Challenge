import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:weather_app/models/weather.dart';

const String apiKey = '769201b7fe3879503fd8f5ef98f76f95';

class WeatherService {
  Future<Weather> getWeatherData({double lon, double lat}) async {
    final prefs = await SharedPreferences.getInstance();

    final bool isFahrenheit = prefs.getBool('isF');
    final bool isFullMoon = prefs.getBool('isFullMoon');


    Response response;

    try {
      String preferredUnits = 'units=metric';
      if (isFahrenheit) preferredUnits = 'units=imperial';

      String url =
          'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=minutely&appid=$apiKey&$preferredUnits';

      response = await Dio().get(url);

      final json = response.data;

      return Weather.fromJson(json, isFullMoon);
    } catch (e) {
      print('lon: $lon, lat: $lat');
      print(response.statusCode);
      print(e);
    }
  }
}
