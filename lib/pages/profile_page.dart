import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkingo/pages/login-signup.dart';
import 'package:parkingo/pages/utils.dart';
import 'package:parkingo/pages/vehicle.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late String _userName = "";
  late String _place = "";
  late int _contactNumber = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    setState(() {
      _isLoading = true; // Set loading state to true while fetching data
    });

    String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    print("UID: $uid");

    if (uid.isNotEmpty) {
      try {
        DocumentSnapshot userSnapshot =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (userSnapshot.exists) {
          print('User Snapshot: $userSnapshot');

          // Accessing user data
          String firstName = userSnapshot.get('first name');
          String lastName = userSnapshot.get('last name');
          String place = userSnapshot.get('place');
          int contactNumber = userSnapshot.get('contact number');

          print('Username: $firstName');
          print('Place: $place');
          print('Contact Number: $contactNumber');

          // Set state or update variables with retrieved data
          setState(() {
            _userName = "$firstName $lastName";
            _place = place;
            _contactNumber = contactNumber;
          });
        } else {
          print('User with UID $uid does not exist in Firestore');
        }
      } catch (e) {
        print('Error fetching user info: $e');
      } finally {
        setState(() {
          _isLoading = false; // Set loading state to false when done fetching
        });
      }
    } else {
      print('User is not logged in or UID is empty');
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  Future<void> _refreshData() async {
    // Fetch new data or refresh existing data
    await fetchUserInfo();
  }

  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                if (_isLoading) // Show circular progress indicator while loading
                  CircularProgressIndicator(),
                if (!_isLoading)
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 100,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT4znITWJipPxYSgCLy_sb-G_K8_U3S0byImaqI8rwjo3uO21NVoVg2tkq8ApYgaHHH4oQ&usqp=CAU'),
                              radius: 100,
                            ),
                      Positioned(
                        child: IconButton(
                          icon: Icon(Icons.add_a_photo),
                          onPressed: () {
                            selectImage();
                          },
                        ),
                        bottom: -10,
                        right: -10,
                      )
                    ],
                  ),
                SizedBox(height: 20),
                Text(
                  _userName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 50),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: [
                        _buildUserInfoRow(Icons.place, _place),
                        _buildDivider(),
                        _buildUserInfoRow(
                            Icons.phone, _contactNumber.toString()),
                        _buildDivider(),

                        // Add more user information rows as needed
                        SizedBox(height: 10),
                        // Add other UI components as needed
                        Text("Add Vehicle details"),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddVehicle(),
                                ));
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 197, 197, 197),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.add,
                              color: const Color.fromARGB(255, 78, 78, 78),
                              size: 35,
                            ),
                          ),
                        ),

                        SizedBox(height: 35),
                        Row(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: logout,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.logout_rounded,
                                  color: Colors.red,
                                  size: 35,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                print("Pressed Settings");
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.settings,
                                  color: Colors.grey[900],
                                  size: 35,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 35),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(fontSize: 18),
        )
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: const Color.fromARGB(255, 39, 39, 39),
      margin: EdgeInsets.symmetric(vertical: 10),
    );
  }
}
