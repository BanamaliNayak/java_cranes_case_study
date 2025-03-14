// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:livein/screens/CustomersInterface/profileScreen/listingsCards/listingCard.dart';


class SavedListings extends StatefulWidget {
  const SavedListings({super.key});

  @override
  _SavedListingsState createState() => _SavedListingsState();
}

class _SavedListingsState extends State<SavedListings> {
  // Sample data for saved listings
  List<Map<String, dynamic>> savedListings = [
    {
      "title": "Cozy Studio Apartment",
      "host": "Alice",
      "price": "\$1200/month",
      "apartmentType": "Studio",
      "numberOfBaths": "1",
      "accommodationType": "Shared",
      "numberOfRoomatesRequired": "1",
      "label": "Available",
      "genderPreference": "Any",
      "area": "Downtown",
      "city": "New York",
      "pincode": 10001,
      "imageUrls": [
         'https://picsum.photos/625',
        'https://picsum.photos/613',
      ],
      "description": "A cozy studio apartment in downtown New York.",
    },
    {
      "title": "Spacious Two-Bedroom Condo",
      "host": "Bob",
      "price": "\$2000/month",
      "apartmentType": "Condo",
      "numberOfBaths": "2",
      "accommodationType": "Entire place",
      "numberOfRoomatesRequired": "None",
      "label": "Available",
      "genderPreference": "Any",
      "area": "Brooklyn",
      "city": "New York",
      "pincode": 11201,
      "imageUrls": [
        'https://picsum.photos/624',
        'https://picsum.photos/612',
      ],
      "description": "A spacious two-bedroom condo in Brooklyn.",
    },
    // Add more listings here
  ];

  // Function to unsave a listing
  void _unsaveListing(int index) {
    setState(() {
      savedListings.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate number of columns based on screen width
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 1200 ? 3 : 2;

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
          "Saved Listings",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: savedListings.isEmpty
          ? const Center(
              child: Text(
                "No saved listings.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: constraints.maxWidth > 1200 ? 0.95 : 0.85,
                  ),
                  itemCount: savedListings.length,
                  itemBuilder: (context, index) {
                    final listing = savedListings[index];
                    return Stack(
                      children: [
                        Listingcard(
                          title: listing["title"],
                          host: listing["host"],
                          price: listing["price"],
                          apartmentType: listing["apartmentType"],
                          numberOfBaths: listing["numberOfBaths"],
                          accommodationType: listing["accommodationType"],
                          numberOfRoomatesRequired:
                              listing["numberOfRoomatesRequired"],
                          label: listing["label"],
                          genderPreference: listing["genderPreference"],
                          area: listing["area"],
                          city: listing["city"],
                          pincode: listing["pincode"],
                          imageUrls: listing["imageUrls"],
                          description: listing["description"], carpetArea:listing["carpetArea"] ,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.bookmark_remove,
                                color: Theme.of(context).colorScheme.primary),
                            onPressed: () => _unsaveListing(index),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
    );
  }
}
