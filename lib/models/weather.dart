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
}
