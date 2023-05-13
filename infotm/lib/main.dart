import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infotm/screens/auth/profile_wrapper.dart';
import 'package:infotm/screens/auth/register.dart';
import 'package:infotm/screens/home/connectivity_wrapper.dart';
import 'package:infotm/screens/home/home.dart';
import 'package:infotm/screens/trip/questionaire.dart';
import 'package:infotm/services/isar.dart';
import 'package:infotm/services/location.dart';
import 'package:infotm/ui_components/ui_specs.dart';
import 'package:connectivity/connectivity.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await IsarService.openSchemas();
  await LocationService.init();

  runApp(
    const ProviderScope(child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'infotm',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.davyGray,
          secondary: AppColors.airBlue,
          tertiary: AppColors.sunset,
          outline: AppColors.airBlue,
          error: AppColors.burntSienna,
        ),
      ),
      routes: {
        '/': (context) => const ConnectivityWrapper(
              child: HomePage(),
            ),
        '/profile': (context) => const ProfileWrapper(),
        '/register': (context) => const RegisterPage(),
        '/plan-trip': (context) => const TripQuestionaire(),
      },
    );
  }
}
