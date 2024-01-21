import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parkingo/components/buttons.dart';
import 'package:parkingo/components/textButton.dart';
import 'package:parkingo/components/textfield.dart';
import 'package:parkingo/pages/login-signup.dart';
import 'package:parkingo/pages/personal.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  final confirmpasswordController = new TextEditingController();

  Future<void> _registerUser(BuildContext context) async {
    String username = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmpasswordController.text.trim();

    // Check if passwords match
    if (password != confirmPassword) {
      // Show an error message
      _showErrorDialog(context, 'Passwords do not match');
      return;
    }

    try {
      // Initialize Firebase
      await Firebase.initializeApp();

      // Create user with email and password
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: username, password: password);

      // User created successfully
      print('User created: ${userCredential.user!.uid}');

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PersonalInfo(),
          ));
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuth exceptions (e.g., weak password, email already in use)
      _showErrorDialog(context, ' ${e.message}');
    } catch (e) {
      // Handle other exceptions
      _showErrorDialog(context, 'Error: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

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
                "Create Account",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w800),
              ),

              SizedBox(height: 35),

              //email text field
              MyTextfield(
                labelText: "email",
                obscureText: false,
                controller: emailController,
                normalBorderColor: Colors.black,
                focusedBorderColor: Colors.amber,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 15),

              //password text field
              MyTextfield(
                labelText: "password",
                obscureText: true,
                controller: passwordController,
                normalBorderColor: Colors.black,
                focusedBorderColor: Colors.amber,
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 15),
              MyTextfield(
                labelText: "confirm password",
                obscureText: true,
                controller: confirmpasswordController,
                normalBorderColor: Colors.black,
                focusedBorderColor: Colors.amber,
                keyboardType: TextInputType.text,
              ),

              SizedBox(
                height: 15,
              ),
              MyButtons(
                text: "Create Account",
                onTap: () => _registerUser(context),
                color: Colors.amberAccent.shade400,
              ),
              SizedBox(
                height: 10,
              ),

              //sign in button
              Padding(
                padding: const EdgeInsets.only(left: 35),
                child: Row(
                  children: [
                    Text("Already have an account?"),
                    MyTextButton(
                        text: "Go back to sign-in",
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
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

// ignore: must_be_immutable

