import 'package:flutter/material.dart';
import 'package:go_ride_sharing/pages/map_page.dart';
import 'package:go_ride_sharing/theme.dart';
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

  @override
  State<MapWindow> createState() => _MapWindowState();
}

class _MapWindowState extends State<MapWindow> {
  CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 50.4746,
  );

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
    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 10);
    controller.animateCamera(cameraUpdate);
  }

  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Card(
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              child: IgnorePointer(
                child: GoogleMap(
                  initialCameraPosition: _cameraPosition,
                  buildingsEnabled: true,
                  compassEnabled: true,
                  myLocationEnabled: true,
                  markers: {
                    Marker(
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueGreen),
                      infoWindow: InfoWindow(title: 'Origin'),
                      markerId: MarkerId('1'),
                      position: LatLng(37.42796133580664, -122.085749655962),
                    ),
                    Marker(
                      markerId: MarkerId('2'),
                      infoWindow: InfoWindow(title: 'Destination'),
                      position: LatLng(37.43296265331129, -122.08832357078792),
                    ),
                  },
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              )),
        ),
        Positioned(
          top: 20,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              backgroundColor: notYellow,
              foregroundColor: notBlack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: Icon(Icons.pin_drop),
            label: Text("Choose Locations"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapPage(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
