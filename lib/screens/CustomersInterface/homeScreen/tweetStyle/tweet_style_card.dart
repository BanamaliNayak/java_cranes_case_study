// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:livein/screens/CustomersInterface/productScreen/product_screen.dart';

class TweetCard extends StatefulWidget {
  final String title;
  final String host;
  final String hostProfilePicUrl;
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
  final String hostId;

  const TweetCard({
    super.key,
    required this.title,
    required this.host,
    required this.hostProfilePicUrl,
    required this.price,
    required this.apartmentType,
    required this.numberOfBaths,
    required this.accommodationType,
    required this.numberOfRoomatesRequired,
    required this.label,
    required this.genderPreference,
    required this.area,
    required this.city,
    required this.pincode,
    this.imageUrls,
    required this.description, required this.hostId,
  });

  @override
  _TweetCardState createState() => _TweetCardState();
}

class _TweetCardState extends State<TweetCard> {
  bool isLiked = false;
  bool isSaved = false;

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  void toggleSave() {
    setState(() {
      isSaved = !isSaved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
              description: widget.description, hostId: 'userId',
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(
          padding: const EdgeInsets.all(18.0),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Host info row with profile picture and name
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    backgroundImage: NetworkImage(widget.hostProfilePicUrl),
                    radius: 20,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.host,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87),
                      ),
                      Text(
                        "@${widget.host.toLowerCase().replaceAll(' ', '_')}",
                        style:
                            const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Main tweet content
              Text(
                "Looking for roommates! 🏠 I've got a ${widget.apartmentType} in ${widget.area}, ${widget.city}, and I'm looking for ${widget.numberOfRoomatesRequired} ${widget.genderPreference} roommates. "
                "It's a cozy place with ${widget.numberOfBaths} baths and plenty of space to share. Ideal for someone looking for a relaxed and friendly living environment! "
                "DM if interested or know someone who might be.",
                style: const TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              // Display images with rounded corners if provided
              if (widget.imageUrls != null && widget.imageUrls!.isNotEmpty)
                widget.imageUrls!.length == 1
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Image.network(
                            widget.imageUrls![0],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Theme.of(context).colorScheme.secondary,
                                child: const Center(
                                  child: Icon(Icons.error, color: Colors.white),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Row(
                        children: widget.imageUrls!.take(2).map((url) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: AspectRatio(
                                  aspectRatio: 4 / 3,
                                  child: Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        child: const Center(
                                          child: Icon(Icons.error,
                                              color: Colors.white),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              const SizedBox(height: 16),
              // Action icons for Like, Save, Comment, and Share (iOS style)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: toggleLike,
                    child: Icon(
                      isLiked
                          ? CupertinoIcons.heart_fill
                          : CupertinoIcons.heart,
                      color: isLiked
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {}, // Add comment action if needed
                    child: Icon(
                      CupertinoIcons.chat_bubble,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: toggleSave,
                    child: Icon(
                      isSaved
                          ? CupertinoIcons.bookmark_fill
                          : CupertinoIcons.bookmark,
                      color: isSaved
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {}, // Add share action if needed
                    child: Icon(
                      CupertinoIcons.share,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
