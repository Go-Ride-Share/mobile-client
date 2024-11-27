import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class MapPage extends StatefulWidget {
  MapPage({super.key});
  bool showBanner = false;
  // include constructor strings for the data like pick points etc.
  // maybe even include boolean where this is readonly page or editable page
  // if its read only page then we dont show another bar underneath showing date and time.
  // if its editable page then we show the bar underneath showing date and time.

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  _MapPageState();

  // bool showBanner = false;
  bool choseOrigin = false;
  bool choseDestination = false;

  GoogleMapController? mapController;
  LatLng? _lastTap;
  LatLng? _lastLongPress;

  static const LatLng center = LatLng(-33.86711, 151.1947171);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId? selectedMarker;
  int _markerIdCounter = 1;
  LatLng? markerPosition;

  // TODO: eventually get camera position from the parent object using a function
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Coordinates'),
      ),
      body: GoogleMap(
        onMapCreated: onMapCreated,
        initialCameraPosition: _kGooglePlex,
        buildingsEnabled: true,
        compassEnabled: true,
        markers: Set<Marker>.of(markers.values),

        // onLongPress: null, //implement the long press to add markers
        // onTap: null, //implement the on tap to add markers
        onTap: (LatLng tapPos) => {
          setState(() {
            _lastTap = tapPos;
            _addMarker(tapPos);
            print('Tapped: $_lastTap');
          }),
        },
        onLongPress: (LatLng longPressPos) => {
          setState(() {
            _lastLongPress = longPressPos;
            print('Long Pressed: $_lastLongPress');
          }),
        },
        // onLongPress: ,
        mapToolbarEnabled: true,
        zoomControlsEnabled: false,
        zoomGesturesEnabled: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            widget.showBanner = !widget.showBanner;
            resetCoordinates();
          });
        },
        label: const Text('Reset Coordinates'),
        icon: const Icon(Icons.clear_rounded),
      ),
    );
    // final Map<String, Marker> _markers = {};
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    setState(() {
      mapController = controller;
    });
  }

  Future<void> _onMarkerDrag(MarkerId markerId, LatLng newPosition) async {
    setState(() {
      markerPosition = newPosition;
    });
  }

  void _addMarker(LatLng location) {
    final int markerCount = markers.length;
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: location,
      infoWindow: InfoWindow(
        title: "Marker",
        snippet: 'This is a marker',
        onTap: () =>_removeMarker(markerId),
      ),
      onDrag: (LatLng position) => _onMarkerDrag(markerId, position),
      draggable: true,
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  void _removeMarker(MarkerId markerId) {
    setState(() {
      if (markers.containsKey(markerId)) {
        markers.remove(markerId);
      }
    });
  }

  void resetCoordinates() {
    setState(() {
      markers.clear();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
