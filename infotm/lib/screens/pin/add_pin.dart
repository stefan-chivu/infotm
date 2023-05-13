import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:infotm/models/address.dart';
import 'package:infotm/models/pin.dart';

import 'package:infotm/screens/home/home.dart';

import 'package:infotm/services/sql.dart';
import 'package:infotm/services/location.dart';

import 'package:infotm/ui_components/custom_app_bar.dart';
import 'package:infotm/ui_components/custom_button.dart';
import 'package:infotm/ui_components/custom_textfield.dart';
import 'package:infotm/ui_components/ui_specs.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddPin extends StatefulWidget {
  const AddPin({super.key});

  @override
  State<AddPin> createState() => _AddPinState();
}

class _AddPinState extends State<AddPin> {
  final _pinNameFormKey = GlobalKey<FormState>();
  final TextEditingController _pinNameController = TextEditingController();
  String? _typeID;
  LocationInfo? _pinPosition;
  Marker? _marker;
  bool isWaiting = false;

  Future<LocationInfo>? _positionFuture;
  List<DropdownMenuItem<String>>? _dropdownFuture;

  // Initializes state variables and futures when the widget is inserted into the widget tree for the first time.
  @override
  void initState() {
    super.initState();
    _positionFuture = getLocationInfo();
    _dropdownFuture = getTypes();
  }

  // Calls getLocationInfo() when dependencies change, to update the _positionFuture variable.
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _positionFuture = getLocationInfo();
  }

  // returns pin types
  List<DropdownMenuItem<String>> getTypes() {
    // Create a list of DropdownMenuItem<String> with the desired values
    const List<DropdownMenuItem<String>> types = [
      DropdownMenuItem(
        value: 'institution',
        child: Text('institution'),
      ),
      DropdownMenuItem(
        value: 'landmark',
        child: Text('landmark'),
      ),
      DropdownMenuItem(
        value: 'church',
        child: Text('church'),
      ),
      DropdownMenuItem(
        value: 'corp',
        child: Text('corp'),
      ),
      DropdownMenuItem(
        value: 'park',
        child: Text('park'),
      ),
      DropdownMenuItem(
        value: 'monument',
        child: Text('monument'),
      ),
    ];

    return types;
  }

  // Returns the location information for the current device
  // Returns a object with the current LatLng and Address
  Future<LocationInfo> getLocationInfo() async {
    Position data = await LocationService.getCurrentLocation();

    if ((data.latitude == null || data.longitude == null) && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed fetching location data"),
        backgroundColor: AppColors.airBlue,
      ));
      return Future.error('Fetching location data failed');
    }

    try {
      LatLng crtLatLng = LatLng(data.latitude, data.longitude);
      Address address = await LocationService.addressFromLatLng(
          crtLatLng.latitude, crtLatLng.longitude);

      return LocationInfo(crtLatLng, address);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.airBlue,
        ));
      }
      return Future.error(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Create a Scaffold with a custom AppBar and a body widget
    // If isWaiting is true, show a centered CircularProgressIndicator
    // Otherwise, show a Column widget containing a Form with a CustomTextField for the sensor ID, a GoogleMap widget with a draggable Marker and a FutureBuilder for a dropdown button containing zones.
    // The FutureBuilders display a CircularProgressIndicator while waiting for the data to be retrieved and then show the relevant widgets.
    // When the CustomButton is pressed, validate the sensor ID form and add the sensor information to the database. If successful, show a SnackBar with a success message, otherwise show a SnackBar with an error message.

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: isWaiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(children: [
                FutureBuilder(
                    future: _positionFuture,
                    builder: ((BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
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
                        default:
                          if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          } else if (snapshot.hasData) {
                            _pinPosition ??= snapshot.data;
                            _marker = Marker(
                              draggable: true,
                              markerId: const MarkerId("crtLocation"),
                              position: _pinPosition!.latLng,
                              onDragEnd: (value) {
                                _pinPosition!.latLng = _marker!.position;
                              },
                            );
                            return Column(
                              children: [
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: SizedBox(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      child: GoogleMap(
                                        initialCameraPosition:
                                            const CameraPosition(
                                                target: LatLng(
                                                    45.755895, 21.228670),
                                                zoom: 12.8),
                                        tiltGesturesEnabled: false,
                                        zoomGesturesEnabled: false,
                                        rotateGesturesEnabled: false,
                                        markers: {_marker!},
                                        mapType: MapType.normal,
                                        myLocationEnabled: true,
                                        onCameraIdle: () async {
                                          try {
                                            _pinPosition!.address =
                                                await LocationService
                                                    .addressFromLatLng(
                                                        _pinPosition!
                                                            .latLng.latitude,
                                                        _pinPosition!
                                                            .latLng.longitude);
                                            setState(() {});
                                          } catch (e) {
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(e.toString()),
                                                backgroundColor:
                                                    AppColors.davyGray,
                                              ));
                                            }
                                          }
                                        },
                                        onCameraMove: (position) async {
                                          _pinPosition!.latLng =
                                              position.target;
                                          setState(() {});
                                        },
                                      ),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(AppMargins.S),
                                  child: Expanded(
                                      child: Text(
                                    _pinPosition!.address.toString(),
                                    textAlign: TextAlign.center,
                                  )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(AppMargins.S),
                                  child: Text(
                                    "${_pinPosition!.latLng.latitude.toStringAsFixed(5)},  ${_pinPosition!.latLng.longitude.toStringAsFixed(5)}",
                                  ),
                                ),
                              ],
                            );
                          }
                      }
                      return const Text("Error updating coordinates");
                    })),
                Padding(
                  padding: const EdgeInsets.all(AppMargins.S),
                  child: Form(
                    key: _pinNameFormKey,
                    child: CustomTextField(
                      label: "Name",
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return "Please enter a valid pin name";
                        }
                        // Return null if the entered pin name is valid
                        return null;
                      },
                      controller: _pinNameController,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(AppMargins.M),
                    child: DropdownButton(
                      borderRadius: const BorderRadius.all(
                          Radius.circular(AppFontSizes.XL)),
                      hint: const Text("Type"),
                      isExpanded: true,
                      value: _typeID,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: getTypes(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _typeID = newValue!;
                        });
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.all(AppMargins.M),
                    child: CustomButton(
                        onPressed: () async {
                          if (_typeID == null && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Please select a pin type")));
                            return;
                          }
                          if (_pinNameFormKey.currentState!.validate()) {
                            setState(() {
                              isWaiting = true;
                            });
                            String result = await SqlService.addPin(
                                _pinPosition!.latLng,
                                _typeID!,
                                _pinNameController.text);
                            if (mounted) {
                              setState(() {
                                isWaiting = false;
                              });
                              if (!result.contains("success")) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(result)));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(result)));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()),
                                );
                              }
                            }
                          }
                        },
                        text: "Add Pin")),
              ]));
  }
}

// A class representing location information with a latitude-longitude and an address
class LocationInfo {
  LocationInfo(this.latLng, this.address);

  LatLng latLng;
  Address address;

  @override
  String toString() => '$address'.split(',')[0];
}
