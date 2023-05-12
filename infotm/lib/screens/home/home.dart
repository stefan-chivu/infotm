import 'package:flutter/material.dart';
import 'package:infotm/ui_components/custom_nav_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infotm/ui_components/ui_specs.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng? tmpPosition;
  GoogleMapController? _mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
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
          myLocationEnabled: true,
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
  }
}
