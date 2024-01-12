import 'package:flutter/material.dart';
// import 'package:parkingo/pages/map_page.dart';
import 'package:parkingo/pages/onboarding.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Uncomment this line
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  // print('its working');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
  });

  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: /*isFirstTime ? */ OnBoard() /* : MapPage(),*/
        );
  }
}

// class SplashScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<bool?>(
//       future: getBoolFromSharedPreferences(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // If the value is still loading, you can show a loading indicator
//           return CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           // Handle error
//           return Text('Error: ${snapshot.error}');
//         } else {
//           // Check the boolean value and navigate accordingly
//           bool shouldShowOnboarding = snapshot.data ?? true;
//           return shouldShowOnboarding ? OnBoard() : MapPage();
//         }
//       },
//     );
//   }

//   Future<bool?> getBoolFromSharedPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getBool('showOnboarding');
//   }
// }
