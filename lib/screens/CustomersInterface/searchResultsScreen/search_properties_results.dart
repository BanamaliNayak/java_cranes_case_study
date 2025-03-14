// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:livein/screens/CustomersInterface/profileScreen/listingsCards/listingCard.dart';

class SearchPropertiesResultsPage extends StatelessWidget {
  final String searchQuery;

  const SearchPropertiesResultsPage({
    super.key,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    // Dummy data for demonstration
    final List<Map<String, dynamic>> Propertylistings = [
      {
        "title": "Room in  Center",
        "host": "John Doe",
        "price": "\$500/month",
        "apartmentType": "Studio",
        "numberOfBaths": "1",
        "accommodationType": "Single",
        "numberOfRoomatesRequired": "0",
        "label": "Available",
        "genderPreference": "Any",
        "area": "Downtown",
        "city": "New York",
        "pincode": 10001,
        "imageUrls": [
          "https://via.placeholder.com/150",
          "https://via.placeholder.com/150"
        ],
        "description": "A cozy room perfect for singles."
      },
      {
        "title": "Luxury Condo",
        "host": "Jane Smith",
        "price": "\$1200/month",
        "apartmentType": "Condo",
        "numberOfBaths": "2",
        "accommodationType": "Family",
        "numberOfRoomatesRequired": "0",
        "label": "Luxury",
        "genderPreference": "Any",
        "area": "Uptown",
        "city": "New York",
        "pincode": 10002,
        "imageUrls": [
          "https://via.placeholder.com/150",
          "https://via.placeholder.com/150"
        ],
        "description": "A luxurious condo with all amenities."
      },
      // Add more listings as needed
    ];

    // Filter listings by search query
    final filteredListings = Propertylistings.where((listing) {
      return listing["title"]
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();

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
        title: Text(
          'Results for "$searchQuery"',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: filteredListings.isEmpty
          ? Center(
              child: Text(
                'No results found for "$searchQuery".',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                childAspectRatio:
                    0.85, // Adjust the height/width ratio of the cards
                crossAxisSpacing: 8.0, // Space between columns
                mainAxisSpacing: 8.0, // Space between rows
              ),
              itemCount: filteredListings.length,
              itemBuilder: (context, index) {
                final Propertylisting = filteredListings[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Listingcard(
                    title: Propertylisting["title"],
                    host: Propertylisting["host"],
                    price: Propertylisting["price"],
                    apartmentType: Propertylisting["apartmentType"],
                    numberOfBaths: Propertylisting["numberOfBaths"],
                    accommodationType: Propertylisting["accommodationType"],
                    numberOfRoomatesRequired:
                        Propertylisting["numberOfRoomatesRequired"],
                    label: Propertylisting["label"],
                    genderPreference: Propertylisting["genderPreference"],
                    area: Propertylisting["area"],
                    city: Propertylisting["city"],
                    pincode: Propertylisting["pincode"],
                    imageUrls: Propertylisting["imageUrls"],
                    description: Propertylisting["description"],
                    carpetArea: Propertylisting["carpetArea"],
                  ),
                );
              },
            ),
    );
  }
}
