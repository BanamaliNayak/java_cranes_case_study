// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:livein/screens/bothCustomerBroker/chatBoxScreen/chat_screen.dart';

class ProductScreen extends StatefulWidget {
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
  final List<String>? imageUrls;
  final String description;
  final String
      hostId; // this id id us bit getting saved as participents in that newly created chat

  const ProductScreen({
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
    this.description = "A beautiful property with all modern amenities.",
    required this.hostId, // this is the host user id the person which i should be able to chat with once i press chat button
  });

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
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

  final FirebaseAuth auth = FirebaseAuth.instance;

  // Get the current user ID
  String? getCurrentUserId() {
    final User? user = auth.currentUser; // Get the currently signed-in user
    return user?.uid; // Returns the user ID (UID) or null if not signed in
  }

  // Generate a unique chat ID using sorted user IDs
  String _getChatId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort();
    return ids.join('_');
  }

  // Create or fetch chat in Firestore
  Future<void> _createOrFetchChatFirestore(
      String chatId, String currentUserId, hostUserId) async {
    hostUserId = widget.hostId;
    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

    try {
      // Check if the chat document exists
      final snapshot = await chatRef.get();

      if (!snapshot.exists) {
        // Create a new chat
        await chatRef.set({
          'chatId': chatId,
          'participants': [
            currentUserId,
            widget.hostId
          ], // cant use the host id from the listing?
          'createdAt': FieldValue.serverTimestamp(),
          'lastMessage': null,
        });
      } else {
        // Ensure participants are correctly listed
        List<dynamic> participants = snapshot.data()?['participants'] ?? [];
        if (!participants.contains(currentUserId) ||
            !participants.contains(hostUserId)) {
          await chatRef.update({
            'participants': FieldValue.arrayUnion([currentUserId, hostUserId]),
          });
        }
      }
    } catch (e) {
      throw Exception("Error creating or fetching chat: $e");
    }
  }

  // Fetch the profile picture of the host user
  Future<String?> _fetchProfilePicture(String hostUserId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(hostUserId)
          .get();
      return userDoc.data()?['profilePicture'] as String?;
    } catch (e) {
      return null; // Return null if fetching fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            foregroundColor: Colors.white,
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
              title: Text(
                widget.title,
                style: const TextStyle(color: Colors.white),
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
                        Text(
                          '\$${widget.price}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color.fromRGBO(143, 148, 251, 1),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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
                onTap: () async {
                  print(widget.hostId);
                  final currentUserId = FirebaseAuth
                      .instance.currentUser?.uid; // Get the current user ID
                  if (currentUserId == null) {
                    // Prompt user to log in
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please log in to start a chat.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final hostUserId = widget.hostId; // Get the host's user ID
                  final chatId = _getChatId(currentUserId,
                      hostUserId); // Generate or fetch the chat ID

                  try {
                    // Initialize Firebase if needed
                    if (Firebase.apps.isEmpty) {
                      await Firebase.initializeApp();
                    }

                    // Create or fetch the chat
                    await _createOrFetchChatFirestore(
                        chatId, currentUserId, hostUserId);

                    // Fetch the profile picture of the contact (host)
                    final profilePicture =
                        await _fetchProfilePicture(hostUserId);

                    // Navigate to ChatScreen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          chatId: chatId, // Pass chatId
                          contactName: widget.host, // Pass contact name
                          profilePicture:
                              profilePicture, // Pass profile picture URL
                        ),
                      ),
                    );
                  } catch (e) {
                    // Show error feedback to the user
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to open chat: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
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
