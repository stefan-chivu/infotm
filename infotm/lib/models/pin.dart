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

  Pin(this.id, this.latitude, this.longitude, this.type,
      [this.name, this.address, this.scheduleStart, this.scheduleEnd]);

  Marker buildMarker() {
    double markerHue;

    switch (type) {
      case PinType.toilet:
        {
          markerHue = BitmapDescriptor.hueBlue;
        }
        break;
      case PinType.hospital:
        {
          markerHue = BitmapDescriptor.hueRed;
        }
        break;
      case PinType.waterFountain:
        {
          markerHue = BitmapDescriptor.hueCyan;
        }
        break;
      case PinType.institution:
        {
          markerHue = BitmapDescriptor.hueYellow;
        }
        break;
      case PinType.park:
        {
          markerHue = BitmapDescriptor.hueGreen;
        }
        break;
      case PinType.other:
        {
          markerHue = BitmapDescriptor.hueMagenta;
        }
        break;
    }

    return Marker(
      markerId: MarkerId(id.toString()),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(
          title: name ?? '',
          snippet:
              '${address?.toString()}\n${scheduleStart.toString()} - ${scheduleEnd.toString()}'),
      icon: BitmapDescriptor.defaultMarkerWithHue(markerHue),
    );
  }
}

enum PinType { toilet, hospital, waterFountain, institution, park, other }
