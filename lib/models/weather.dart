class Weather {
  final List<dynamic> iconPaths;
  final List<dynamic> descriptions;
  final List<dynamic> temperatures;
  final List<dynamic> dates;

  // these properties are given the category cards
  final List<dynamic> winds;
  final List<dynamic> humidityPercentages;
  final List<dynamic> rainPercentages;
  final List<dynamic> feelsLikes;
  final List<dynamic> cloudinessPercentages;
  final List<dynamic> rainVolumes;
  final List<dynamic> uvIndexes;
  final List<dynamic> snowVolumes;
  final List<dynamic> minTemperatures;
  final List<dynamic> maxTemperatures;
  final List<dynamic> sunrises;
  final List<dynamic> sunsets;
  final List<dynamic> pressures;

  // stores the 48 hour forecast values
  final List<List<Map<String, dynamic>>> hoursList;

//  var _data;

  Weather({
    this.uvIndexes,
    this.iconPaths,
    this.temperatures,
    this.hoursList,
    this.descriptions,
    this.dates,
    this.cloudinessPercentages,
    this.pressures,
    this.sunsets,
    this.sunrises,
    this.maxTemperatures,
    this.minTemperatures,
    this.rainVolumes,
    this.snowVolumes,
    this.feelsLikes,
    this.rainPercentages,
    this.humidityPercentages,
    this.winds,
  });

  factory Weather.fromValues(Map<String, List<dynamic>> values) {
    return Weather(
      maxTemperatures: values['maxTemperatures'],
      minTemperatures: values['minTemperatures'],
      pressures: values['pressures'],
      dates: values['dates'],
      winds: values['winds'],
      uvIndexes: values['uvIndexes'],
      temperatures: values['temperatures'],
      sunsets: values['sunsets'],
      sunrises: values['sunrises'],
      snowVolumes: values['snowVolumes'],
      rainVolumes: values['rainVolumes'],
      rainPercentages: values['rainPercentages'],
      iconPaths: values['iconPaths'],
      humidityPercentages: values['humidityPercentages'],
      hoursList: values['hoursList'],
      feelsLikes: values['feelsLikes'],
      descriptions: values['descriptions'],
      cloudinessPercentages: values['cloudinessPercentages'],
    );
  }

  factory Weather.fromJson(dynamic json, bool isFullMoon) {
    final int offset = json['timezone_offset']; // used to change the time values coming from the api. The api doesn't to that for me, so it gives me the timezone offset

    // during the mapping of the list, these are used to detect if it is first iteration
    bool needsCurrentTemp = true;
    bool needsCurrentDescription = true;
    bool needsCurrentIconPath = true;

    bool hasTodayBeenIterated = false; // used to detect if today has been iterated through in a list

    return Weather(
      maxTemperatures: json['daily']
          .map((index) => '${index['temp']['max'].toInt()}°')
          .toList(),
      minTemperatures: json['daily']
          .map((index) => '${index['temp']['min'].toInt()}°')
          .toList(),
      pressures:
          json['daily'].map((index) => '${index['pressure']} hPa').toList(),
      dates: json['daily'].map(
        (index) {
          DateTime date =
              DateTime.fromMillisecondsSinceEpoch((index['dt'] + offset) * 1000)
                  .toUtc();
          return _getFormattedDate(
              date: date,
              hasTodayBeenIterated: hasTodayBeenIterated,
              offset: offset,
              currentDate: DateTime.fromMillisecondsSinceEpoch(
                      (json['daily'][0]['dt'] + offset) * 1000)
                  .toUtc(),
              callback: () {
                hasTodayBeenIterated = true;
              });
        },
      ).toList(),
      winds: json['daily']
          .map((index) =>
              '${_getWindDirection(index['wind_deg'].toInt())} ${index['wind_speed'].toInt()} mph')
          .toList(),
      sunsets: json['daily'].map((index) {
        DateTime date = DateTime.fromMillisecondsSinceEpoch(
                (index['sunset'] + offset) * 1000)
            .toUtc();
        return _getHour(date: date, withMinutes: true);
      }).toList(),
      sunrises: json['daily'].map((index) {
        DateTime date = DateTime.fromMillisecondsSinceEpoch(
                (index['sunrise'] + offset) * 1000)
            .toUtc();
        return _getHour(date: date, withMinutes: true);
      }).toList(),
      rainPercentages: json['daily'].map((index) => '${index['pop'] * 100}%').toList(),
      snowVolumes: json['daily'].map((index) => '${index['snow'] ?? 0}mm').toList(), // TODO: Get fancy with ternaries and ?? to get some clean maps
      rainVolumes: json['daily'].map((index) {
        double rainValue = index['rain'];
        if (rainValue == null) {
          return '0 mm';
        } else {
          return '$rainValue mm';
        }
      }).toList(),
      uvIndexes: json['daily'].map((index) {
        final String uvIndex = index['uvi']?.toString();
        return uvIndex != null ? uvIndex : '0.0';
      }).toList(),
      iconPaths: json['daily'].map((index) {
        if (needsCurrentIconPath) {
          needsCurrentIconPath = false;
          String iconPath =
              'assests/icons/${json['current']['weather'][0]['icon']}.png';
          if (!iconPath.contains('d') && !isFullMoon)
            iconPath =
                'assests/icons/h${json['current']['weather'][0]['icon']}.png';
          return iconPath;
        }
        String iconPath = 'assests/icons/${index['weather'][0]['icon']}.png';
        if (!iconPath.contains('d') && !isFullMoon)
          iconPath = 'assests/icons/h${index['weather'][0]['icon']}.png';
        return iconPath;
      }).toList(),
      cloudinessPercentages:
          json['daily'].map((index) => '${index['clouds']}%').toList(),
      descriptions: json['daily'].map((index) {
        if (needsCurrentDescription) {
          needsCurrentDescription = false;
          return json['current']['weather'][0]['description']
              .split(' ')
              .map((word) => word[0].toUpperCase() + word.substring(1))
              .join(' ');
        }
        return index['weather'][0]['description']
            .split(' ')
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(' ');
      }).toList(),
      temperatures: json['daily'].map((index) {
        if (needsCurrentTemp) {
          needsCurrentTemp = false;
          return '${json['current']['temp'].toInt()}°';
        }
        return '${index['temp']['day'].toInt()}°';
      }).toList(),
      humidityPercentages: json['daily'].map((index) {
        if (index == 0) {
          return '${json['hourly'][index]['humidity']}%';
        } else {
          return '${index['humidity']}%';
        }
      }).toList(),
      feelsLikes: json['daily'].map((index) {
        if (index == 0) {
          return '${json['hourly'][index]['feels_like'].toInt()}°';
        } else {
          return '${index['feels_like']['day'].toInt()}°';
        }
      }).toList(),
      hoursList: _getHoursList(json: json, offset: offset, isFullMoon: isFullMoon),
    );
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

  // returns a String with the formatted date for the dribbble design
  String _getFormattedDate(
      {DateTime date,
      Function callback,
      bool hasTodayBeenIterated,
      int offset,
      DateTime currentDate}) {
    String weekday;

    bool isToday = false;
    bool isTomorrow = false;

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
}

// used to the hour with AM or PM and possibly with minutes
String _getHour({DateTime date, bool withMinutes}) {
  int hour;
  int minutes = date.minute;
  String period;

  if (date.hour < 12) {
    period = 'AM';
  } else {
    period = 'PM';
  }

  if (date.hour < 13) {
    if (date.hour == 0) {
      hour = 12;
    } else {
      hour = date.hour;
    }
  } else {
    hour = date.hour - 12;
  }

  if (withMinutes == true) {
    if (minutes < 10) {
      return '$hour:0$minutes $period';
    }
    return '$hour:$minutes $period';
  } else {
    return '$hour$period';
  }
}

List<dynamic> _getHoursList({dynamic json, int offset, bool isFullMoon}) {
  List<Map<String, dynamic>> listOf48Hours = [];
  List<List<Map<String, dynamic>>> hoursList = [];

  // iterates through all 48 hours and grabs temp, hour, and preferred icon
  for (int index = 0; index < 48; index++) {
    String icon =
        'assests/icons/${json['hourly'][index]['weather'][0]['icon']}.png';
    if (!icon.contains('d') && !isFullMoon)
      icon =
          'assests/icons/h${json['hourly'][index]['weather'][0]['icon']}.png';
    DateTime hour = DateTime.fromMillisecondsSinceEpoch(
            (json['hourly'][index]['dt'] + offset) * 1000)
        .toUtc();
    String temp = '${json['hourly'][index]['temp'].toInt()}°';

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

  return hoursList;
}
