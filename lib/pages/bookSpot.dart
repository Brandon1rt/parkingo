import 'package:flutter/material.dart';
import 'package:parkingo/components/textfield.dart';

class BookParkingPage extends StatefulWidget {
  // final ParkingSpot parkingSpot;

  // const BookParkingPage({required this.parkingSpot});

  @override
  _BookParkingPageState createState() => _BookParkingPageState();
}

class _BookParkingPageState extends State<BookParkingPage> {
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  String? _selectedVehicleType;

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
                'You are booking ' /*${widget.parkingSpot.placeName}*/,
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
                    // Handle booking here
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
