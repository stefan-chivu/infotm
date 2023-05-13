import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infotm/screens/auth/profile_wrapper.dart';
import 'package:infotm/screens/auth/register.dart';
import 'package:infotm/screens/home/home.dart';
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
      home: ConnectivityWrapper(
        child: const HomePage(),
      ),
      routes: {
        '/profile': (context) => const ProfileWrapper(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;

  const ConnectivityWrapper({required this.child});

  @override
  _ConnectivityWrapperState createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  late ConnectivityResult _connectivityResult;
  late Stream<ConnectivityResult> _connectivityStream;

  @override
  void initState() {
    super.initState();
    _connectivityStream = Connectivity().onConnectivityChanged;
    _connectivityStream.listen((ConnectivityResult result) {
      setState(() {
        _connectivityResult = result;
      });
    });
    Connectivity().checkConnectivity().then((ConnectivityResult result) {
      setState(() {
        _connectivityResult = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_connectivityResult == ConnectivityResult.none) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.signal_wifi_off,
                size: 48,
                color: AppColors.burntSienna,
              ),
              const SizedBox(height: 16),
              Text(
                'No Internet Connection',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Connectivity().checkConnectivity().then(
                    (ConnectivityResult result) {
                      setState(() {
                        _connectivityResult = result;
                      });
                    },
                  );
                },
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    } else {
      return widget.child;
    }
  }
}
