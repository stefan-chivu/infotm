import 'package:flutter/material.dart';
import 'package:infotm/models/address.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Pin {
  int id;
  double latitude;
  double longitude;
  String? name;
  Address? address;
  PinType type;
  String? scheduleStart;
  String? scheduleEnd;

  Pin(
      {required this.id,
      required this.latitude,
      required this.longitude,
      required this.type,
      this.name,
      this.address,
      this.scheduleStart,
      this.scheduleEnd});

  var icons = {
    PinType.toilet: 'assets/icons/toilet.png',
    PinType.hospital: 'assets/icons/hospital.png',
    PinType.waterFountain: 'assets/icons/waterFountain.png',
    PinType.institution: 'assets/icons/institution.png',
    PinType.park: 'assets/icons/park.png',
    PinType.landmark: 'assets/icons/landmark.png',
    PinType.activities: 'assets/icons/activities.png',
    PinType.corp: 'assets/icons/corp.png',
    PinType.church: 'assets/icons/church.png',
    PinType.other: 'assets/icons/other.png',
  };

  Future<Marker> buildMarker() async {
    BitmapDescriptor customIcon;

    customIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2),
        icons[type] ?? 'assets/icons/other.png');

    return Marker(
      markerId: MarkerId(id.toString()),
      position: LatLng(latitude, longitude),
      infoWindow: name != null
          ? InfoWindow(
              title: name,
            )
          : InfoWindow.noText,
      icon: customIcon,
    );
  }
}

enum PinType {
  activities,
  church,
  corp,
  hospital,
  institution,
  landmark,
  other,
  park,
  toilet,
  waterFountain
}
