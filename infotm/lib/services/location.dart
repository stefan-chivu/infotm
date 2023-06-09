import 'package:infotm/models/address.dart';
import 'package:geocoding/geocoding.dart' as geocodingpkg;
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class LocationService {
  static final Future<Position> location = Geolocator.getCurrentPosition();

  LocationService._privateConstructor();
  static final LocationService instance = LocationService._privateConstructor();

  static Future<void> init() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  static Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition();
  }

  static Future<Address> addressFromLatLng(
      double latitude, double longitude) async {
    try {
      List<geocodingpkg.Placemark> placemarks =
          await geocodingpkg.placemarkFromCoordinates(latitude, longitude);
      Address address = Address(
          placemarks.first.street ?? '',
          placemarks.first.locality ?? '',
          placemarks.first.administrativeArea ?? '',
          placemarks.first.country ?? '');
      return address;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
