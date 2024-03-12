import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddVehicle extends StatefulWidget {
  const AddVehicle({Key? key}) : super(key: key);

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  final registrationNumberController = TextEditingController();
  String? vehicleType;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _addVehicleDetails() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String? uid = _auth.currentUser!.email;
        print("uid:" + uid!);
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Reference to the current user's document in the 'users' collection
        DocumentReference userDocRef = firestore
            .collection('users')
            .doc(uid)
            .collection("vehicle_collection")
            .doc("cyZSEwpLQUuM2iLPlRdo");

        // Update the document with the new vehicle details
        await userDocRef.update({
          'vehicle_details': {
            'registration_number': registrationNumberController.text,
            'vehicle_type': vehicleType,
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vehicle details added successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not signed in')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add vehicle details: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Add vehicle details",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Type ",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      ListTile(
                        title: Text("Two wheeler"),
                        leading: Radio(
                            value: 'Two wheeler',
                            groupValue: vehicleType,
                            onChanged: (val) {
                              setState(() {
                                vehicleType = val.toString();
                              });
                            }),
                      ),
                      ListTile(
                        title: Text("Three wheeler"),
                        leading: Radio(
                            value: 'Three wheeler',
                            groupValue: vehicleType,
                            onChanged: (val) {
                              setState(() {
                                vehicleType = val.toString();
                              });
                            }),
                      ),
                      ListTile(
                        title: Text("Four wheeler"),
                        leading: Radio(
                            value: 'Four wheeler',
                            groupValue: vehicleType,
                            onChanged: (val) {
                              setState(() {
                                vehicleType = val.toString();
                              });
                            }),
                      ),
                      ListTile(
                        title: Text("others"),
                        leading: Radio(
                            value: 'others',
                            groupValue: vehicleType,
                            onChanged: (val) {
                              setState(() {
                                vehicleType = val.toString();
                              });
                            }),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Vehicle Type:', style: TextStyle(fontSize: 16.0)),
                      Text(
                        vehicleType ?? 'Not selected',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 17),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: registrationNumberController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                      labelText: "Registration Number",
                      hintText: "KL-00-XX-0000",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addVehicleDetails,
                    child: Text('Add Vehicle Details'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
