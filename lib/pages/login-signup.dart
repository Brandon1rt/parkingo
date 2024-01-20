import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkingo/components/buttons.dart';
import 'package:parkingo/components/textButton.dart';
import 'package:parkingo/components/textfield.dart';
import 'package:parkingo/pages/createaccount.dart';
import 'package:parkingo/pages/forgotPassword.dart';
import 'package:parkingo/pages/map_page.dart';

class LoginPage extends StatelessWidget {
  // text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  Future<void> signIn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // If sign-in is successful, you might want to navigate to the next screen or perform other actions.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MapPage(),
        ),
      );
    } catch (e) {
      // Handle sign-in errors here
      print("Sign-in error: $e");
      // You can show a dialog, toast, or set an error message in your UI.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign in",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 35),
              MyTextfield(
                labelText: "email",
                obscureText: false,
                controller: emailController,
                normalBorderColor: Colors.black,
                focusedBorderColor: Colors.amber,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 25),
              MyTextfield(
                labelText: "password",
                obscureText: true,
                controller: passwordController,
                normalBorderColor: Colors.black,
                focusedBorderColor: Colors.amber,
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 5),
              MyTextButton(
                text: "Forgot Password?",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPassword(),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              MyButtons(
                text: "Sign In",
                onTap: () => signIn(context),
                color: Colors.amberAccent.shade400,
              ),
              SizedBox(height: 10),
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
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
