import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:parkingo/components/appbar.dart';
// import 'package:parkingo/components/appbar.dart';
import 'package:parkingo/components/buttons.dart';
import 'package:parkingo/components/textButton.dart';
import 'package:parkingo/components/textfield.dart';
import 'package:parkingo/pages/createaccount.dart';
import 'package:parkingo/pages/forgotPassword.dart';
import 'package:parkingo/pages/map_page.dart';

class LoginPage extends StatelessWidget {
  //functions

  //text controllers

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //sign-in/create-account

              Text(
                "Sign in",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w800),
              ),

              SizedBox(height: 35),

              //email text field
              MyTextfield(
                hintText: "email",
                obscureText: false,
                controller: emailController,
                normalBorderColor: Colors.black,
                focusedBorderColor: Colors.amber,
              ),

              SizedBox(height: 25),

              //password text field
              MyTextfield(
                hintText: "password",
                obscureText: true,
                controller: passwordController,
                normalBorderColor: Colors.black,
                focusedBorderColor: Colors.amber,
              ),
              SizedBox(height: 5),

              //forgot pasword

              MyTextButton(
                  text: "Forgot Password?",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPassword(),
                        ));
                  }),
              SizedBox(
                height: 10,
              ),
              MyButtons(
                text: "Sign In",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapPage(),
                      ));
                },
                color: Colors.amberAccent.shade400,
              ),
              SizedBox(
                height: 10,
              ),

              //sign in button
              Padding(
                padding: const EdgeInsets.only(left: 45),
                child: Row(
                  children: [
                    Text("Don't have an account?"),
                    MyTextButton(
                        text: "Create account",
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateAccount(),
                              ));
                        })
                  ],
                ),
              )

              //dont have account?register
            ],
          ),
        ),
      ),
    );
  }
}
