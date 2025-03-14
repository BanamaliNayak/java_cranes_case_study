// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Listingpreview extends StatefulWidget {
  final String title;
  final String host;
  final String price;
  final String apartmentType;
  final String numberOfBaths;
  final String accommodationType;
  final String numberOfRoomatesRequired;
  final String genderPreference;
  final String area;
  final String city;
  final String pincode;
  final int carpetArea;
  final List<String>? imageUrls;
  final String description;

  const Listingpreview({
    super.key,
    required this.title,
    required this.host,
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
    required this.description,
    required this.carpetArea,
  });

  @override
  _ListingpreviewState createState() => _ListingpreviewState();
}

class _ListingpreviewState extends State<Listingpreview> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            expandedHeight: 300,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(CupertinoIcons.share),
                onPressed: () {
                  // Handle share action here
                },
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                "LISTING PREVIEW",
                style: TextStyle(color: Colors.white),
              ),
              background: Stack(
                children: [
                  // PageView for images with error handling
                  PageView.builder(
                    controller: _pageController,
                    itemCount: widget.imageUrls?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Image.network(
                        widget.imageUrls![index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color.fromRGBO(143, 148, 251, 1),
                            child: const Icon(
                              Icons.error,
                              color: Colors.white,
                              size: 40,
                            ),
                          );
                        },
                      );
                    },
                    onPageChanged: _onPageChanged,
                  ),
                  // Dots Indicator
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.imageUrls?.length ?? 0,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          width: 8.0,
                          height: 8.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? const Color.fromRGBO(143, 148, 251, 1)
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Product details section
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hosted by ${widget.host}',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      "Description",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.description,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      "Accommodation Details",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Number of Rooms: ${widget.apartmentType}",
                            style: TextStyle(color: Colors.grey.shade600)),
                        Text("Number of Baths: ${widget.numberOfBaths}",
                            style: TextStyle(color: Colors.grey.shade600)),
                        Text("Carpet Area: ${widget.carpetArea} Sqft",
                            style: TextStyle(color: Colors.grey.shade600)),
                        Text("Accommodation Type: ${widget.accommodationType}",
                            style: TextStyle(color: Colors.grey.shade600)),
                        Text(
                          "Number of Roommates Required: ${widget.numberOfRoomatesRequired}",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        Text("Gender Preference: ${widget.genderPreference}",
                            style: TextStyle(color: Colors.grey.shade600)),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        Text(
                          "Location Details",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text("Area: ${widget.area}",
                            style: TextStyle(color: Colors.grey.shade600)),
                        Text("City: ${widget.city}",
                            style: TextStyle(color: Colors.grey.shade600)),
                        Text("Pincode: ${widget.pincode}",
                            style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            '\$${widget.price}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color.fromRGBO(143, 148, 251, 1),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '/ month',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Handle contact/booking action here
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(143, 148, 251, 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      'Chat',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
