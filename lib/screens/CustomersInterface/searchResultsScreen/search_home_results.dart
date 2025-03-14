import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:livein/providers/location_provider.dart';
import 'package:livein/screens/CustomersInterface/propertiesScreen/properties_card.dart';
import 'package:provider/provider.dart';

class SearchHomeResultsPage extends StatelessWidget {
  final String searchQuery;

  const SearchHomeResultsPage({
    super.key,
    required this.searchQuery,
  });

  // Function to fetch listings from Firestore, optionally filtered by city
  Future<List<Map<String, dynamic>>> fetchListingsFromFirestore(
      String city) async {
    Query query = FirebaseFirestore.instance.collection('listings');

    if (city != "Select Location") {
      print('Fetching listings for city: $city');
      query =
          query.where('city', isEqualTo: city); // Filter by city if selected
    } else {
      print('Fetching listings for all cities');
    }

    final snapshot = await query.get();

    if (snapshot.docs.isEmpty) {
      print('No listings found.');
    }

    return snapshot.docs.map((doc) {
      final data =
          doc.data() as Map<String, dynamic>; // Cast to Map<String, dynamic>

      final numberOfBaths = data['bathrooms'] is num
          ? (data['bathrooms'] as num).toString()
          : "0";
      final numberOfRoomatesRequired = data['roommates'] is num
          ? (data['roommates'] as num).toString()
          : "0";
      final carpetArea =
          data['carpetArea'] is num ? (data['carpetArea'] as num).toInt() : 0;
      final host =
          data['host'] ?? ''; // Get host value, or set default to empty string

      final imageUrls = data.containsKey('imageUrls')
          ? List<String>.from(data['imageUrls'] ?? [])
          : [];

      return {
        "title": data['title'] ?? '',
        "host": host,
        "price": data['price'] ?? '', // Ensure price is a string
        "apartmentType": data['apartmentType'] ?? '',
        "numberOfBaths": numberOfBaths, // Ensure numberOfBaths is a string
        "accommodationType": data['accommodation'] ?? '',
        "numberOfRoomatesRequired":
            numberOfRoomatesRequired, // Ensure this is a string
        "label": data['label'] ?? '',
        "genderPreference": data['genderPreference'] ?? '',
        "area": data['area'] ?? '',
        "city": data['city'] ?? '',
        "pincode": data['pincode'] ?? '',
        "imageUrls": imageUrls, // Ensure it never returns null
        "description": data['description'] ?? '',
        "carpetArea": carpetArea, // Convert carpetArea to an int
        "hostId": data['userId'] ?? '',
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCity = context.watch<LocationProvider>().currentCity;

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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchListingsFromFirestore(
            selectedCity), // Fetch data based on city
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Show a loading indicator while waiting
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                  'Error: ${snapshot.error}'), // Display error message if fetching fails
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No results found for "$searchQuery".',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          // Filter listings by search query
          final filteredListings = snapshot.data!.where((listing) {
            return listing["title"]
                .toString()
                .toLowerCase()
                .contains(searchQuery.toLowerCase());
          }).toList();

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, // Number of columns
              childAspectRatio:
                  0.85, // Adjust the height/width ratio of the cards
              crossAxisSpacing: 8.0, // Space between columns
              mainAxisSpacing: 8.0, // Space between rows
            ),
            itemCount: filteredListings.length,
            itemBuilder: (context, index) {
              final listing = filteredListings[index];
              final imageUrls = List<String>.from(listing["images"] ?? []);
              const fallbackImage =
                  'https://via.placeholder.com/150'; // Placeholder image URL

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: PropertyCard(
                  title: listing["title"]?.toString() ?? "",
                  price: listing["price"] is num
                      ? listing["price"].toString()
                      : "0", // Convert to String
                  apartmentType: listing["apartmentType"]?.toString() ?? "",
                  numberOfBaths: listing["numberOfBaths"] is num
                      ? listing["numberOfBaths"].toString()
                      : "0", // Convert to String
                  accommodationType:
                      listing["accommodationType"]?.toString() ?? "",
                  numberOfRoomatesRequired:
                      listing["numberOfRoomatesRequired"] is num
                          ? listing["numberOfRoomatesRequired"].toString()
                          : "0", // Convert to String
                  label: listing["label"]?.toString() ?? "Available",
                  genderPreference:
                      listing["genderPreference"]?.toString() ?? "",
                  area: listing["area"]?.toString() ?? "",
                  city: listing["city"]?.toString() ?? "",
                  pincode: listing["pincode"]?.toString() ?? "",
                  imageUrls: List<String>.from(listing["images"] ?? []), 
                  description: listing["description"]?.toString() ?? "",
                  host: listing["host"]?.toString() ?? "", // Add host value
                  carpetArea:
                      listing["carpetArea"] ?? 0, // Add carpetArea value
                  hostId: listing["userId"] ?? "",
                ),
              );
            },
          );
        },
      ),
    );
  }
}
