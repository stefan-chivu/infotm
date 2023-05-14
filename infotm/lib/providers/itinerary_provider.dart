import 'dart:convert';
import 'package:infotm/services/gpt_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infotm/models/pin.dart';
import 'package:infotm/services/isar.dart';
import 'package:infotm/services/sql.dart';
import 'package:intl/intl.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

final dio = Dio(BaseOptions(
    connectTimeout: Duration(minutes: 10),
    receiveTimeout: Duration(minutes: 10)));

final openAI = OpenAI.instance.build(
    token: token,
    baseOption: HttpSetup(receiveTimeout: const Duration(minutes: 10)),
    isLog: true);

// Future<String> getApiResponse(String systemPrompt, String userAnswer) async {
//   final request = ChatCompleteText(messages: [
//     Map.of({"role": "system", "content": systemPrompt}),
//     Map.of({"role": "user", "content": userAnswer}),
//   ], maxToken: 5000, model: ChatModel.gpt_4);

//   final response = await openAI.onChatCompletion(request: request);
//   for (var element in response!.choices) {
//     print(element.message?.content);
//     return element.message?.content ?? "";
//   }

//   return "";
// }

// Future<String> getApiResponse(String systemPrompt, String userAnswer) async {
//   dio.options.headers["Authorization"] = "Bearer ${token}";
//   final response =
//       await dio.post("https://api.openai.com/v1/chat/completions", data: {
//     "model": "gpt-4",
//     "max_tokens": 5000,
//     "messages": [
//       {"role": "system", "content": systemPrompt},
//       {"role": "user", "content": userAnswer}
//     ],
//   });

//   //Map<String, dynamic> data = jsonDecode(response.toString());

//   print(response.toString());
//   return "";
// }

Future<String> getApiResponse(String systemPrompt, String userAnswer) async {
  final String url = 'https://api.openai.com/v1/chat/completions';
  final Map<String, String> headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json'
  };

  final Map<String, dynamic> body = {
    'model': 'gpt-4',
    'max_tokens': 3500,
    'messages': [
      {'role': 'system', 'content': systemPrompt},
      {'role': 'user', 'content': userAnswer},
    ],
  };

  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(body),
  );

  Map<String, dynamic> data = jsonDecode(response.body);
  print(response.body);
  return "";
}

final itineraryProvider =
    FutureProvider.family<Itinerary, ItineraryPrompt>((ref, input) async {
  print(input.toString());
  // TODO: implement call to GPT-4 API
  await IsarService.setItinerary(sampleJson);

  // Itinerary itinerary = parseItineraryFromJson(sampleJson);
  print('API called');
  String apiResponse = await getApiResponse(systemPrompt, input.toString());
  print('API passed');

  Itinerary itinerary = parseItineraryFromJson(apiResponse);
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
  Map<String, String> questions;
  DateTime now = DateTime.now();

  ItineraryPrompt(this.questions);

  String toString() {
    String result = "";
    questions.forEach((key, value) {
      result += key;
      result += '\n$value\n';
    });

    result += DateFormat.yMMMMd().format(now);

    print(result);
    return result;
  }
}
