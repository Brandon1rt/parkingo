import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkingo/components/buttons.dart';
import 'package:parkingo/components/textButton.dart';
import 'package:parkingo/components/textfield.dart';
import 'package:parkingo/pages/login-signup.dart';

class CreateAccount extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  CreateAccount({super.key});

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
                hintText: "email",
                obscureText: false,
                controller: emailController,
                normalBorderColor: Colors.black,
                focusedBorderColor: Colors.amber,
              ),

              SizedBox(height: 15),

              //password text field
              MyTextfield(
                hintText: "password",
                obscureText: true,
                controller: passwordController,
                normalBorderColor: Colors.black,
                focusedBorderColor: Colors.amber,
              ),
              SizedBox(height: 15),
              MyTextfield(
                hintText: "confirm password",
                obscureText: true,
                controller: passwordController,
                normalBorderColor: Colors.black,
                focusedBorderColor: Colors.amber,
              ),

              SizedBox(
                height: 15,
              ),
              MyButtons(
                text: "Create Account",
                onTap: () {},
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
