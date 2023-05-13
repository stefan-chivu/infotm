import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infotm/models/pin.dart';
import 'package:infotm/services/sql.dart';
import 'package:intl/intl.dart';

final itineraryProvider =
    FutureProvider.family<Itinerary, ItineraryPrompt>((ref, input) async {
  // TODO: implement call to GPT-4 API
  print('Provider called');
  Itinerary itinerary = parseItineraryFromJson(sampleJson);

  return itinerary;
});
Itinerary parseItineraryFromJson(String jsonString) {
  final Map<String, dynamic> itineraryMap = json.decode(jsonString);

  List<ItineraryDay> days = [];

  itineraryMap.forEach(
    (key, dayData) {
      String description = dayData['description'];
      List<dynamic> attractionList = dayData['attractionList'];
      String title = "Day $key";
      List<ItineraryAttraction> attractions = [];

      if (key == "0") {
        title = "Timisoara European Capital of Culture 2023 Events";
        for (var event in attractionList) {
          attractions.add(ItineraryAttraction(name: event));
        }
      } else {
        for (var element in attractionList) {
          String name = element["attraction"];
          String duration = element["time"];

          attractions.add(ItineraryAttraction(name: name, duration: duration));
        }
      }

      days.add(ItineraryDay(
          title: title, description: description, attractions: attractions));
    },
  );

  return Itinerary(days: days);
}

String sampleJson =
    '{"0":{"description":"As you\'ll be visiting Timisoara during the European Capital of Culture events, make sure to check out these events happening during your stay:","attractionList":["Ziua traditiilor maghiare","La pas - Evenimente gastronomice"]},"1":{"description":"On your first day, immerse yourself in Timisoara\'s art and history. Start by visiting the Muzeul de Arta Timisoara to appreciate the beautiful artwork, and then head to the Palatul Miksa Steiner to learn about local history. Finish the day by exploring the lovely Parcul Justiției, a beautiful green space where you can relax and enjoy nature.","attractionList":[{"attraction":"Muzeul de Arta Timisoara","time":"2 hours"},{"attraction":"Palatul Miksa Steiner","time":"1 hour"},{"attraction":"Parcul Justiției","time":"1 hour"}]},"2":{"description":"On your second day, explore Timisoara\'s technological side and enjoy some outdoor attractions. Begin at the Muzeul de Transport Public Corneliu Miklosi to discover the history of public transportation in the city. Then, take a stroll along the Strada Alba Iulia, a picturesque street with unique architecture. Finally, visit the Parcul Botanic to experience the beauty of nature and diverse flora.","attractionList":[{"attraction":"Muzeul de Transport Public Corneliu Miklosi","time":"1.5 hours"},{"attraction":"Strada Alba Iulia","time":"1 hour"},{"attraction":"Parcul Botanic","time":"1.5 hours"}]},"3":{"description":"On your last day, dive into local customs and traditions at the Muzeul Satului, a fascinating open-air museum showcasing traditional village life. Then, experience the vibrant atmosphere of Piata Unirii, a lively square surrounded by colorful baroque buildings. Don\'t forget to explore the nearby shopping areas, like Iulius Mall or Shopping City Timisoara, to take home some unique souvenirs.","attractionList":[{"attraction":"Muzeul Satului","time":"2 hours"},{"attraction":"Piata Unirii","time":"1 hour"},{"attraction":"Iulius Mall","time":"1.5 hours"}]}}';

// {
//   "0": {
//     "description": "As you'll be visiting Timisoara during the European Capital of Culture events, make sure to check out these events happening during your stay:",
//     "attractionList": [
//       "Ziua traditiilor maghiare",
//       "La pas - Evenimente gastronomice"
//     ]
//   },
//   "1": {
//     "description": "On your first day, immerse yourself in Timisoara's art and history. Start by visiting the Muzeul de Arta Timisoara to appreciate the beautiful artwork, and then head to the Palatul Miksa Steiner to learn about local history. Finish the day by exploring the lovely Parcul Justiției, a beautiful green space where you can relax and enjoy nature.",
//     "attractionList": [
//       {
//         "attraction": "Muzeul de Arta Timisoara",
//         "time": "2 hours"
//       },
//       {
//         "attraction": "Palatul Miksa Steiner",
//         "time": "1 hour"
//       },
//       {
//         "attraction": "Parcul Justiției",
//         "time": "1 hour"
//       }
//     ]
//   },
//   "2": {
//     "description": "On your second day, explore Timisoara's technological side and enjoy some outdoor attractions. Begin at the Muzeul de Transport Public ,,Corneliu Miklosi" to discover the history of public transportation in the city. Then, take a stroll along the Strada Alba Iulia, a picturesque street with unique architecture. Finally, visit the Parcul Botanic to experience the beauty of nature and diverse flora.",
//     "attractionList": [
//       {
//         "attraction": "Muzeul de Transport Public ,,Corneliu Miklosi\"",
//         "time": "1.5 hours"
//       },
//       {
//         "attraction": "Strada Alba Iulia",
//         "time": "1 hour"
//       },
//       {
//         "attraction": "Parcul Botanic",
//         "time": "1.5 hours"
//       }
//     ]
//   },
//   "3": {
//     "description": "On your last day, dive into local customs and traditions at the Muzeul Satului, a fascinating open-air museum showcasing traditional village life. Then, experience the vibrant atmosphere of Piata Unirii, a lively square surrounded by colorful baroque buildings. Don't forget to explore the nearby shopping areas, like Iulius Mall or Shopping City Timisoara, to take home some unique souvenirs.",
//     "attractionList": [
//       {
//         "attraction": "Muzeul Satului",
//         "time": "2 hours"
//       },
//       {
//         "attraction": "Piata Unirii",
//         "time": "1 hour"
//       },
//       {
//         "attraction": "Iulius Mall",
//         "time": "1.5 hours"
//       }
//     ]
//   }
// }

class Itinerary {
  List<ItineraryDay> days;

  Itinerary({required this.days});
}

class ItineraryDay {
  String title;
  String description;
  List<ItineraryAttraction> attractions;

  ItineraryDay(
      {required this.title,
      required this.description,
      required this.attractions});
}

class ItineraryAttraction {
  String name;
  String? duration;

  ItineraryAttraction({required this.name, this.duration});
}

class ItineraryPrompt {
  Map<String, dynamic> questions;
  DateTime now = DateTime.now();

  ItineraryPrompt(this.questions);

  String toString() {
    String result = "";
    questions.forEach((key, value) {
      result += key;
      result += '\n$value';
    });

    result += DateFormat.yMMMMd().format(now);

    print(result);
    return result;
  }
}
