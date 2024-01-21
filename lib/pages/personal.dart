import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkingo/components/buttons.dart';
import 'package:parkingo/components/textfield.dart';
import 'package:parkingo/pages/map_page.dart';

class PersonalInfo extends StatelessWidget {
  final TextEditingController firstnamecontroller = TextEditingController();
  final TextEditingController lastnamecontroller = TextEditingController();
  final TextEditingController contactnumbercontroller = TextEditingController();
  final TextEditingController placecontroller = TextEditingController();

  Future addUser(
      String fname, String lname, int contactnum, String place) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name': fname,
      'last name': lname,
      'contact number': contactnum,
      'place': place
    });
  }

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
                height: 18,
              ),
              MyTextfield(
                labelText: "First Name",
                obscureText: false,
                controller: firstnamecontroller,
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
                controller: lastnamecontroller,
                normalBorderColor: Colors.black12,
                focusedBorderColor: Colors.amber,
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 15,
              ),
              MyTextfield(
                labelText: "Place",
                obscureText: false,
                controller: placecontroller,
                normalBorderColor: Colors.black12,
                focusedBorderColor: Colors.amber,
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: contactnumbercontroller,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  labelText: "Contact number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
                keyboardType: TextInputType.number,
                maxLength: 10,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
              ),
              SizedBox(
                height: 15,
              ),
              MyButtons(
                  text: "Proceed",
                  onTap: () {
                    addUser(
                        firstnamecontroller.text.trim(),
                        lastnamecontroller.text.trim(),
                        int.parse(contactnumbercontroller.text.trim()),
                        placecontroller.text.trim());
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapPage(),
                        ));
                  },
                  color: Colors.amber)
            ],
          ),
        ),
      ),
    );
  }
}
