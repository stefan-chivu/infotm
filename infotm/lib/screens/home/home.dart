import 'package:flutter/material.dart';
import 'package:infotm/models/pin.dart';
import 'package:infotm/providers/pin_provider.dart';
import 'package:infotm/ui_components/custom_nav_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infotm/ui_components/ui_specs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  LatLng? tmpPosition;
  GoogleMapController? _mapController;

  @override
  void dispose() {
    super.dispose();
    if (_mapController != null) {
      _mapController!.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerData = ref.watch(pinProvider);
    return providerData.when(data: (providerData) {
      return Scaffold(
        body: Stack(children: [
          GoogleMap(
            // trafficEnabled: true, // TODO add toggle
            myLocationEnabled: true,
            markers: providerData.markers,
            initialCameraPosition: const CameraPosition(
                target: LatLng(45.755895, 21.228670), zoom: 12.8),
            onMapCreated: (controller) {
              _mapController = controller;
              _mapController!.setMapStyle(mapStyleString);
            },
            onCameraMove: (position) {
              setState(() {
                tmpPosition = position.target;
              });
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppMargins.S, vertical: AppMargins.L),
              child: Material(
                shape: const CircleBorder(side: BorderSide.none),
                elevation: 8,
                child: Ink(
                  decoration: const ShapeDecoration(
                    color: AppColors.davyGray,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    color: Colors.white,
                    onPressed: () async {
                      if (_mapController != null) {
                        // TODO: animate camera to new position
                      }
                    },
                    icon: const Icon(
                      Icons.my_location_rounded,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
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
