import 'package:geolocator/geolocator.dart';

class Location {
  double longitude;
  double latitude;
  String name;

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator().getCurrentPosition();
    longitude = position.longitude;
    latitude = position.latitude;
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemark[0].country == 'United States') {
      name = '${placemark[0].locality}, ${placemark[0].administrativeArea}, US';
    } else {
      name = '${placemark[0].locality}, ${placemark[0].country}';
    }

    print(placemark[0].locality);
    print(placemark[0].administrativeArea);
    print(placemark[0].country);
  }

  Future<void> getALocation({String locality}) async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(locality);
    this.name = placemark[0].locality;
    longitude = placemark[0].position.longitude;
    latitude = placemark[0].position.latitude;
  }
}
