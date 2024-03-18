import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingsDone extends StatefulWidget {
  const BookingsDone({Key? key});

  @override
  State<BookingsDone> createState() => _BookingsDoneState();
}

class _BookingsDoneState extends State<BookingsDone> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _bookingsStream;

  @override
  void initState() {
    super.initState();
    // Initialize the stream to listen for changes in the bookings_done collection
    _bookingsStream = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection('booking_done')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookings Done"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _bookingsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var bookingDocument = snapshot.data!.docs[index];
                return buildBookingCard(bookingDocument);
              },
            );
          }
          return Center(
            child: Text('No bookings found.'),
          );
        },
      ),
    );
  }

  Widget buildBookingCard(
      DocumentSnapshot<Map<String, dynamic>> bookingDocument) {
    Map<String, dynamic> bookingData = bookingDocument.data()!;
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vehicle Type: ${bookingData['vehicleType']}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Price: ${bookingData['price']}'),
            SizedBox(height: 8),
            Text('Land owner email: ${bookingData['landownerEmail']}'),
            SizedBox(height: 8),
            Text('Land owner Contact number: ${bookingData['contactNumber']}'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Delete the collection from Firebase
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.email)
                    .collection('booking_done')
                    .doc(bookingDocument.id)
                    .delete()
                    .then((_) {
                  // Collection deleted successfully
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Booking cancelled successfully'),
                    ),
                  );
                  // Update the UI by rebuilding the widget tree
                  setState(() {});
                }).catchError((error) {
                  // Error occurred while deleting collection
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to cancel booking: $error'),
                    ),
                  );
                });
              },
              child: Text('Cancel Booking'),
            ),
          ],
        ),
      ),
    );
  }
}
