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
  MapWindow({Key? key, required this.markers}) : super(key: key);

  final Map<MarkerId, Marker> markers;

  @override
  State<MapWindow> createState() => _MapWindowState();
}

class _MapWindowState extends State<MapWindow> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _zoomToFitMarkers());
  }

  void _zoomToFitMarkers() {
    LatLngBounds bounds = LatLngBounds(
      southwest: widget.markers.values.first.position,
      northeast: widget.markers.values.last.position,
    );
    print("Bounds: $bounds");
    CameraUpdate cameraUpdate = CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(
          (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
          (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
        ),
        zoom: 10,
      ),
    );
    _controller.future.then((controller) => controller.animateCamera(cameraUpdate));
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
                  zoom: 10,
                ),
                buildingsEnabled: true,
                zoomGesturesEnabled: true,
                onTap: (LatLng position) => _zoomToFitMarkers(),
                markers: Set<Marker>.of(widget.markers.values),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ));
  }
}
