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

  String _address = ""; // create this variable

  // bool showBanner = false;
  GoogleMapController? mapController;
  bool originChosen = false;
  bool destinationChosen = false;

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

  Future<void> _onMarkerDrag(MarkerId markerId, LatLng newPosition) async {
    setState(() {
      // if (markerId.value == "origin") {
      //   originChosen = false;
      // } else if (markerId.value == "destination") {
      //   destinationChosen = false;
      // }
      markerPosition = newPosition;
    });
    // _updateMarkerInfo(markerId, newPosition);
  }

  Future<void> _onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
    setState(() {
      if (markerId.value == "origin") {
        originChosen = false;
      } else if (markerId.value == "destination") {
        destinationChosen = false;
      }
      markerPosition = newPosition;
    });
    _updateMarkerInfo(markerId, newPosition);
  }

  void _addMarker(LatLng location) {
    String markerIdVal;
    BitmapDescriptor markerIcon;
    if (!originChosen) {
      markerIdVal = 'origin';
      markerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      originChosen = true;
    }else if(!destinationChosen){
      markerIdVal = 'destination';
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
      onDrag: (LatLng position) => _onMarkerDrag(markerId, position),
      // onDragEnd: (LatLng newPosition) => _onMarkerDragEnd(markerId, newPosition),
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
  String? subLocality = placeMark.subLocality;
  String? locality = placeMark.locality;
  String? administrativeArea = placeMark.administrativeArea;
  String? postalCode = placeMark.postalCode;
  String? country = placeMark.country;
  String? address = "$name, $subLocality, $locality, $administrativeArea $postalCode, $country";
  
  print(address);

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
