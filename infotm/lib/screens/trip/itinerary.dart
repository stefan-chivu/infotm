import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infotm/providers/itinerary_provider.dart';
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
      List<DayPanelItem> dayPanelItems = [];
      for (int i = 0; i < providerData.days.length; i++) {
        dayPanelItems
            .add(DayPanelItem(day: providerData.days[i], isExpanded: true));
      }
      return Scaffold(
        appBar: AppBar(
          title: const Text('Itinerary'),
        ),
        body: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.33,
              child: ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    dayPanelItems[index].isExpanded = !isExpanded;
                  });
                },
                children:
                    dayPanelItems.map<ExpansionPanel>((DayPanelItem item) {
                  return itineraryDayExpansionPanel(
                    item.isExpanded,
                    item.day,
                    headerLeading: const Icon(
                      Icons.info,
                      color: AppColors.davyGray,
                    ),
                    headerTitle: Center(
                      child: Text(
                        item.day.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
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

class DayPanelItem {
  ItineraryDay day;
  Widget? headerLeading;
  Widget? headerTitle;
  bool isExpanded = false;
  DayPanelItem(
      {required this.day,
      required this.isExpanded,
      this.headerTitle,
      this.headerLeading});
}
