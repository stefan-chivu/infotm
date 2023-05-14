import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infotm/providers/itinerary_provider.dart';
import 'package:infotm/screens/trip/day_details.dart';
import 'package:infotm/ui_components/custom_nav_bar.dart';
import 'package:infotm/ui_components/itinerary_day_expansion_panel.dart';
import 'package:infotm/ui_components/ui_specs.dart';

class ItineraryPage extends ConsumerStatefulWidget {
  const ItineraryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends ConsumerState<ItineraryPage> {
  final ItineraryPrompt prompt = ItineraryPrompt({});
  @override
  Widget build(BuildContext context) {
    final providerData = ref.watch(itineraryProvider(prompt));

    return providerData.when(data: (providerData) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Itinerary'),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: providerData.days.length,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Wrap(children: [
                              DayDetails(
                                day: providerData.days[index],
                              )
                            ]);
                          });
                    },
                    title: Text(
                      providerData.days[index].title,
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
              );
            },
          ),
        ),
        bottomNavigationBar: const CustomNavBar(),
      );
    }, error: ((error, stackTrace) {
      return Container(
        color: Colors.white,
        child: Center(
            child: Text(
          error.toString(),
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: AppFontSizes.M),
        )),
      );
    }), loading: () {
      return Container(
        color: Colors.white,
        child: const Center(
          child: SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    });
  }
}
