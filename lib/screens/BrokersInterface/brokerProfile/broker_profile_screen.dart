// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:livein/authenticationScreens/login_screen.dart';
import 'package:livein/providers/user_provider.dart';
import 'package:livein/screens/BrokersInterface/brokerProfile/broker_myaccount.dart';
import 'package:livein/screens/CustomersInterface/profileScreen/notifications_page.dart';
import 'package:livein/screens/CustomersInterface/profileScreen/settings_page.dart';
import 'package:provider/provider.dart';

class BrokerProfileScreen extends StatefulWidget {
  const BrokerProfileScreen({super.key});

  @override
  _BrokerProfileScreenState createState() => _BrokerProfileScreenState();
}

class _BrokerProfileScreenState extends State<BrokerProfileScreen> {
  Future<Map<String, String>> _fetchUserData(String uid) async {
    try {
      // Get user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('LiveIn')
          .doc('users')
          .collection('users')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        // Return user data as a map
        return {
          'firstName': userDoc['first_name'] ?? 'No First Name',
          'lastName': userDoc['last_name'] ?? 'No Last Name',
          'email': userDoc['email'] ?? 'No Email',
        };
      }
      return {
        'firstName': 'No First Name',
        'lastName': 'No Last Name',
        'email': 'No Email',
      };
    } catch (e) {
      print('Error fetching user data: $e');
      return {
        'firstName': 'Error',
        'lastName': 'Error',
        'email': 'Error',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the UserProvider
    Provider.of<UserProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // If no user is logged in, navigate to login screen
      return const LoginScreen();
    }

    // Fetch user data from Firestore using the current user's UID
    return FutureBuilder<Map<String, String>>(
      future: _fetchUserData(user.uid),
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
                  backgroundImage:
                      const NetworkImage('https://i.pravatar.cc/600'),
                ),
                const SizedBox(height: 30),
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
                  userData['email'] ?? 'No email available',
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BrokerMyaccount()),
                    );
                  },
                ),
                _buildProfileOption(
                  icon: CupertinoIcons.bell,
                  title: 'Notifications',
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
                  onTap: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
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
              trailing: const Icon(
                CupertinoIcons.chevron_forward,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
