import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    String cno = '';
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
        cno = documentSnapshot['contact'];
      } else {
        // Handle if the document doesn't exist
        cno = 'Document does not exist';
      }
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error fetching username: $error');
      cno = 'Error fetching username';
    }
    print("Username: " + cno);
    return cno;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout_rounded),
            style:
                ButtonStyle(iconColor: MaterialStateProperty.all(Colors.red)),
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<String>(
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
                          CircleAvatar(
                            radius: 70,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            username,
                            style: TextStyle(fontSize: 24),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          SingleChildScrollView(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Add user details here
                                    SizedBox(
                                      height: 20,
                                    ),
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

                                    // printContactNumber(),
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
                                              return Text(
                                                  'Error loading email ID');
                                            } else {
                                              String emailId =
                                                  snapshot.data ?? '';
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

                                    // Add vehicle details

                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddLand(),
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
                                    // User details end
                                    // ElevatedButton(
                                    //   onPressed: () async {
                                    //     await _auth.signOut();
                                    //     Navigator.pushReplacement(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //         builder: (context) => MapPage(),
                                    //       ),
                                    //     );
                                    //   },
                                    //   child: Text('Log Out'),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
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
