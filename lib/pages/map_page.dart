import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class MapPage extends StatefulWidget {
  const MapPage({super.key});
  // maybe even include boolean where this is readonly page or editable page
  // if its read only page then we dont show another bar underneath showing date and time.
  // if its editable page then we show the bar underneath showing date and time.

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  _MapPageState();

  GoogleMapController? mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  bool originChosen = false;
  bool destinationChosen = false;
  static const String ORIGIN = "Origin";
  static const String DESTINATION = "Destination";
  static final Map<String, String> _addressData = {
    ORIGIN: 'Loading...',
    DESTINATION: 'Loading...',
  };

  //TODO: make this into a function that takes lat longs existing and returns center, otherwise returns winnipeg default.
  // useful for readonly mode
  static const LatLng center = LatLng(49.8951, -97.1384);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // only return with markers if both origin and destination are chosen
            if(destinationChosen && originChosen){
              Navigator.pop(context, markers);
            }else{
              Navigator.pop(context);
            } 
          },
        ),
        title: const Text('Select Coordinates'),
      ),
      body: GoogleMap(
        onMapCreated: onMapCreated,
        markers: Set<Marker>.of(markers.values),
        onTap: (LatLng tapPos) => _addMarker(tapPos),
        initialCameraPosition: const CameraPosition(target: center, zoom: 10.4746),
        buildingsEnabled: true,
        compassEnabled: true,
        myLocationButtonEnabled: false,
        mapToolbarEnabled: true,
        zoomControlsEnabled: false,
        zoomGesturesEnabled: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _resetCoordinates,
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

  void _addMarker(LatLng location) {
    String markerIdVal;
    BitmapDescriptor markerIcon;

    if (!originChosen) {
      markerIdVal = ORIGIN;
      markerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      originChosen = true;
    }else if(!destinationChosen){
      markerIdVal = DESTINATION;
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
        snippet: _addressData[markerIdVal],
        onTap: () =>_removeMarker(markerId),
      ),
      icon: markerIcon,
      onDragEnd: (LatLng newPosition) => _onMarkerDragEnd(markerId, newPosition),
      draggable: true,
    );

    //set state first because we want the marker to display without lags.
    //updating marker info is async and will take time. So that updates later.
    setState(() {
      markers[markerId] = marker;
    });
    _updateMarkerInfo(markerId, location);  
  }

  void _removeMarker(MarkerId markerId) {
    setState(() {
      _resetFlags(markerId);
      markers.remove(markerId);
    });
  }

  Future<void> _onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
    _resetFlags(markerId);
    _addMarker(newPosition);
    _updateMarkerInfo(markerId, newPosition);
  }

  void _resetFlags(MarkerId markerId) {
    setState(() {
      if (markerId.value == ORIGIN) {
        originChosen = false;
      } else if (markerId.value == DESTINATION) {
        destinationChosen = false;
      }
    });
  }

  void _resetCoordinates() {
    setState(() {
      originChosen = false;
      destinationChosen = false;
      markers.clear();
    });
  }

  Future<void> _updateMarkerInfo(MarkerId markerId, LatLng position) async {
    await _findPlaceName(markerId, position);
    setState(() {
      final Marker marker = markers[markerId]!;
      markers[markerId] = marker.copyWith(
        infoWindowParam: marker.infoWindow.copyWith(
          snippetParam: _addressData[markerId.value]!,
        ),
      );
    });
  }

  Future<void> _findPlaceName(MarkerId markerId, LatLng position) async {
    List<Placemark> newPlace = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placeMark  = newPlace.first; 

    String? streetName = placeMark.street;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;

    // for remote locations, API gives the same street and locality names. `placemark.name` is supposedly "the most appropriate name" for remote locations.
    if (streetName == locality) {
      streetName = placeMark.name;
    }

    setState(() {
      _addressData[markerId.value] = "$streetName, $locality, $administrativeArea"; // update _address
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
