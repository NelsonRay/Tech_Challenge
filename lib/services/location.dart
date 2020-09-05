import 'package:geolocator/geolocator.dart';

class Location {
  double longitude;
  double latitude;
  String cityName;
  String countyName;


  // gets the user's current coordinates and assigns them to above properties, as well as the locality and country of the place
  Future<void> getCurrentLocation() async {
    Position position = await Geolocator().getCurrentPosition();
    longitude = position.longitude;
    latitude = position.latitude;
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemark[0].country == 'United States') {
      cityName = placemark[0].locality;
      countyName = '${placemark[0].administrativeArea}, US';
    } else {
      cityName = placemark[0].locality;
      countyName = placemark[0].country;
    }
  }

  // gets the coordinates from a specified location
  Future<void> getALocation({String locality}) async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(locality);
    longitude = placemark[0].position.longitude;
    latitude = placemark[0].position.latitude;

    if (placemark[0].country == 'United States') {
      cityName = placemark[0].locality;
      countyName = '${placemark[0].administrativeArea}, US';
    } else {
      cityName = placemark[0].locality;
      countyName = placemark[0].country;
    }
  }
}
