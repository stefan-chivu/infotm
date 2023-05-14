import 'package:isar/isar.dart';

part 'isar_itinerary.g.dart';

@collection
class IsarItinerary {
  final Id id = 0;

  @Index(type: IndexType.value)
  String itinerary;

  IsarItinerary({
    required this.itinerary,
  });
}
