import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  // include constructor strings for the data like pick points etc.
  // maybe even include boolean where this is readonly page or editable page
  // if its read only page then we dont show another bar underneath showing date and time.
  // if its editable page then we show the bar underneath showing date and time.

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Coordinates'),
      ),
      body: GoogleMap(
        liteModeEnabled: true,
        buildingsEnabled: true,
        compassEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onLongPress: null, //implement the long press to add markers
        onTap: null, //implement the on tap to add markers
        mapToolbarEnabled: true,
        fortyFiveDegreeImageryEnabled: true,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('Reset Coordinates'),
        icon: const Icon(Icons.clear_rounded),
      ),
    );
    // final Map<String, Marker> _markers = {};
  }

  //TODO: make this function reset the coordinates on this map instead
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
