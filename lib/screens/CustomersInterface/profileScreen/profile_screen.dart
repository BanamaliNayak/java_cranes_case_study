// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:livein/authenticationScreens/login_screen.dart';
import 'package:livein/providers/user_provider.dart';
import 'package:livein/screens/CustomersInterface/profileScreen/my_account.dart';
import 'package:livein/screens/CustomersInterface/profileScreen/notifications_page.dart';
import 'package:livein/screens/CustomersInterface/profileScreen/saved_listings.dart';
import 'package:livein/screens/CustomersInterface/profileScreen/settings_page.dart';
import 'package:livein/screens/CustomersInterface/profileScreen/your_listings.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Fetch user data
 Future<Map<String, String>> _fetchUserData(String uid) async {
  try {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('LiveIn')
        .doc('users')
        .collection('users')
        .doc(uid)
        .get();

    // Safely extract data from the document using null-aware operators
    if (userDoc.exists) {
      final data = userDoc.data() as Map<String, dynamic>?;

      return {
        'firstName': data?['first_name'] ?? 'No First Name',
        'lastName': data?['last_name'] ?? 'No Last Name',
        'email': data?['email'] ?? 'No Email',
        'profileImageUrl': data?['profileImageUrl'] ?? '',
      };
    } else {
      // If document does not exist, return default values
      return {
        'firstName': 'No First Name',
        'lastName': 'No Last Name',
        'email': 'No Email',
        'profileImageUrl': '',
      };
    }
  } catch (e) {
    // Handle any other unexpected errors
    print('Error fetching user data: $e');
    return {
      'firstName': 'Error',
      'lastName': 'Error',
      'email': 'Error',
      'profileImageUrl': '',
    };
  }
}



  @override
  Widget build(BuildContext context) {
    // Access the UserProvider
    final userProvider = Provider.of<UserProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // If no user is logged in, navigate to login screen
      return const LoginScreen();
    }

    // Fetch user data from Firestore using the current user's UID
    return FutureBuilder<Map<String, String>>(
      future: _fetchUserData(user.uid), // Fetch data using UID
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data found.'));
        }

        // Get data from snapshot
        var userData = snapshot.data!;

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
            title: const Center(
              child: Text(
                "Profile",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Profile picture without camera icon overlay
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  backgroundImage: userData['profileImageUrl'] != null &&
                          userData['profileImageUrl']!.isNotEmpty
                      ? NetworkImage(userData['profileImageUrl']!)
                      : null, // Use network image if available
                  child: userData['profileImageUrl'] == null ||
                          userData['profileImageUrl']!.isEmpty
                      ? Text(
                          '${userData['firstName']![0].toUpperCase()}${userData['lastName']![0].toUpperCase()}',
                          style: const TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),

                const SizedBox(height: 30),

                // Display dynamic first and last name
                Text(
                  '${userData['firstName']} ${userData['lastName']}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),

                // Reflect the email from Firestore
                Text(
                  userData['email'] ??
                      'No email available', // Display the email here
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(143, 148, 251, 1),
                  ),
                ),
                const SizedBox(height: 20),

                // Profile options
                _buildProfileOption(
                  icon: CupertinoIcons.person,
                  title: 'My Account',
                  context: context,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyAccount()),
                    ).then((_) {
                      setState(() {
                        // Refresh email after returning from MyAccount screen
                        userProvider.email;
                      });
                    });
                  },
                ),
                _buildProfileOption(
                  icon: CupertinoIcons.circle_grid_3x3,
                  title: 'Your Listings',
                  context: context,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const YourListings()),
                    );
                  },
                ),
                _buildProfileOption(
                  icon: CupertinoIcons.bookmark,
                  title: 'Saved Listings',
                  context: context,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SavedListings()),
                    );
                  },
                ),
                _buildProfileOption(
                  icon: CupertinoIcons.bell,
                  title: 'Notifications',
                  context: context,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationsPage()),
                    );
                  },
                ),
                _buildProfileOption(
                  icon: CupertinoIcons.settings,
                  title: 'Settings',
                  context: context,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()),
                    );
                  },
                ),
                _buildProfileOption(
                  icon: CupertinoIcons.square_arrow_right,
                  title: 'Log Out',
                  context: context,
                  onTap: () async {
                    try {
                      // Sign out from Firebase
                      await FirebaseAuth.instance.signOut();

                      // Navigate back to login screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    } catch (e) {
                      print('Error signing out: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error logging out: $e')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: onTap,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
              leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
              title: Text(title),
              trailing: const Icon(CupertinoIcons.chevron_forward,
                  color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
