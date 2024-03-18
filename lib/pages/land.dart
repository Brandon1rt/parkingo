import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkingo/components/textfield.dart';

class AddLand extends StatefulWidget {
  final String username;
  final String contactNumber;
  const AddLand({Key? key, required this.username, required this.contactNumber})
      : super(key: key);

  @override
  State<AddLand> createState() => _AddLandState();
}

class _AddLandState extends State<AddLand> {
  late TextEditingController _landownerNameController;
  late TextEditingController _landAreaController;
  late Map<String, TextEditingController> _vehicleControllers;
  late LatLng _selectedLocation; // Store selected location here

  @override
  void initState() {
    super.initState();
    _landownerNameController = TextEditingController();
    _landAreaController = TextEditingController();
    _vehicleControllers = {
      'Car': TextEditingController(),
      'Bike': TextEditingController(),
      'Truck': TextEditingController(),
      'Bicycle': TextEditingController(),
    };
    _selectedLocation = LatLng(0, 0); // Default location
  }

  @override
  void dispose() {
    _landownerNameController.dispose();
    _landAreaController.dispose();
    _vehicleControllers.forEach((key, value) {
      value.dispose();
    });
    super.dispose();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> extractUsername() async {
    String uname = '';
    String? uid = _auth.currentUser!.email;
    print("uid: " + uid!);

    try {
      // Access the Firestore instance and retrieve the document snapshot
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid) // Add your document ID here
          .get();

      // Check if the document exists and contains the 'username' field
      if (documentSnapshot.exists) {
        // Access the 'username' field from the document data
        uname = documentSnapshot['username'];
      } else {
        // Handle if the document doesn't exist
        uname = 'Document does not exist';
      }
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error fetching username: $error');
      uname = 'Error fetching username';
    }
    print("Username: " + uname);
    return uname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Add parking spot details",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: widget.username,
                  labelText: "Land owner name",
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
                controller: _landownerNameController,
              ),
              SizedBox(height: 20),
              MyTextfield(
                controller: _landAreaController,
                focusedBorderColor: Colors.amber,
                keyboardType: TextInputType.number,
                labelText: "Parking Spots available",
                normalBorderColor: Colors.black,
                obscureText: false,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Open location picker here
                  Position? selectedPosition = await _selectLocation();
                  if (selectedPosition != null) {
                    setState(() {
                      _selectedLocation = LatLng(selectedPosition.latitude,
                          selectedPosition.longitude);
                    });
                  } else if (selectedPosition == null) {
                    SnackBar(
                        content: Text(
                            "Select a Location by pressing the button SELECT LOCATION"));
                  }
                },
                child: Text(
                  'Select Location',
                  style: TextStyle(color: Colors.amber),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 300, // Adjust the height according to your requirement
                child: ListView.builder(
                  itemCount: _vehicleControllers.length,
                  itemBuilder: (BuildContext context, int index) {
                    String vehicleType =
                        _vehicleControllers.keys.toList()[index];
                    return Column(
                      children: [
                        TextFormField(
                          controller: _vehicleControllers[vehicleType],
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            labelText: 'Parking Fee for $vehicleType (Rupees)',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    String? uid = _auth.currentUser!.email;

                    // Ensure the user is authenticated
                    if (uid != null) {
                      // Check if any of the fields are empty
                      if (_landownerNameController.text.isEmpty ||
                          _landAreaController.text.isEmpty ||
                          _selectedLocation.latitude == 0 ||
                          _selectedLocation.longitude == 0 ||
                          _vehicleControllers.values
                              .any((controller) => controller.text.isEmpty)) {
                        // Show a message popup box indicating that all fields are required
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Missing Information"),
                              content: Text(
                                  "Please fill in all fields before saving."),
                              actions: <Widget>[
                                TextButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // All fields are filled, proceed to save data to Firestore
                        CollectionReference landCollection =
                            FirebaseFirestore.instance.collection('lands');

                        // Add land details to the 'lands' collection with the specified document ID

                        // Create the 'user_land' collection and insert values
                        await landCollection.doc(uid).set({
                          'landownerName': _landownerNameController.text,
                          'landArea': int.parse(_landAreaController.text),
                          'contact': widget.contactNumber,
                          'location': GeoPoint(
                            _selectedLocation.latitude,
                            _selectedLocation.longitude,
                          ),
                          'parkingFees': _vehicleControllers.map(
                            (key, value) =>
                                MapEntry(key, double.parse(value.text)),
                          ),
                          // Add other data fields here as needed
                        });

                        // Show success message or navigate to another screen
                        _landownerNameController.clear();
                        _landAreaController.clear();
                        _vehicleControllers.forEach((key, value) {
                          value.clear();
                        });
                      }
                    } else {
                      print('User is not authenticated');
                    }
                  } catch (e) {
                    print("Error saving data: $e");
                    // Show error message
                  }
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.amber),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to select location

  Future<Position?> _selectLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled on the device.
        // Handle this case as needed.
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permission has been denied by the user.
          // Handle this case as needed.
          return null;
        }
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        // Permission has been granted.
        // Retrieve the current position.
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        print(position);
        return position;
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }
}
