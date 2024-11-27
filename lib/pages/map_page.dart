import 'package:geocoding/geocoding.dart';
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
  static const String ORIGIN = "Origin";
  static const String DESTINATION = "Destination";

  // bool showBanner = false;
  GoogleMapController? mapController;
  bool originChosen = false;
  bool destinationChosen = false;
  Map<String, String> _addressData = {
    ORIGIN: 'Loading...',
    DESTINATION: 'Loading...',
  };

  //TODO: make this into a function that takes lat longs existing and returns center, otherwise returns winnipeg default.
  static const LatLng center = LatLng(-33.86711, 151.1947171);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId? selectedMarker;
  LatLng? markerPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Coordinates'),
      ),
      body: GoogleMap(
        onMapCreated: onMapCreated,
        initialCameraPosition: const CameraPosition(target: center, zoom: 14.4746),
        buildingsEnabled: true,
        compassEnabled: true,
        markers: Set<Marker>.of(markers.values),
        onTap: (LatLng tapPos) => _addMarker(tapPos),
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
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    setState(() {
      mapController = controller;
    });
  }

  Future<void> _onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
    setState(() {
      //reset the origin and destination flags if the marker is dragged, so it can be drawn again
      if (markerId.value == _addressData.keys.elementAt(0)) {
        originChosen = false;
      } else if (markerId.value == _addressData.keys.elementAt(1)) {
        destinationChosen = false;
      }
      _addMarker(newPosition);
    });
    _updateMarkerInfo(markerId, newPosition);
  }

  void _addMarker(LatLng location) {
    String markerIdVal;
    BitmapDescriptor markerIcon;
    if (!originChosen) {
      markerIdVal = _addressData.keys.elementAt(0);
      markerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      originChosen = true;
    }else if(!destinationChosen){
      markerIdVal = _addressData.keys.elementAt(1);
      markerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      destinationChosen = true;
    }else{
      return;
    }

    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: location,
      infoWindow: InfoWindow(
        title: markerIdVal,
        snippet: 'Loading...',
        onTap: () =>_removeMarker(markerId),
      ),
      icon: markerIcon,
      onDragEnd: (LatLng newPosition) => _onMarkerDragEnd(markerId, newPosition),
      draggable: true,
    );

    setState(() {
      markers[markerId] = marker;
    });
    _updateMarkerInfo(markerId, location);
  }

  void _removeMarker(MarkerId markerId) {
    setState(() {
      if (markerId.value == "origin") {
        originChosen = false;
      } else if (markerId.value == "destination") {
        destinationChosen = false;
      }
      markers.remove(markerId);
    });
  }

  void resetCoordinates() {
    setState(() {
      originChosen = false;
      destinationChosen = false;
      markers.clear();
    });
  }

  Future<void> _updateMarkerInfo(MarkerId markerId, LatLng position) async {
    String place = await _getPlace(position);
    setState(() {
      final Marker marker = markers[markerId]!;
      markers[markerId] = marker.copyWith(
        infoWindowParam: marker.infoWindow.copyWith(
          snippetParam: place,
        ),
      );
    });
  }

  Future<String> _getPlace(LatLng position) async {
  List<Placemark> newPlace = await placemarkFromCoordinates(position.latitude, position.longitude);
  print("I am here");

  print(newPlace);
  // this is all you need
  Placemark placeMark  = newPlace[0]; 
  String? name = placeMark.name;
  String? locality = placeMark.locality;
  String? administrativeArea = placeMark.administrativeArea;
  String? address = "$name, $locality, $administrativeArea";
  print("ToString: " + newPlace[0].toString());
  // setState(() {
  //   _address = address; // update _address
  // });
  return address;
}

  @override
  void dispose() {
    super.dispose();
  }
}
