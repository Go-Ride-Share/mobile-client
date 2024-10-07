import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPicker extends StatefulWidget {
  final Function(LatLng) onLocationPicked;
  final String label;

  const LocationPicker({super.key, required this.onLocationPicked, required this.label});

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  LatLng? _pickedLocation;

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
    widget.onLocationPicked(position);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.label),
        SizedBox(
          height: 300,
          width: double.infinity,
          child: GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.7749, -122.4194), // Default to San Francisco
              zoom: 10,
            ),
            onTap: _selectLocation,
            markers: _pickedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('picked-location'),
                      position: _pickedLocation!,
                    ),
                  }
                : {},
          ),
        ),
        if (_pickedLocation != null)
          Text(
              'Selected Location: ${_pickedLocation!.latitude}, ${_pickedLocation!.longitude}'),
      ],
    );
  }
}
