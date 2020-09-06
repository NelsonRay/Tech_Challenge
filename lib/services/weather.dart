import 'package:dio/dio.dart';

const String apiKey = '769201b7fe3879503fd8f5ef98f76f95';

class Weather {
  Weather({this.isFahrenheit, this.isFullMoon});

  // stores the user's preferences and is used to select the preferred type of data
  bool isFahrenheit;
  bool isFullMoon;

  String _preferredUnits;

  Response _response;
  int _offset;

  List<String> iconPaths;
  List<String> descriptions;
  List<String> temperatures;
  List<String> dates;

  // these properties are given the category cards
  List<String> winds;
  List<String> humidityPercentages;
  List<String> rainPercentages;
  List<String> feelsLikes;
  List<String> cloudinessPercentages;
  List<String> rainVolumes;
  List<String> uvIndexes;
  List<String> snowVolumes;
  List<String> minTemperatures;
  List<String> maxTemperatures;
  List<String> sunrises;
  List<String> sunsets;
  List<String> pressures;

  // stores the 48 hour forecast values
  List<List<Map<String, dynamic>>> hoursList = [];

  Future<void> getWeatherData({double lon, double lat}) async {
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

      _offset = _response.data['timezone_offset'];

      //update values
      _updateValues();
    } catch (e) {
      print(_response.statusCode);
      print(e);
    }
  }

  // calls all the below functions
  void _updateValues() {
    _getHoursList();
    _getDates();
    _getWinds();

    _getIcons();
    _getDescriptions();
    _getTemperatures();
    _getHumidityPercentages();
    _getRainPercentages();
    _getFeelsLikes();
    _getCloudinessPercentages();
    _getRainVolumes();
    _getUVIndexes();
    _getSnowVolumes();
    _getMinTemperatures();
    _getMaxTemperatures();
    _getSunrises();
    _getSunsets();
    _getPressures();
  }

  void _getHoursList() {
    List<Map<String, dynamic>> listOf48Hours = [];

    // iterates through all 48 hours and grabs temp, hour, and preferred icon
    for (int index = 0; index < 48; index++) {
      String icon =
          'assests/icons/${_response.data['hourly'][index]['weather'][0]['icon']}.png';
      if (!icon.contains('d') && !isFullMoon)
        icon =
            'assests/icons/h${_response.data['hourly'][index]['weather'][0]['icon']}.png';
      DateTime hour = DateTime.fromMillisecondsSinceEpoch(
              (_response.data['hourly'][index]['dt'] + _offset) * 1000)
          .toUtc();
      String temp = '${_response.data['hourly'][index]['temp'].toInt()}°';

      listOf48Hours.add({'icon': icon, 'hour': hour, 'temp': temp});
    }

    // iterates through the above list^^^ and separates them based off their dates

    List<Map<String, dynamic>> hoursOfDay1 = [];
    List<Map<String, dynamic>> hoursOfDay2 = [];
    List<Map<String, dynamic>> hoursOfDay3 = [];

    DateTime currentDate = listOf48Hours[0]['hour'];

    for (int index = 0; index < 48; index++) {
      DateTime dateTimeOfHour = listOf48Hours[index]['hour'];
      if (currentDate.weekday == dateTimeOfHour.weekday) {
        hoursOfDay1.add({
          'hour': _getHour(date: dateTimeOfHour, withMinutes: false),
          'temp': listOf48Hours[index]['temp'],
          'icon': listOf48Hours[index]['icon'],
        });
      } else {
        if (currentDate.weekday + 1 == 8) {
          if (dateTimeOfHour.weekday == 1) {
            hoursOfDay2.add({
              'hour': _getHour(date: dateTimeOfHour, withMinutes: false),
              'temp': listOf48Hours[index]['temp'],
              'icon': listOf48Hours[index]['icon'],
            });
          }
        } else {
          if (dateTimeOfHour.weekday == currentDate.weekday + 1) {
            hoursOfDay2.add({
              'hour': _getHour(date: dateTimeOfHour, withMinutes: false),
              'temp': listOf48Hours[index]['temp'],
              'icon': listOf48Hours[index]['icon'],
            });
          } else {
            hoursOfDay3.add({
              'hour': _getHour(date: dateTimeOfHour, withMinutes: false),
              'temp': listOf48Hours[index]['temp'],
              'icon': listOf48Hours[index]['icon'],
            });
          }
        }
      }
    }

    // changes the first hour to NOW
    hoursOfDay1[0]['hour'] = 'NOW';

    hoursList.add(hoursOfDay1);
    hoursList.add(hoursOfDay2);
    hoursList.add(hoursOfDay3);
  }

  // used to the hour with AM or PM and possibly with minutes
  String _getHour({DateTime date, bool withMinutes}) {
    int hour;
    int minutes = date.minute;
    String period;

    switch (date.hour) {
      case 0:
        hour = 12;
        period = 'AM';
        break;
      case 1:
        hour = 1;
        period = 'AM';
        break;
      case 2:
        hour = 2;
        period = 'AM';
        break;
      case 3:
        hour = 3;
        period = 'AM';
        break;
      case 4:
        hour = 4;
        period = 'AM';
        break;
      case 5:
        hour = 5;
        period = 'AM';
        break;
      case 6:
        hour = 6;
        period = 'AM';
        break;
      case 7:
        hour = 7;
        period = 'AM';
        break;
      case 8:
        hour = 8;
        period = 'AM';
        break;
      case 9:
        hour = 9;
        period = 'AM';
        break;
      case 10:
        hour = 10;
        period = 'AM';
        break;
      case 11:
        hour = 11;
        period = 'AM';
        break;
      case 12:
        hour = 12;
        period = 'PM';
        break;
      case 13:
        hour = 1;
        period = 'PM';
        break;
      case 14:
        hour = 2;
        period = 'PM';
        break;
      case 15:
        hour = 3;
        period = 'PM';
        break;
      case 16:
        hour = 4;
        period = 'PM';
        break;
      case 17:
        hour = 5;
        period = 'PM';
        break;
      case 18:
        hour = 6;
        period = 'PM';
        break;
      case 19:
        hour = 7;
        period = 'PM';
        break;
      case 20:
        hour = 8;
        period = 'PM';
        break;
      case 21:
        hour = 9;
        period = 'PM';
        break;
      case 22:
        hour = 10;
        period = 'PM';
        break;
      case 23:
        hour = 11;
        period = 'PM';
        break;
      default:
        hour = 100;
        period = 'PM';
    }

    if (withMinutes == true) {
      return '$hour:$minutes $period';
    } else {
      return '$hour$period';
    }
  }

  // supplies the next 7 seven days formatted to a list
  void _getDates() {
    List<String> dates = [];
    bool hasTodayBeenIterated = false;
    for (int index = 0; index < 8; index++) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(
              (_response.data['daily'][index]['dt'] + _offset) * 1000)
          .toUtc();
      dates.add(_getFormattedDate(
          date: date,
          hasTodayBeenIterated: hasTodayBeenIterated,
          callback: () {
            hasTodayBeenIterated = true;
          }));
    }
    this.dates = dates;
  }

  // used to check which of the dates are today and tomorrow
  String _getFormattedDate(
      {DateTime date, Function callback, bool hasTodayBeenIterated}) {
    String weekday;

    bool isToday = false;
    bool isTomorrow = false;

    DateTime currentDate = DateTime.fromMillisecondsSinceEpoch(
            (_response.data['hourly'][0]['dt'] + _offset) * 1000)
        .toUtc();

    if (date.weekday == currentDate.weekday) {
      isToday = true;
    } else {
      if (currentDate.weekday + 1 == 8) {
        if (date.weekday == 1) {
          isTomorrow = true;
          callback();
        }
      } else {
        if (date.weekday == currentDate.weekday + 1) {
          isTomorrow = true;
          callback();
        }
      }
    }

    if (hasTodayBeenIterated) {
      isToday = false;
    }

    switch (date.weekday) {
      case 1:
        weekday = 'Monday';
        break;
      case 2:
        weekday = 'Tuesday';
        break;
      case 3:
        weekday = 'Wednesday';
        break;
      case 4:
        weekday = 'Thursday';
        break;
      case 5:
        weekday = 'Friday';
        break;
      case 6:
        weekday = 'Saturday';
        break;
      case 7:
        weekday = 'Sunday';
        break;
      default:
        weekday = 'Error';
    }

    if (isToday) {
      return '$weekday, Today';
    } else if (isTomorrow) {
      return '$weekday, Tomorrow';
    } else {
      return weekday;
    }
  }

  // supplies the wind speed and direction into a list
  void _getWinds() {
    List<String> winds = [];
    for (int index = 0; index < 8; index++) {
      if (index == 0) {
        winds.add(
            '${_getWindDirection(_response.data['hourly'][index]['wind_deg'].toInt())} ${_response.data['hourly'][index]['wind_speed'].toInt()} mph');
      } else {
        winds.add(
            '${_getWindDirection(_response.data['daily'][index]['wind_deg'].toInt())} ${_response.data['daily'][index]['wind_speed'].toInt()} mph');
      }
    }
    this.winds = winds;
  }

  // used to get wind direction
  String _getWindDirection(int deg) {
    if (deg <= 25) {
      return 'N';
    } else if (deg > 25 && deg <= 70) {
      return 'NE';
    } else if (deg > 70 && deg <= 115) {
      return 'E';
    } else if (deg > 115 && deg <= 160) {
      return 'SE';
    } else if (deg > 160 && deg <= 205) {
      return 'S';
    } else if (deg > 205 && deg <= 250) {
      return 'SW';
    } else if (deg > 250 && deg <= 295) {
      return 'W';
    } else if (deg > 295 && deg <= 340) {
      return 'NW';
    } else {
      return 'N';
    }
  }

  void _getSunsets() {
    List<String> sunsets = [];
    for (int index = 0; index < 8; index++) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(
              (_response.data['daily'][index]['sunset'] + _offset) * 1000)
          .toUtc();
      sunsets.add(_getHour(date: date, withMinutes: true));
    }
    this.sunsets = sunsets;
  }

  void _getSunrises() {
    List<String> sunrises = [];
    for (int index = 0; index < 8; index++) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(
              (_response.data['daily'][index]['sunrise'] + _offset) * 1000)
          .toUtc();
      sunrises.add(_getHour(date: date, withMinutes: true));
    }
    this.sunrises = sunrises;
  }

  void _getMaxTemperatures() {
    List<String> maxTemperatures = [];
    for (int index = 0; index < 8; index++) {
      maxTemperatures
          .add('${_response.data['daily'][index]['temp']['max'].toInt()}°');
    }
    this.maxTemperatures = maxTemperatures;
  }

  void _getMinTemperatures() {
    List<String> minTemperatures = [];
    for (int index = 0; index < 8; index++) {
      minTemperatures
          .add('${_response.data['daily'][index]['temp']['min'].toInt()}°');
    }
    this.minTemperatures = minTemperatures;
  }

  void _getPressures() {
    List<String> pressures = [];
    for (int index = 0; index < 8; index++) {
      pressures.add('${_response.data['daily'][index]['pressure']} hPa');
    }
    this.pressures = pressures;
  }

  void _getRainPercentages() {
    List<String> rainPercentages = [];
    for (int index = 0; index < 8; index++) {
      rainPercentages.add('${_response.data['daily'][index]['pop'] * 100}%');
    }
    this.rainPercentages = rainPercentages;
  }

  void _getSnowVolumes() {
    List<String> snowVolumes = [];
    for (int index = 0; index < 8; index++) {
      double snowValue = _response.data['daily'][index]['snow'];
      if (snowValue == null) {
        snowVolumes.add('0 mm');
      } else {
        snowVolumes.add('$snowValue mm');
      }
    }
    this.snowVolumes = snowVolumes;
  }

  void _getRainVolumes() {
    List<String> rainVolumes = [];
    for (int index = 0; index < 8; index++) {
      double rainValue = _response.data['daily'][index]['rain'];
      if (rainValue == null) {
        rainVolumes.add('0 mm');
      } else {
        rainVolumes.add('$rainValue mm');
      }
    }
    this.rainVolumes = rainVolumes;
  }

  void _getUVIndexes() {
    List<String> uvIndexes = [];
    for (int index = 0; index < 8; index++) {
      uvIndexes.add(_response.data['daily'][index]['uvi'].toString());
    }
    this.uvIndexes = uvIndexes;
  }

  void _getCloudinessPercentages() {
    List<String> cloudinessPercentages = [];
    for (int index = 0; index < 8; index++) {
      cloudinessPercentages.add('${_response.data['daily'][index]['clouds']}%');
    }
    this.cloudinessPercentages = cloudinessPercentages;
  }

  // supplies the preferred icons into a list
  void _getIcons() {
    List<String> iconPaths = [];
    for (int index = 0; index < 8; index++) {
      if (index == 0) {
        String iconPath =
            'assests/icons/${_response.data['hourly'][index]['weather'][0]['icon']}.png';
        if (!iconPath.contains('d') && !isFullMoon)
          iconPath =
              'assests/icons/h${_response.data['hourly'][index]['weather'][0]['icon']}.png';
        iconPaths.add(iconPath);
      } else {
        String iconPath =
            'assests/icons/${_response.data['daily'][index]['weather'][0]['icon']}.png';
        if (!iconPath.contains('d'))
          iconPath =
              'assests/icons/h${_response.data['daily'][index]['weather'][0]['icon']}.png';
        iconPaths.add(iconPath);
      }
    }
    this.iconPaths = iconPaths;
  }

  void _getDescriptions() {
    List<String> descriptions = [];
    for (int index = 0; index < 8; index++) {
      if (index == 0) {
        descriptions.add(_response.data['hourly'][index]['weather'][0]
                ['description']
            .split(' ')
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(' '));
      } else {
        descriptions.add(_response.data['daily'][index]['weather'][0]
                ['description']
            .split(' ')
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(' '));
      }
    }
    this.descriptions = descriptions;
  }

  void _getTemperatures() {
    List<String> temperatures = [];
    for (int index = 0; index < 8; index++) {
      if (index == 0) {
        temperatures.add('${_response.data['hourly'][index]['temp'].toInt()}°');
      } else {
        temperatures
            .add('${_response.data['daily'][index]['temp']['day'].toInt()}°');
      }
    }
    this.temperatures = temperatures;
  }

  void _getHumidityPercentages() {
    List<String> humidityPercentages = [];
    for (int index = 0; index < 8; index++) {
      if (index == 0) {
        humidityPercentages
            .add('${_response.data['hourly'][index]['humidity']}%');
      } else {
        humidityPercentages
            .add('${_response.data['daily'][index]['humidity']}%');
      }
    }
    this.humidityPercentages = humidityPercentages;
  }

  void _getFeelsLikes() {
    List<String> feelsLikes = [];
    for (int index = 0; index < 8; index++) {
      if (index == 0) {
        feelsLikes
            .add('${_response.data['hourly'][index]['feels_like'].toInt()}°');
      } else {
        feelsLikes.add(
            '${_response.data['daily'][index]['feels_like']['day'].toInt()}°');
      }
    }
    this.feelsLikes = feelsLikes;
  }
}
