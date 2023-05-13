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
    PinType.toilet: 'package:infotm/assets/icons/toilet.png',
    PinType.hospital: 'package:infotm/assets/icons/hospital.png',
    PinType.waterFountain: 'package:infotm/assets/icons/waterFountain.png',
    PinType.institution: 'package:infotm/assets/icons/institution.png',
    PinType.park: 'package:infotm/assets/icons/park.png',
    PinType.other: 'package:infotm/assets/icons/other.png',
  };

  Marker buildMarker() {
    late BitmapDescriptor customIcon;

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(48, 48)),
            icons[type] ?? 'assets/icons/other.png')
        .then((d) {
      customIcon = d;
    });

    return Marker(
      markerId: MarkerId(id.toString()),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(
          title: name ?? '',
          snippet:
              '${address?.toString()}\n${scheduleStart.toString()} - ${scheduleEnd.toString()}'),
      icon: customIcon,
    );
  }
}

enum PinType { toilet, hospital, waterFountain, institution, park, other }
