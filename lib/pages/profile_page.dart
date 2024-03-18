import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parkingo/pages/bookingsDone.dart';
import 'package:parkingo/pages/bookingsRecieved.dart';
import 'package:parkingo/pages/land.dart';
import 'package:parkingo/pages/login-signup.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _reloadUser();
  }

  Future<User?> _reloadUser() async {
    User? user = await _auth.currentUser;
    if (user != null) {
      await user.reload();
      user = await _auth.currentUser; // Reload user data
    }
    return user;
  }

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

  Future<String> extractContactNumber() async {
    String contactNumber = '';
    String? uid = _auth.currentUser!.email;

    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (documentSnapshot.exists) {
        contactNumber = documentSnapshot['contact'] ?? '';
      } else {
        contactNumber = 'Contact number not found';
      }
    } catch (error) {
      print('Error fetching contact number: $error');
      contactNumber = 'Error fetching contact number';
    }
    print("Contact Number: $contactNumber");
    return contactNumber;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getLandDetails() {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email != null) {
      return FirebaseFirestore.instance
          .collection('lands_accepted')
          .doc(email)
          .snapshots();
    } else {
      return const Stream.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout_rounded),
            style: ButtonStyle(
              iconColor: MaterialStateProperty.all(Colors.red),
            ),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: FutureBuilder<String>(
              future: extractUsername(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading username');
                } else {
                  String username = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color.fromARGB(255, 247, 247, 247),
                            ),
                            child: Icon(
                              Icons.person,
                              color: Colors.amber,
                              size: 80,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          username,
                          style: TextStyle(fontSize: 24),
                        ),
                        SizedBox(height: 50),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Icon(Icons.phone),
                                  SizedBox(width: 10),
                                  FutureBuilder<String>(
                                    future: extractContactNumber(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text(
                                            'Error loading contact number');
                                      } else {
                                        String contactNumber =
                                            snapshot.data ?? '';
                                        return Text(
                                          contactNumber,
                                          style: TextStyle(fontSize: 20),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Icon(Icons.email_rounded),
                                  SizedBox(width: 10),
                                  FutureBuilder<String?>(
                                    future: extractEmail(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error loading email ID');
                                      } else {
                                        String emailId = snapshot.data ?? '';
                                        return Text(
                                          emailId,
                                          style: TextStyle(fontSize: 20),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              StreamBuilder<
                                  DocumentSnapshot<Map<String, dynamic>>>(
                                stream: getLandDetails(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }

                                  if (!snapshot.hasData) {
                                    return Text('No land details found');
                                  }

                                  final data = snapshot.data!.data();
                                  if (data == null) {
                                    return Text('No land details found');
                                  }

                                  return Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromARGB(255, 32, 32, 32)
                                              .withOpacity(0.5), // Shadow color
                                          spreadRadius: 2, // Spread radius
                                          blurRadius: 5, // Blur radius
                                          offset: Offset(0, 1), // Offset
                                        ),
                                      ],
                                      color: Color.fromARGB(255, 254, 251, 211),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Your Land Details',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Owner: ${data['landownerName']}',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        Row(
                                          children: [
                                            Text('Parking spots available:'),
                                            Text(
                                              ' ${data['landArea']} slots',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ],
                                        ),
                                        Text('Parking Fees:'),
                                        ...data['parkingFees'].entries.map(
                                              (entry) => Row(
                                                children: [
                                                  Text('${entry.key}: '),
                                                  Text('${entry.value}'),
                                                ],
                                              ),
                                            ),
                                        SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BookingsReceived()));
                                          },
                                          child: Text(
                                            "Bookings",
                                            style:
                                                TextStyle(color: Colors.amber),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 20),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddLand(
                                          username: username,
                                          contactNumber: extractContactNumber()
                                              .toString()),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Add Parking Land if you have!",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 88, 71, 0),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BookingsDone()));
                                },
                                child: Text(
                                  "Bookings Done",
                                  style: TextStyle(color: Colors.amber),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> extractEmail() async {
    String? email = _auth.currentUser?.email;
    return email;
  }
}
