import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationData _currentLocation;
  Set<Marker> _markers = {};

  Future<void> _getCurrentLocation() async {
    final location = Location();
    final hasPermission = await location.requestPermission();

    if (hasPermission == PermissionStatus.granted) {
      final currentLocation = await location.getLocation();
      setState(() {
        _currentLocation = currentLocation;
        
        _markers.add(
        Marker(
          markerId: MarkerId('myLocation'),
          position: LatLng(37.7749, -122.4194),
          infoWindow: InfoWindow(
            title: 'My Location',
            snippet: 'San Francisco',
          ),
        ),
      );




      });
    }
  }

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> locationMap = {'latitude': 37.7749, 'longitude': -122.4194};
    _currentLocation = LocationData.fromMap(locationMap);
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLocation == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final initialCameraPosition = CameraPosition(
      target: LatLng(_currentLocation.latitude ?? 0, _currentLocation.longitude ?? 0),
      zoom: 16,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Map Screen'),
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: {
          Marker(
            markerId: MarkerId('current_location'),
            position: LatLng(_currentLocation.latitude ?? 0, _currentLocation.longitude ?? 0),
          ),
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Return the latitude and longitude to the previous screen
          Navigator.pop(context, _currentLocation);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}