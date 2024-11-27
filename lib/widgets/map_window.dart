import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
// should draw markers if they already exist, (so when the user comes back to this page from map page, the markers are present)
// should have the button which takes to the map page on tap.
// without ontap field, shouldnt take anywhere
// should be reusable to display the maps on both pages

class MapWindow extends StatefulWidget {
  //fetch some latlongs upon creation
  //if latlongs present then edit button name to edit locations
  //otherwise keep it choose locations

  // given the latlongs, we eventually want to display the markers and route
  // this object should return the latlongs to the parent object via callback function


  //TODO: param are the coordinates, if you dont get any coordinates, then you dont show the markers

  @override
  State<MapWindow> createState() => _MapWindowState();
}

class _MapWindowState extends State<MapWindow> {

  static const String ORIGIN = "Origin";
  static const String DESTINATION = "Destination";
  // GoogleMapController? mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  static final Map<String, String> _addressData = {
    ORIGIN: 'Loading...',
    DESTINATION: 'Loading...',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _zoomToFitMarkers());
  }

  void _zoomToFitMarkers() async {
    GoogleMapController controller = await _controller.future;
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(37.42796133580664, -122.085749655962),
      northeast: LatLng(37.43296265331129, -122.08832357078792),
    );
    CameraUpdate cameraUpdate = CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(
          (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
          (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
        ),
        zoom: 14,
      ),
    );
    controller.animateCamera(cameraUpdate);
  }

  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Card(
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(49.8951, -97.1384), // Winnipeg coordinates
                  zoom: 12,
                ),
                buildingsEnabled: true,
                zoomGesturesEnabled: true,
                markers: Set<Marker>.of(markers.values),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ));
  }
}
