import 'package:flutter/material.dart';
import 'package:parkingo/components/buttons.dart';
import 'package:parkingo/components/textfield.dart';

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
