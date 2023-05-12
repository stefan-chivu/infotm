import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infotm/models/pin.dart';
import 'package:infotm/services/sql.dart';

final pinProvider = FutureProvider<List<Pin>>((ref) async {
  List<Pin> pins = await SqlService.getAllPins();
  return pins;
});
