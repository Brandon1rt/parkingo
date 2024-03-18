import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingsReceived extends StatefulWidget {
  const BookingsReceived({Key? key});

  @override
  State<BookingsReceived> createState() => _BookingsReceivedState();
}

class _BookingsReceivedState extends State<BookingsReceived> {
  late User? _user;
  late CollectionReference<Map<String, dynamic>> _bookingsCollection;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _bookingsStream;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _bookingsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.email)
        .collection('bookings_received');

    // Start listening to booking changes
    _bookingsStream = _bookingsCollection.snapshots();
    _bookingsStream.listen((snapshot) {
      // Iterate through each booking
      for (var bookingDocument in snapshot.docs) {
        // Access booking data from document
        Map<String, dynamic> bookingData = bookingDocument.data();

        // Get endTime from booking data
        DateTime endTime = bookingData['endTime'].toDate();

        // Check if endTime is in the past
        if (DateTime.now().isAfter(endTime)) {
          // Delete the booking
          bookingDocument.reference.delete();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookings Details"),
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
      QueryDocumentSnapshot<Map<String, dynamic>> bookingDocument) {
    // Access booking data from document
    Map<String, dynamic> bookingData = bookingDocument.data();

    // Define text styles for title and subtitle
    TextStyle titleStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    TextStyle subtitleStyle = TextStyle(
      fontSize: 16,
      color: Colors.grey,
    );

    // Return the styled ListTile
    return ListTile(
      title: Text(
        'Booking ID: ${bookingDocument.id}',
        style: titleStyle,
      ),
      subtitle: Text(
        'Booking Details: ${bookingData.toString()}',
        style: subtitleStyle,
      ),
      // Example of customizing other properties
      leading: Icon(
        Icons.event_available,
        color: Colors.green,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.blue,
      ),
      onTap: () {
        // Handle onTap event
      },
      // Add more properties as needed
    );
  }
}
