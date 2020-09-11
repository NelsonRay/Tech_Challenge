class Location {
  double longitude;
  double latitude;
  String city;
  String country;

  Location({
    this.longitude,
    this.latitude,
    this.country,
    this.city,
  });

  factory Location.fromValues(Map<String, dynamic> values) {
    return Location(
      city: values['city'],
      country: values['country'],
      latitude: values['latitude'],
      longitude: values['longitude'],
    );
  }
}
