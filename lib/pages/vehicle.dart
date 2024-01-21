import 'package:flutter/material.dart';

class AddVehicle extends StatefulWidget {
  const AddVehicle({Key? key}) : super(key: key);

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  final registrationNumbercontroller = TextEditingController();
  String? vehicleType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Add vehicle details",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Type ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ListTile(
                          title: Text("Two wheeler"),
                          leading: Radio(
                              value: 'Two wheeler',
                              groupValue: vehicleType,
                              onChanged: (val) {
                                setState(() {
                                  vehicleType = val.toString();
                                });
                              }),
                        ),
                        ListTile(
                          title: Text("Three wheeler"),
                          leading: Radio(
                              value: 'Three wheeler',
                              groupValue: vehicleType,
                              onChanged: (val) {
                                setState(() {
                                  vehicleType = val.toString();
                                });
                              }),
                        ),
                        ListTile(
                          title: Text("Four wheeler"),
                          leading: Radio(
                              value: 'Four wheeler',
                              groupValue: vehicleType,
                              onChanged: (val) {
                                setState(() {
                                  vehicleType = val.toString();
                                });
                              }),
                        ),
                        ListTile(
                          title: Text("others"),
                          leading: Radio(
                              value: 'others',
                              groupValue: vehicleType,
                              onChanged: (val) {
                                setState(() {
                                  vehicleType = val.toString();
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Vehicle Type:', style: TextStyle(fontSize: 16.0)),
                      Text(
                        vehicleType ?? 'Not selected',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 17),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: registrationNumbercontroller,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                      labelText: "Registration Number",
                      hintText: "KL-00-XX-0000",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
