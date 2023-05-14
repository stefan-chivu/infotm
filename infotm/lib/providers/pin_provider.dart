import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infotm/models/pin.dart';
import 'package:infotm/services/sql.dart';

final pinProvider =
    FutureProvider.family<PinProviderData, List<String>>((ref, input) async {
  List<Pin> pins = await SqlService.getAllPins();
  Set<Marker> markers = await getMarkers(pins, input);
  return PinProviderData(pins, markers);
});

Future<Set<Marker>> getMarkers(List<Pin> pins, List<String> filter) async {
  Set<Marker> markers = {};
  for (Pin pin in pins) {
    if (filter.contains(pin.type.name)) {
      Marker marker = await pin.buildMarker();
      markers.add(marker);
    }
  }

  return markers;
}

class PinProviderData {
  List<Pin> pins;
  Set<Marker> markers;

  PinProviderData(this.pins, this.markers);
}
