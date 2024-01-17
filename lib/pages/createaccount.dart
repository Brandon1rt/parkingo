import 'package:flutter/material.dart';
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
                controller: passwordController,
                normalBorderColor: Colors.black,
                focusedBorderColor: Colors.amber,
                keyboardType: TextInputType.text,
              ),

              SizedBox(
                height: 15,
              ),
              MyButtons(
                text: "Create Account",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PersonalInfo()),
                  );
                },
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
class PersonalInfo extends StatelessWidget {
  TextEditingController name = TextEditingController();
  TextEditingController name1 = TextEditingController();
  TextEditingController name2 = TextEditingController();
  TextEditingController name4 = TextEditingController();
  TextEditingController name5 = TextEditingController();
  PersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Personal Information",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 12,
              ),
              MyTextfield(
                labelText: "First Name",
                obscureText: false,
                controller: name,
                normalBorderColor: Colors.black12,
                focusedBorderColor: Colors.amber,
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 15,
              ),
              MyTextfield(
                labelText: "Last Name",
                obscureText: false,
                controller: name,
                normalBorderColor: Colors.black12,
                focusedBorderColor: Colors.amber,
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 15,
              ),
              MyTextfield(
                labelText: "Contact number",
                obscureText: false,
                controller: name,
                normalBorderColor: Colors.black12,
                focusedBorderColor: Colors.amber,
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 15,
              ),
              MyTextfield(
                labelText: "Place",
                obscureText: false,
                controller: name,
                normalBorderColor: Colors.black12,
                focusedBorderColor: Colors.amber,
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 15,
              ),
              MyButtons(text: "Proceed", onTap: () {}, color: Colors.amber)
            ],
          ),
        ),
      ),
    );
  }
}
