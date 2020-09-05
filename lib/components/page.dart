import 'package:flutter/material.dart';

import 'package:weather_app/components/hour_widget.dart';
import 'package:weather_app/components/category_card.dart';

import 'package:weather_app/services/weather.dart';

class PageWidget extends StatelessWidget {
  final Weather weather;
  final int index;

  PageWidget({this.weather, this.index});

  // used to know if any of the last couple of days extend into a third day or not
  bool isThirdListNotEmpty() {
    if (index == 2) {
      return weather.hoursList[index].length > 0;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Image.asset(
            weather.iconPaths[index],
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 20),
        Text(
          weather.descriptions[index],
          style: TextStyle(
            fontSize: 20,
            color: Colors.blueGrey.shade700,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          weather.temperatures[index],
          style: TextStyle(
            fontSize: 100,
            color: Colors.blueGrey.shade800,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Container(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                CategoryCard(
                  categoryText: 'Feels Like',
                  answer: weather.feelsLikes[index],
                ),
                CategoryCard(
                  categoryText: 'Min Temp',
                  answer: weather.minTemperatures[index],
                ),
                CategoryCard(
                  categoryText: 'Max Temp',
                  answer: weather.maxTemperatures[index],
                ),
                CategoryCard(
                  categoryText: 'Sunrise',
                  answer: weather.sunrises[index],
                ),
                CategoryCard(
                  categoryText: 'Sunset',
                  answer: weather.sunsets[index],
                ),
                CategoryCard(
                  categoryText: 'Wind',
                  answer: weather.winds[index],
                ),
                CategoryCard(
                  categoryText: 'Humidity',
                  answer: weather.humidityPercentages[index],
                ),
                CategoryCard(
                  categoryText: 'Cloudiness',
                  answer: weather.cloudinessPercentages[index],
                ),
                CategoryCard(
                  categoryText: 'UV Index',
                  answer: weather.uvIndexes[index],
                ),
                CategoryCard(
                  categoryText: 'Pressure',
                  answer: weather.pressures[index],
                ),
                CategoryCard(
                  categoryText: 'Prec.',
                  answer: weather.rainPercentages[index],
                ),
                CategoryCard(
                  categoryText: 'Rain Vol.',
                  answer: weather.rainVolumes[index],
                ),
                CategoryCard(
                  categoryText: 'Snow Vol.',
                  answer: weather.snowVolumes[index],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            weather.dates[index],
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 20),
        if (index < 2 || isThirdListNotEmpty())
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Container(
              width: double.infinity,
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: weather.hoursList[index].length,
                itemBuilder: (context, index) {
                  return HourWidget(
                    hour: weather.hoursList[this.index][index]['hour'],
                    icon: weather.hoursList[this.index][index]['icon'],
                    temp: weather.hoursList[this.index][index]['temp'],
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
