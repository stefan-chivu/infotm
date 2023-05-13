import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infotm/screens/auth/profile_wrapper.dart';
import 'package:infotm/screens/auth/register.dart';
import 'package:infotm/screens/home/home.dart';
import 'package:infotm/screens/pin/add_pin.dart';
import 'package:infotm/services/isar.dart';
import 'package:infotm/services/location.dart';
import 'package:infotm/ui_components/ui_specs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await IsarService.openSchemas();
  await LocationService.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
              error: AppColors.burntSienna),
        ),
        routes: {
          '/': (context) => const HomePage(),
          '/profile': (context) => const ProfileWrapper(),
          '/register': (context) => const RegisterPage(),
          '/add-pin': (context) => const AddPin(),
        });
  }
}
