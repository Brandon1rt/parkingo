import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:parkingo/pages/login-signup.dart';

class OnBoard extends StatelessWidget {
  const OnBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardingSlider(
        controllerColor: Colors.black,
        headerBackgroundColor: Color.fromARGB(255, 255, 255, 255),
        pageBackgroundColor: Color.fromARGB(255, 255, 255, 255),
        addController: true,
        addButton: true,
        centerBackground: true,
        hasFloatingButton: true,
        hasSkip: true,
        imageVerticalOffset: 80,
        indicatorAbove: false,
        leading: null,
        middle: null,
        trailing: null,
        finishButtonText: 'Register',
        onFinish: () => {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ))
        },
        finishButtonStyle: FinishButtonStyle(
          backgroundColor: Color.fromARGB(255, 91, 91, 91),
        ),
        skipTextButton: Text('Skip'),
        background: [
          Image.asset("assets/images/search.jpg"),
          Image.asset('assets/images/save.jpg'),
          Image.asset('assets/images/land.jpg'),
        ],
        totalPage: 3,
        speed: 1.8,
        pageBodies: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 480,
                ),
                Text(
                  'Tired of searching for a perfect parking spot?',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Let us find best spot",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 480,
                ),
                Text(
                  'Customised Pricing',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Pay only for the time you parked your vehicle",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 480,
                ),
                Text(
                  'Earn with us',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Let your land earn for you",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
