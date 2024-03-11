import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkingo/pages/admin.dart';
import 'package:parkingo/pages/map_page.dart';
import 'package:parkingo/pages/onboarding.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show loading indicator while checking authentication state
          }

          if (snapshot.hasData) {
            User? user = snapshot.data;
            if (user != null) {
              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user
                        ?.email) // Use user?.email to handle null user cases
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return Text('Error: No user data found');
                  }

                  var userData = snapshot.data!
                      .data(); // Retrieve the data map from the DocumentSnapshot

                  if (userData == null || !(userData is Map<String, dynamic>)) {
                    return Text('Error: User data is missing or invalid');
                  }

                  bool isAdmin = userData['isAdmin'] ??
                      false; // Use null-aware operator to handle missing 'isAdmin'

                  // Redirect based on isAdmin value
                  if (isAdmin) {
                    return AdminPage();
                  } else {
                    return MapPage();
                  }
                },
              );
            } else {
              return OnBoard(); // Show OnBoard page if user is not authenticated
            }
          } else {
            return OnBoard(); // Show OnBoard page if user is not authenticated
          }
        },
      ),
    );
  }
}
