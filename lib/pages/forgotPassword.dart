import 'package:flutter/material.dart';
import 'package:parkingo/components/buttons.dart';
import 'package:parkingo/components/textfield.dart';

class ForgotPassword extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Forgot Password",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 35),
            MyTextfield(
              controller: emailController,
              labelText: 'email',
              obscureText: false,
              normalBorderColor: Colors.black,
              focusedBorderColor: Colors.amber,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 15),
            MyTextfield(
              labelText: "New Password",
              obscureText: true,
              controller: passwordController,
              normalBorderColor: Colors.black,
              focusedBorderColor: Colors.amber,
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 15),
            MyTextfield(
              labelText: "Confirm Password",
              obscureText: true,
              controller: passwordController,
              normalBorderColor: Colors.black,
              focusedBorderColor: Colors.amber,
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            MyButtons(
                text: "Update Password", onTap: () {}, color: Colors.amber)
          ],
        ),
      ),
    );
  }
}
