import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkingo/pages/login-signup.dart';

class AdminPage extends StatefulWidget {
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference landsCollection =
      FirebaseFirestore.instance.collection('lands');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Admin"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_rounded),
            style:
                ButtonStyle(iconColor: MaterialStateProperty.all(Colors.red)),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: landsCollection.snapshots(),
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
                var landDocument = snapshot.data!.docs[index];
                return buildLandCard(landDocument);
              },
            );
          }
          return Center(
            child: Text('No lands found.'),
          );
        },
      ),
    );
  }

  Widget buildLandCard(QueryDocumentSnapshot landDocument) {
    Map<String, dynamic> landData = landDocument.data() as Map<String, dynamic>;

    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Land details for ${landDocument.id}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Area: ${landData['landArea']}'),
            Text('Location: ${landData['location']}'),
            Text('Owner: ${landData['landownerName']}'),
            Text('Parking Fees:'),
            if (landData['parkingFees'] != null) ...[
              // Check if parkingFees is not null
              ...(landData['parkingFees'] as Map<String, dynamic>).entries.map(
                  (entry) => Text('${entry.key}: ${entry.value.toString()}'))
            ],
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    acceptLand(landDocument.id);
                  },
                  child: Text('Accept'),
                ),
                ElevatedButton(
                  onPressed: () {
                    rejectLand(landDocument.id);
                  },
                  child: Text('Reject'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void acceptLand(String landDocumentId) async {
    try {
      // Retrieve the land document
      DocumentSnapshot landDoc =
          await landsCollection.doc(landDocumentId).get();

      if (landDoc.exists) {
        // Extract the land data
        Map<String, dynamic> landData = landDoc.data() as Map<String, dynamic>;

        // Save the land data into the 'lands_accepted' collection using land document ID as the document ID
        await FirebaseFirestore.instance
            .collection('lands_accepted')
            .doc(landDocumentId)
            .set(landData);

        // Delete the land from the original collection
        await landsCollection.doc(landDocumentId).delete();

        // Implement any additional logic if needed

        print('Accepted land: $landDocumentId');
        // Update UI
        setState(() {
          // You can update some UI state here if needed
        });
      } else {
        print('Land document does not exist');
      }
    } catch (e) {
      print('Error accepting land: $e');
    }
  }

  void rejectLand(String landDocumentId) async {
    try {
      // Delete the land from the original collection
      await landsCollection.doc(landDocumentId).delete();

      print('Rejected land: $landDocumentId');
      // Update UI
      setState(() {
        // You can update some UI state here if needed
      });
    } catch (e) {
      print('Error rejecting land: $e');
    }
  }
}
