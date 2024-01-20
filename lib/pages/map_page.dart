// ignore_for_file: unused_import, unused_field

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkingo/components/appbar.dart';
import 'package:parkingo/pages/login-signup.dart';
import 'package:parkingo/pages/profile_page.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _controller;
  List<Marker> _markers = [];
  Set<Marker> _filteredMarkers = Set<Marker>();

  @override
  void initState() {
    super.initState();
    // Add markers for all locations (hospitals in this example)
    _addMarkers();
  }

  void _addMarkers() {
    // Add markers for all locations (hospitals in this example)
    List<Marker> markers = [
      Marker(
        markerId: MarkerId('hospital1'),
        position: LatLng(37.7749, -122.4194),
        infoWindow: InfoWindow(title: 'Hospital 1'),
      ),
      Marker(
        markerId: MarkerId('hospital2'),
        position: LatLng(37.7749, -122.4294),
        infoWindow: InfoWindow(title: 'Hospital 2'),
      ),
      // Add more hospitals as needed
    ];

    setState(() {
      _markers = markers;
      _filteredMarkers = Set<Marker>.from(_markers);
    });
  }

  // Function to filter markers based on a specific category (e.g., hospitals)
  void _filterMarkers() {
    // For demonstration purposes, let's filter only hospitals
    Set<Marker> filteredMarkers = _markers
        .where((marker) => marker.markerId.value.contains('hospital'))
        .toSet();

    setState(() {
      _filteredMarkers = filteredMarkers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('P A R K I N G O'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10)),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ));
              },
              icon: Icon(Icons.person_2_rounded))
        ],
        automaticallyImplyLeading: false,
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        markers: _filteredMarkers,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 12.0,
        ),
      ),
    );
  }
}
