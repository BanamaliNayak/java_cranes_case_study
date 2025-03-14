import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:livein/screens/CustomersInterface/profileScreen/listingsCards/listingCard.dart';

class YourListings extends StatefulWidget {
  const YourListings({super.key});

  @override
  _YourListingsState createState() => _YourListingsState();
}

class _YourListingsState extends State<YourListings> {
  late final User? user;
  late final CollectionReference listingsCollection;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      listingsCollection = FirebaseFirestore.instance
          .collection('LiveIn')
          .doc('users')
          .collection('users')
          .doc(user!.uid)
          .collection('listings');
    } else {
      listingsCollection =
          FirebaseFirestore.instance.collection('empty'); // Dummy collection
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 1200 ? 3 : 1;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Your Listings"),
        ),
        body: const Center(
          child: Text(
            "You need to be logged in to view your listings.",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(100),
            bottomRight: Radius.circular(100),
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          "Your Listings",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: listingsCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No listings available.",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

          return LayoutBuilder(
            builder: (context, constraints) {
              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: constraints.maxWidth > 1200 ? 0.95 : 0.85,
                ),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final listing = docs[index].data() as Map<String, dynamic>;

                  return Stack(
                    children: [
                      Listingcard(
                        title: listing["title"]?.toString() ?? "",
                        price: listing["price"] is num
                            ? listing["price"].toString()
                            : "0", // Convert to String
                        apartmentType:
                            listing["apartmentType"]?.toString() ?? "",
                        numberOfBaths: listing["bathrooms"] is num
                            ? listing["bathrooms"].toString()
                            : "0", // Convert to String
                        accommodationType:
                            listing["accommodation"]?.toString() ?? "",
                        numberOfRoomatesRequired: listing["roommates"] is num
                            ? listing["roommates"].toString()
                            : "0", // Convert to String
                        label: listing["label"]?.toString() ?? "Available",
                        genderPreference:
                            listing["genderPreference"]?.toString() ?? "",
                        area: listing["area"]?.toString() ?? "",
                        city: listing["city"]?.toString() ?? "",
                        pincode: listing["pincode"]?.toString() ?? "",

                        imageUrls: List<String>.from(listing["images"] ?? []),
                        description: listing["description"]?.toString() ?? "",
                        carpetArea: listing["carpetArea"] is num
                            ? listing["carpetArea"]?.toInt()
                            : 0.0,
                        host: listing["host"]?.toString() ?? "",
                      ),
                      Positioned(
                        top: 27,
                        right: 32,
                        child: IconButton(
                          icon: Icon(Icons.delete,
                              color: Theme.of(context).colorScheme.primary),
                          onPressed: () async {
      try {
        // Delete from the user's listings collection
        await listingsCollection.doc(docs[index].id).delete();

        // Delete from the global listings collection
        await FirebaseFirestore.instance
            .collection('listings') // Global collection path
            .doc(docs[index].id)
            .delete();
      } catch (e) {
        print("Error deleting listing: $e");
      }
    },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
