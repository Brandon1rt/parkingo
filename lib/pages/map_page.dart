import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkingo/pages/bookSpot.dart';
import 'package:parkingo/pages/profile_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(0, 0),
    zoom: 15,
  );

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _updateCameraPosition(position);
    } catch (e) {
      print("Error getting user location: $e");
    }
  }

  void _updateCameraPosition(Position position) {
    setState(() {
      _initialCameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 20,
      );
    });
  }

  void _goToUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print("current position: " + position.toString());
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 20,
          ),
        ),
      );
    } catch (e) {
      print("Error getting user location: $e");
    }
  }

  void _addMarkersFromFirestore() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('lands_accepted').get();
    snapshot.docs.forEach((doc) {
      final location = doc['location'] as GeoPoint?;
      if (location != null) {
        final landArea = doc['landArea'];
        final landownerName = doc['landownerName'];
        final email = doc.id; // Assuming email is the document ID

        List<Widget> parkingFeeWidgets = [];
        if (doc['parkingFees'] != null) {
          // Check if parkingFees is not null
          (doc['parkingFees'] as Map<String, dynamic>).forEach((key, value) {
            parkingFeeWidgets.add(Text('$key: $value'));
          });
        }

        markers.add(
          Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(location.latitude, location.longitude),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Land Owner: $landownerName',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Land Area: $landArea',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ...parkingFeeWidgets,
                          SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // final userEmail =
                              // FirebaseAuth.instance.currentUser?.email;
                              /*if (userEmail != email) {*/
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BookParkingPage(email: email),
                                  ));
                              /*} else {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.error_outline_outlined,
                                              color: Colors.red,
                                              size: 60,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'You cannot book your own parking spot.',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'Please select a parking spot owned by someone else.',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }*/
                            },
                            child: Text('Book Now'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "P A R K I N G O",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: ((context) => ProfilePage())),
              );
            },
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) {
              mapController = controller;
              _addMarkersFromFirestore();
            },
            markers: markers,
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: _goToUserLocation,
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
