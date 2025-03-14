// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:livein/screens/CustomersInterface/productScreen/product_screen.dart';

class PropertyCard extends StatefulWidget {
  final String title;
  final String host;
  final String price;
  final String apartmentType;
  final String numberOfBaths;
  final String accommodationType;
  final String numberOfRoomatesRequired;
  final String label;
  final String genderPreference;
  final String area;
  final String city;
  final String pincode;
  final List<String>? imageUrls;
  final String description;
  final int carpetArea;
  final String hostId;

  const PropertyCard({
    super.key,
    required this.title,
    required this.host,
    required this.label,
    required this.price,
    required this.apartmentType,
    required this.numberOfBaths,
    required this.accommodationType,
    required this.numberOfRoomatesRequired,
    required this.genderPreference,
    required this.area,
    required this.city,
    required this.pincode,
    this.imageUrls,
    this.description = "A beautiful property with all modern amenities.",
    required this.carpetArea, required this.hostId,
  });

  @override
  _PropertyCardState createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final secondaryColor = Theme.of(context)
        .colorScheme
        .secondary; // Assuming secondary color is defined in the theme

    return GestureDetector(
      onTap: () {
        // Navigate to the ProductScreen and pass the property info
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductScreen(
              title: widget.title,
              host: widget.host,
              price: widget.price,
              apartmentType: widget.apartmentType,
              numberOfBaths: widget.numberOfBaths,
              accommodationType: widget.accommodationType,
              numberOfRoomatesRequired: widget.numberOfRoomatesRequired,
              genderPreference: widget.genderPreference,
              area: widget.area,
              city: widget.city,
              pincode: widget.pincode,
              imageUrls: widget.imageUrls,
              description: widget.description,
              hostId: widget.hostId,
            ),
          ),
        );
      },
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Image container with fallback to secondary color
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .secondary, // Colors.black.withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1.0, // Makes the image square
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.imageUrls?.length ?? 1,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.network(
                          widget.imageUrls?[index] ?? '',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback in case of an error
                            return Container(
                              color: secondaryColor, // Set to secondary color
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.error,
                                color: Colors.white,
                                size: 40,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  // Other elements (label, share button, indicators, etc.)
                  // Live label
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Apartment',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // Share button
                  Positioned(
                    top: 8,
                    right: 16,
                    child: IconButton(
                      icon:
                          const Icon(CupertinoIcons.share, color: Colors.white),
                      onPressed: () {
                        // Handle share button
                      },
                    ),
                  ),
                  // Dot indicators
                  Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          List.generate(widget.imageUrls?.length ?? 0, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2.0),
                          width: _currentPage == index ? 10.0 : 6.0,
                          height: _currentPage == index ? 10.0 : 6.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Other widget content (details, location, etc.)
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: Theme.of(context).textTheme.headlineMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(
                            text: '\$',
                            style: TextStyle(
                              color: Color.fromRGBO(143, 148, 251, 1),
                            ),
                          ),
                          TextSpan(
                            text: widget.price,
                            style: const TextStyle(color: Colors.black),
                          ),
                          const TextSpan(
                            text: ' /month',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Hosted by ${widget.host}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color.fromRGBO(143, 148, 251, .6),
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.area}, ${widget.city}',
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
