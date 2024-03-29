import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkingo/components/textfield.dart';

class BookParkingPage extends StatefulWidget {
  final String email;

  const BookParkingPage({Key? key, required this.email}) : super(key: key);
  // final ParkingSpot parkingSpot;

  // const BookParkingPage({required this.parkingSpot});

  @override
  _BookParkingPageState createState() => _BookParkingPageState();
}

class _BookParkingPageState extends State<BookParkingPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  String? _selectedVehicleType;

  Map<String, dynamic>? parkingFees;

  @override
  void initState() {
    super.initState();
    _fetchParkingFees();
  }

  Future<void> _fetchParkingFees() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('lands_accepted')
          .doc(widget.email)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        final parkingFeesMap = data?['parkingFees'] as Map<String, dynamic>?;
        setState(() {
          parkingFees = parkingFeesMap;
        });
      }
    } catch (e) {
      print('Error fetching parking fees: $e');
    }
  }

  double _calculateParkingPrice() {
    if (_startTime == null ||
        _endTime == null ||
        _selectedVehicleType == null ||
        parkingFees == null) {
      return 0.0;
    }

    double? fee = parkingFees![_selectedVehicleType!];
    if (fee == null) {
      return 0.0; // Return 0 if no fee is found for the selected vehicle type
    }

    int durationInHours = _endTime!.hour - _startTime!.hour;
    return fee * durationInHours;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
        if (_endTime != null && _startTime!.hour >= _endTime!.hour) {
          _endTime = null;
        }
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? (_startTime ?? TimeOfDay.now()),
    );
    if (picked != null && picked.hour >= (_startTime?.hour ?? 0) + 1) {
      setState(() {
        _endTime = picked;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('End time should be at least 1 hour ahead of start time'),
      ));
    }
  }

  Future<void> _saveBookingData() async {
    try {
      // Get the current user's email
      String? userEmail = FirebaseAuth.instance.currentUser?.email;

      if (userEmail != null) {
        // Create a reference to the "bookings" subcollection in the user's document
        // Create a new document in the "bookings" subcollection
        await _firestore
            .collection('users')
            .doc(widget.email)
            .collection('bookings_received')
            .doc(userEmail)
            .set({
          'name': _nameController.text,
          'contactNumber': _contactNumberController.text,
          'vehicleType': _selectedVehicleType,
          'startTime': _startTime?.hour,
          'endTime': _endTime?.hour,
        });

        // Reduce the available land area by 1
        await _firestore.collection('lands_accepted').doc(widget.email).update({
          'landArea': FieldValue.increment(-1),
        });

        // Save booking details to booking_done collection
        await _firestore
            .collection('users')
            .doc(userEmail)
            .collection('booking_done')
            .add({
          'vehicleType': _selectedVehicleType,
          'price': _calculateParkingPrice(),
          'contactNumber': _contactNumberController.text,
          'landownerEmail': widget.email,
        });

        // Show a success message or perform any other actions you need
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking successful'),
          ),
        );

        // After the booking is successful, pop the current page to go back to the map page
        Navigator.pop(context);
      } else {
        // Handle the case when the user's email is null
        print('User email is null');
      }
    } catch (e) {
      // Handle any errors that occurred during the booking process
      print('Error saving booking data: $e');
    }
  }

  Widget _buildClearButton(Function()? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text('Clear'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Parking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You are booking: ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              MyTextfield(
                controller: _nameController,
                focusedBorderColor: Colors.amber,
                keyboardType: TextInputType.text,
                labelText: "Name",
                normalBorderColor: Colors.black,
                obscureText: false,
              ),
              SizedBox(height: 20),
              MyTextfield(
                controller: _contactNumberController,
                keyboardType: TextInputType.phone,
                focusedBorderColor: Colors.amber,
                labelText: "Contact Number",
                normalBorderColor: Colors.black,
                obscureText: false,
              ),
              SizedBox(height: 20),
              Text("Select vehicle type"),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Car',
                        groupValue: _selectedVehicleType,
                        onChanged: (value) {
                          setState(() {
                            _selectedVehicleType = value;
                          });
                        },
                      ),
                      Text('Car'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Bike',
                        groupValue: _selectedVehicleType,
                        onChanged: (value) {
                          setState(() {
                            _selectedVehicleType = value;
                          });
                        },
                      ),
                      Text('Bike'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Auto Rikshaw',
                        groupValue: _selectedVehicleType,
                        onChanged: (value) {
                          setState(() {
                            _selectedVehicleType = value;
                          });
                        },
                      ),
                      Text('Auto Rikshaw'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Truck',
                        groupValue: _selectedVehicleType,
                        onChanged: (value) {
                          setState(() {
                            _selectedVehicleType = value;
                          });
                        },
                      ),
                      Text('Truck'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _selectStartTime(context),
                      child: Text('Select Start Time'),
                    ),
                    SizedBox(width: 20),
                    _buildClearButton(() {
                      setState(() {
                        _startTime = null;
                      });
                    }),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _startTime != null
                          ? () => _selectEndTime(context)
                          : null,
                      child: Text('Select End Time'),
                    ),
                    SizedBox(width: 20),
                    _buildClearButton(() {
                      setState(() {
                        _endTime = null;
                      });
                    }),
                  ],
                ),
              ),
              SizedBox(height: 20),
              if (_startTime != null)
                Center(
                    child: Text('Start Time: ${_startTime!.format(context)}')),
              if (_endTime != null)
                Center(child: Text('End Time: ${_endTime!.format(context)}')),
              SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    double parkingPrice = _calculateParkingPrice();
                    if (parkingPrice > 0) {
                      _saveBookingData(); // Call the method to save the booking data
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select all required fields'),
                        ),
                      );
                    }
                  },
                  child: Text('Book Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
