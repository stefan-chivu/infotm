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
    connectTimeout: const Duration(minutes: 10),
    receiveTimeout: const Duration(minutes: 10)));

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
  // final String url = 'http://35.211.208.184:5000/';
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
  return response.body;
}

final itineraryProvider =
    FutureProvider.family<Itinerary, ItineraryPrompt>((ref, input) async {
  print(input.toString());
  // TODO: implement call to GPT-4 API
  await IsarService.setItinerary(sampleJson);

  Itinerary itinerary = parseItineraryFromJson(sampleJson);
  print('API called');
  // String apiResponse = await getApiResponse(systemPrompt, input.toString());
  // String apiResponse = await _getApiResponse(
  //     input.toString(),
  //     int.parse(
  //         input.questions['How many days are you planning to stay?'] ?? '3'));
  print('API passed');

  // Itinerary itinerary = parseItineraryFromJson(apiResponse);
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
          String name = element["attraction"] ?? '';
          String duration = element["time"] ?? '';

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

String oneDayJson =
    '{"0":{"description":"Since you\'ll be visiting Timisoara during the European Capital of Culture events, don\'t miss the opportunity to attend \'La pas - Evenimente gastronomice\' on 18th May. This event explores the complex relationship between culture and food, which will give you a taste of local customs and traditions.","attractionList":[]},"1":{"description":"On your one-day trip to Timisoara, you\'ll have a busy itinerary exploring art, technology, and nature in this beautiful city. Start your day with a visit to \'Vaporas pe Malul Begai\', a relaxing boat tour along the Bega River. Then, head to \'Parcul Rozelor\', a charming rose garden perfect for a stroll and enjoying nature. Finally, visit \'Shopping City Timisoara\', where you can find local and international brands for a great shopping experience.","attractionList":[{"attraction":"Vaporas pe Malul Begai","time":"1 hour"},{"attraction":"Parcul Rozelor","time":"1 hour"},{"attraction":"Shopping City Timisoara","time":"2 hours"}]}}';
String twoDayJson =
    '{"0":{"description":"Welcome to Timișoara, European Capital of Culture! During your stay, don\'t miss the following cultural events happening in the city. Attend \'La pas - Evenimente gastronomice\' on 18th May to explore the complex relationship between culture and food. On 19th May, immerse yourself in local customs and traditions at \'Ziua tradițiilor maghiare\', featuring traditional crafts, folk dances, and more.","attractionList":["La pas - Evenimente gastronomice","Ziua tradițiilor maghiare"]},"1":{"description":"On your first day in Timișoara, dive into the city\'s rich history and art scene. Start by visiting Muzeul de Istorie, where you\'ll learn about the local history through various exhibits. Then, head to Palatul Miksa Steiner, an architectural gem with an interesting backstory. End your day with a relaxing Vaporas pe Malul Begai* cruise, offering stunning views of the city from the Bega River.","attractionList":[{"name":"Muzeul de Istorie","time":"2 hours"},{"name":"Palatul Miksa Steiner","time":"1 hour"},{"name":"Vaporas pe Malul Begai*","time":"1.5 hours"}]},"2":{"description":"On your second day, continue exploring Timișoara\'s outdoor attractions and technological wonders. Begin your day at Parcul Rozelor, a beautiful park with a stunning rose garden. Next, visit the Muzeul Consumatorului Comunist, a fascinating museum showcasing everyday life during the communist era. Lastly, experience the interactive and educational exhibits at the Muzeul de Transport Public.","attractionList":[{"name":"Parcul Rozelor","time":"1.5 hours"},{"name":"Muzeul Consumatorului Comunist","time":"2 hours"},{"name":"Muzeul de Transport Public","time":"2 hours"}]}}';
String threeDayJson =
    '{"0":{"description":"As you\'re visiting Timisoara during the European Capital of Culture events, make sure to attend the following: On the 14th of May, join the \'Ziua tradițiilor maghiare\' to celebrate Hungarian customs, including traditional crafts, folk dances, and concerts. On the 15th, enjoy the gastronomic event \'La pas\', which explores the complex relationship between culture and food.","attractionList":[{"name":"Ziua tradițiilor maghiare"},{"name":"La pas"}]},"1":{"description":"Begin your journey with a mix of art, history, and nature. Explore Muzeul de Arta Timisoara, where you\'ll appreciate a wide range of artworks. Next, visit Bastionul Maria Theresa, a historical site that offers a glimpse into the city\'s past. Finally, unwind at Parcul Rozelor, a beautiful park with a diverse array of roses.","attractionList":[{"name":"Muzeul de Arta Timisoara","timeToVisit":"2 hours"},{"name":"Bastionul Maria Theresa","timeToVisit":"1 hour"},{"name":"Parcul Rozelor","timeToVisit":"1.5 hours"}]},"2":{"description":"On your second day, dive into local customs and traditions at the Muzeul Satului, where you\'ll learn about traditional Romanian village life. Next, take a stroll through Piata Unirii, a lively square with beautiful architecture. End your day by experiencing Vaporas pe Malul Begai, a relaxing boat ride along the Bega River.","attractionList":[{"name":"Muzeul Satului","timeToVisit":"2 hours"},{"name":"Piata Unirii","timeToVisit":"1.5 hours"},{"name":"Vaporas pe Malul Begai","timeToVisit":"1 hour"}]},"3":{"description":"On your last day, immerse yourself in technology and nature. Visit the Muzeul de Transport Public to explore the history of public transportation in Timisoara. Then, head to Parcul Botanic, where you can appreciate beautiful flora and fauna. Finally, indulge in some local shopping at Iulius Mall.","attractionList":[{"name":"Muzeul de Transport Public","timeToVisit":"1.5 hours"},{"name":"Parcul Botanic","timeToVisit":"2 hours"},{"name":"Iulius Mall","timeToVisit":"2 hours"}]}}';
String fourDayJson =
    '{"0":{"description":"Welcome to Timisoara, European Capital of Culture! During your stay, don\'t miss the chance to experience the following cultural events: \'La pas - Evenimente gastronomice\' on May 18th, which explores the complex relationship between culture and food. Also, make sure to attend \'TESZT - Festival Euroregional de Teatru\' from May 21st to 28th, an international event promoting multiculturalism and showcasing the latest theatrical trends from the region and beyond.","attractionList":["La pas - Evenimente gastronomice","TESZT - Festival Euroregional de Teatru"]},"1":{"description":"On your first day, immerse yourself in the city\'s history and art scene. Start with the \'Muzeul de Arta Timisoara\' to admire its vast collection of European masterpieces. Then, visit the \'Muzeul de Istorie\' to learn about the region\'s past. End your day by enjoying a relaxing \'Vaporas pe Malul Begai\' boat ride along the Bega River, taking in the beautiful sights.","attractionList":[{"name":"Muzeul de Arta Timisoara","time":"2h"},{"name":"Muzeul de Istorie","time":"1.5h"},{"name":"Vaporas pe Malul Begai","time":"1h"}]},"2":{"description":"Discover Timisoara\'s stunning architecture on your second day. Start with a visit to \'Piata Unirii\', a picturesque square surrounded by colorful baroque buildings. Next, explore \'Catedrala Metropolitana\', an impressive orthodox cathedral with unique murals. Finally, stroll through \'Piata Libertatii\', a charming square with historical landmarks and plenty of shopping opportunities.","attractionList":[{"name":"Piata Unirii","time":"1h"},{"name":"Catedrala Metropolitana","time":"1h"},{"name":"Piata Libertatii","time":"1h"}]},"3":{"description":"On your third day, enjoy some of Timisoara\'s beautiful parks and green spaces. Start by visiting \'Parcul Rozelor\', a lovely park with a rose garden and picturesque pathways. Then, head to \'Parcul Botanic\', a peaceful oasis with diverse flora and themed gardens. Finally, unwind at \'Parcul Catedralei\', a perfect spot to relax and soak in the atmosphere of the city.","attractionList":[{"name":"Parcul Rozelor","time":"1h"},{"name":"Parcul Botanic","time":"1.5h"},{"name":"Parcul Catedralei","time":"1h"}]},"4":{"description":"On your final day, explore Timisoara\'s technology and innovation scene. Visit \'ExitGames Timisoara\' for an exciting escape room experience. Then, check out \'Calina Art Gallery\', a contemporary art space showcasing innovative works. Finally, indulge in some shopping at \'Iulius Mall\', where you can find local and international brands, as well as a great food court.","attractionList":[{"name":"ExitGames Timisoara","time":"1.5h"},{"name":"Calina Art Gallery","time":"1h"},{"name":"Iulius Mall","time":"2h"}]}}';
String fiveDayJson =
    '{"0":{"description":"Welcome to Timisoara, European Capital of Culture! During your stay, don\'t miss the cultural events happening around the city. On the 18th of May, explore the fascinating relationship between culture and food at the \'La pas - Evenimente gastronomice\', and between 21st to 28th of May, immerse yourself in the multiculturalism of the performing arts at the TESZT - Festival Euroregional de Teatru.","attractionList":["La pas - Evenimente gastronomice","TESZT - Festival Euroregional de Teatru"]},"1":{"description":"On your first day, explore Timisoara\'s rich history and art scene. Start at Muzeul de Arta Timisoara to admire its impressive art collections, and then head to Opera Timisoara to marvel at its stunning architecture. End your day at Biserica Sfanta Ecaterinca, a beautiful baroque church steeped in history.","attractionList":[{"name":"Muzeul de Arta Timisoara","time":"2h"},{"name":"Opera Timisoara","time":"1h"},{"name":"Biserica Sfanta Ecaterinca","time":"1h"}]},"2":{"description":"On day two, immerse yourself in the city\'s past with a visit to Muzeul de Istorie to learn about Timisoara\'s history. Then, enjoy a leisurely walk through the beautiful Parcul Rozelor, and finally, take a scenic Vaporas pe Malul Begai ride, offering stunning views of the city from the water.","attractionList":[{"name":"Muzeul de Istorie","time":"2h"},{"name":"Parcul Rozelor","time":"1.5h"},{"name":"Vaporas pe Malul Begai","time":"1h"}]},"3":{"description":"On your third day, embrace local customs and traditions by visiting the uniquely-designed Sinagoga din Fabric. Then, explore the beautiful Piata Unirii, a colorful square surrounded by historical buildings. End the day with a visit to the impressive Catedrala Metropolitana, a symbol of Timisoara\'s religious heritage.","attractionList":[{"name":"Sinagoga din Fabric","time":"1h"},{"name":"Piata Unirii","time":"1h"},{"name":"Catedrala Metropolitana","time":"1h"}]},"4":{"description":"Day four offers a mix of technology, nature, and art. Start at Muzeul de Transport Public to see the evolution of public transportation in the city. Then, take a relaxing stroll through Parcul Botanic, a beautiful park with diverse plant life. Finally, visit Calina Art Gallery for a glimpse into the contemporary art scene.","attractionList":[{"name":"Muzeul de Transport Public","time":"1.5h"},{"name":"Parcul Botanic","time":"1.5h"},{"name":"Calina Art Gallery","time":"1h"}]},"5":{"description":"On your last day, indulge in some shopping at the trendy Iulius Mall and the bustling Shopping City Timisoara. Then, unwind with an exciting escape room experience at ExitGames Timisoara, a perfect way to end your memorable trip.","attractionList":[{"name":"Iulius Mall","time":"2h"},{"name":"Shopping City Timisoara","time":"2h"},{"name":"ExitGames Timisoara","time":"1h"}]}}';

Future<String> _getApiResponse(String string, int numberOfDays) async {
  String response = '{}';
  await Future.delayed(const Duration(seconds: 1));

  switch (numberOfDays) {
    case 1:
      return oneDayJson;
    case 2:
      return twoDayJson;
    case 3:
      return threeDayJson;
    case 4:
      return fourDayJson;
    default:
      {
        return fiveDayJson;
      }
  }

  return response;
}
