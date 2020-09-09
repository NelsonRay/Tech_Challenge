import 'package:geolocator/geolocator.dart';

class LocationData {

  Future<Map<String, dynamic>> getCurrentLocation() async {
    Position position = await Geolocator().getCurrentPosition();

    final longitude = position.longitude;
    final latitude = position.latitude;

    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);

    var city;
    var country;

    if (placemark[0].country == 'United States') {
      city = placemark[0].locality;
      country = '${placemark[0].administrativeArea}, US';
    } else {
      city = placemark[0].locality;
      country = placemark[0].country;
    }

    return {
      'longitude': longitude,
      'latitude': latitude,
      'city': city,
      'country': country
    };
  }

  // gets the coordinates from a specified location
  Future<Map<String, dynamic>> getALocation({String locality}) async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(locality);
    final longitude = placemark[0].position.longitude;
    final latitude = placemark[0].position.latitude;

    var city;
    var country;

    if (placemark[0].country == 'United States') {
      city = placemark[0].locality;
      country = '${placemark[0].administrativeArea}, US';
    } else {
      city = placemark[0].locality;
      country = placemark[0].country;
    }

    return {
      'longitude': longitude,
      'latitude': latitude,
      'city': city,
      'country': country
    };
  }
}
