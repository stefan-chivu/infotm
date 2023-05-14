import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:infotm/ui_components/ui_specs.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  // ignore: library_private_types_in_public_api
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
    setState(() {
      _connectivityResult = ConnectivityResult.none;
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
              const Icon(
                Icons.signal_wifi_off,
                size: 48,
                color: AppColors.burntSienna,
              ),
              const SizedBox(height: 16),
              const Text(
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
                child: const Text('Retry'),
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
