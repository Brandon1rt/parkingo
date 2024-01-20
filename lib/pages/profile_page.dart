import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkingo/pages/login-signup.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> logout() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LoginPage()), // Replace current page with the login page
      );
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Center(
            child: Column(children: [
          CircleAvatar(
            radius: 100,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "User_name from firebase",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                ),
                padding:
                    EdgeInsets.only(left: 30, top: 50, right: 30, bottom: 50),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.call,
                          size: 35,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "mobile_number",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    Container(
                      height: 1, // Height of the line
                      color: const Color.fromARGB(
                          255, 39, 39, 39), // Color of the line
                      margin: EdgeInsets.symmetric(
                          vertical: 10), // Adjust margin as needed
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.place,
                          size: 35,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Place",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    Container(
                      height: 1, // Height of the line
                      color: const Color.fromARGB(
                          255, 39, 39, 39), // Color of the line
                      margin: EdgeInsets.symmetric(
                          vertical: 10), // Adjust margin as needed
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.perm_identity,
                          size: 35,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "personal_id",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    Container(
                      height: 1, // Height of the line
                      color: const Color.fromARGB(
                          255, 39, 39, 39), // Color of the line
                      margin: EdgeInsets.symmetric(
                          vertical: 10), // Adjust margin as needed
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Vehicle Details",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400)),
                    SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            height: 300,
                            width: 200,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 300,
                            width: 200,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
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
                                borderRadius: BorderRadius.circular(10)),
                            child: Icon(
                              Icons.logout_rounded,
                              color: Colors.red,
                              size: 35,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            print("Pressed Settings");
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
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
          ),
        ])),
      ),
    );
  }
}
