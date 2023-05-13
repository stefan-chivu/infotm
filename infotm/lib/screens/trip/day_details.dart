import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:infotm/providers/itinerary_provider.dart';
import 'package:infotm/ui_components/ui_specs.dart';

class DayDetails extends StatelessWidget {
  final ItineraryDay day;
  const DayDetails({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        const SizedBox(
          height: AppMargins.M,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width / 1.33,
                child: Wrap(
                  runAlignment: WrapAlignment.center,
                  children: [
                    const Text(
                      "Description",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppFontSizes.M),
                    ),
                    const SizedBox(
                      height: AppMargins.M,
                    ),
                    Text(day.description)
                  ],
                )),
          ],
        ),
        const SizedBox(
          height: AppMargins.L,
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width / 1.33,
            child: Wrap(
              runAlignment: WrapAlignment.center,
              children: getCards(day),
            )),
        const SizedBox(
          height: AppMargins.L,
        )
      ]),
    );
  }

  List<Card> getCards(ItineraryDay day) {
    List<Card> cards = [];

    for (int i = 0; i < day.attractions.length; i++) {
      cards.add(Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListTile(
            title: Text(
              day.attractions[i].name,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            leading: const CircleAvatar(
              backgroundColor: AppColors.airBlue,
              child: Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ));
    }

    return cards;
  }
}
