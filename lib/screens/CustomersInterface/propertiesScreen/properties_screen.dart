import 'package:flutter/material.dart';
import 'package:livein/screens/CustomersInterface/homeScreen/appBar/slivers_app_bar.dart';
import 'package:livein/screens/CustomersInterface/propertiesScreen/properties_card.dart';
import 'package:livein/screens/CustomersInterface/productScreen/product_screen.dart';
import 'package:livein/screens/CustomersInterface/searchResultsScreen/search_properties_results.dart';


class PropertiesScreen extends StatelessWidget {
  const PropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onSearchSubmitted: (query) {
          if (query.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchPropertiesResultsPage(
                  searchQuery: query,
          
                ),
              ),
            );
          }
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductScreen(
                      title: 'Haunt Beetlejuice house',
                      host: 'Delia Deetz',
                      price: '1200',
                      apartmentType: 'Victorian',
                      numberOfBaths: '2',
                      accommodationType: 'Private',
                      numberOfRoomatesRequired: '1',
                      genderPreference: 'No Preference',
                      area: 'Connecticut',
                      city: 'Connecticut',
                      pincode: "06103",
                      imageUrls: [
                        'https://picsum.photos/720',
                        'https://picsum.photos/721',
                        'https://picsum.photos/722',
                      ],
                      description:
                          "A creepy yet charming house perfect for your stay.", hostId: '',
                    ),
                  ),
                );
              },
              child: const PropertyCard(
                imageUrls: [
                  'https://picsum.photos/720',
                  'https://picsum.photos/721',
                  'https://picsum.photos/722',
                ],
                title: 'Haunt Beetlejuice house',
                host: 'Delia Deetz',
                label: 'For Rent',
                price: '120000',
                apartmentType: 'Victorian',
                numberOfBaths: '2',
                accommodationType: 'Private',
                numberOfRoomatesRequired: '1',
                genderPreference: 'No Preference',
                area: 'Connecticut',
                city: 'Connecticut',
                pincode: "06103",
                description:
                    "A creepy yet charming house perfect for your stay.", carpetArea: 0, hostId: '',
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductScreen(
                      title: 'Charming Cottage',
                      host: 'John Smith',
                      price: '1500',
                      apartmentType: 'Cottage',
                      numberOfBaths: '1',
                      accommodationType: 'Shared',
                      numberOfRoomatesRequired: '2',
                      genderPreference: 'Female',
                      area: 'Oregon',
                      city: 'Oregon',
                      pincode: "97401",
                      imageUrls: [
                        'https://picsum.photos/723',
                        'https://picsum.photos/724',
                        'https://picsum.photos/725',
                      ],
                      description:
                          "A cozy cottage ideal for a peaceful retreat.", hostId: '',
                    ),
                  ),
                );
              },
              child: const PropertyCard(
                imageUrls: [
                  'https://picsum.photos/723',
                  'https://picsum.photos/724',
                  'https://picsum.photos/725',
                ],
                title: 'Charming Cottage',
                host: 'John Smith',
                label: 'For Rent',
                price: '1500',
                apartmentType: 'Cottage',
                numberOfBaths: '1',
                accommodationType: 'Shared',
                numberOfRoomatesRequired: '2',
                genderPreference: 'Female',
                area: 'Oregon',
                city: 'Oregon',
                pincode: "97401",
                description: "A cozy cottage ideal for a peaceful retreat.", carpetArea: 0, hostId: '',
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductScreen(
                      title: 'Modern Apartment',
                      host: 'Jane Doe',
                      price: '2000',
                      apartmentType: 'Apartment',
                      numberOfBaths: '1',
                      accommodationType: 'Private',
                      numberOfRoomatesRequired: '0',
                      genderPreference: 'No Preference',
                      area: 'California',
                      city: 'California',
                      pincode: "90001",
                      imageUrls: [
                        'https://picsum.photos/726',
                        'https://picsum.photos/1007',
                        'https://picsum.photos/1008',
                      ],
                      description:
                          "A stylish apartment with contemporary design.", hostId: '',
                    ),
                  ),
                );
              },
              child: const PropertyCard(
                imageUrls: [
                  'https://picsum.photos/726',
                  'https://picsum.photos/1007',
                  'https://picsum.photos/1008',
                ],
                title: 'Modern Apartment',
                host: 'Jane Doe',
                label: 'For Rent',
                price: '2000',
                apartmentType: 'Apartment',
                numberOfBaths: '1',
                accommodationType: 'Private',
                numberOfRoomatesRequired: '0',
                genderPreference: 'No Preference',
                area: 'California',
                city: 'California',
                pincode: "90001",
                description: "A stylish apartment with contemporary design.", carpetArea: 0, hostId: '',
              ),
            ),
            // Add more PropertyCard widgets as needed
          ],
        ),
      ),
    );
  }
}
