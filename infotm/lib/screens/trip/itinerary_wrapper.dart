import 'package:flutter/material.dart';
import 'package:infotm/screens/trip/itinerary.dart';
import 'package:infotm/screens/trip/questionaire.dart';
import 'package:infotm/services/isar.dart';

class ItineraryWrapper extends StatefulWidget {
  const ItineraryWrapper({super.key});

  @override
  State<ItineraryWrapper> createState() => _ItineraryWrapperState();
}

class _ItineraryWrapperState extends State<ItineraryWrapper> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (IsarService.isarItinerary.itinerary.isNotEmpty) {
      return const ItineraryPage();
    } else {
      return const TripQuestionaire();
    }
  }
}
