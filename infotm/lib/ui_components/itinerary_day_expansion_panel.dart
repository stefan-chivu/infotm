import 'package:flutter/material.dart';
import 'package:infotm/providers/itinerary_provider.dart';
import 'package:infotm/ui_components/ui_specs.dart';

Widget itineraryDayDescriptor(ItineraryDay day,
    {Widget? headerLeading, Widget? headerTitle}) {
  return Column(
    children: [
      const Padding(padding: EdgeInsets.all(AppMargins.XS)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppMargins.S),
        child: Text(day.description),
      ),
      ListView.builder(
          shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          itemCount: day.attractions.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: const Icon(Icons.list),
              title: Text(
                day.attractions[index].name,
              ),
              subtitle: Text(day.attractions[index].duration ?? ''),
            );
          }),
    ],
  );
}
