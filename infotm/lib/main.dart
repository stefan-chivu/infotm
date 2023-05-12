import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:infotm/screens/home/home.dart';
import 'package:infotm/ui_components/ui_specs.dart';

Future<void> main() async {
  // TODO: initialize future services

  runApp(const MyApp());
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
        });
  }
}
