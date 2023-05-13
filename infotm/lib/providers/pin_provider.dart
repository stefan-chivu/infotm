import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infotm/models/pin.dart';
import 'package:infotm/services/sql.dart';

final pinProvider = FutureProvider<PinProviderData>((ref) async {
  List<Pin> pins = await SqlService.getAllPins();
  Set<Marker> markers = await getMarkers(pins);
  return PinProviderData(pins, markers);
});

Future<Set<Marker>> getMarkers(List<Pin> pins) async {
  Set<Marker> markers = {};
  for (Pin pin in pins) {
    Marker marker = await pin.buildMarker();
    markers.add(marker);
  }

  return markers;
}

class PinProviderData {
  List<Pin> pins;
  Set<Marker> markers;

  PinProviderData(this.pins, this.markers);
}
