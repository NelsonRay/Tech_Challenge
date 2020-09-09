class Location {
  double longitude;
  double latitude;
  String city;
  String country;

  void updateValues({Map<String, dynamic> values}) {

    longitude = values['longitude'];
    latitude = values['latitude'];
    city = values['city'];
    country = values['country'];
  }
}
