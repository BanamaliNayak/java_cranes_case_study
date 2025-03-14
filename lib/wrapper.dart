import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:livein/authenticationScreens/login_screen.dart';
import 'package:livein/screens/BrokersInterface/broker_homescreen.dart';
import 'package:livein/screens/CustomersInterface/homeScreen/home_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  Future<String?> _getUserRole(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance
          .collection('LiveIn')
          .doc('users')
          .collection('users')
          .doc(uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        return userDoc.data()!['user_role'];
      }
    } catch (e) {
      print("Error fetching user role: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          User? user = snapshot.data;
          if (user != null) {
            return FutureBuilder<String?>(
              future: _getUserRole(user.uid),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                if (roleSnapshot.hasData) {
                  final String? userRole = roleSnapshot.data;
                  if (userRole == 'Property Dealer') {
                    return const BrokerHomescreen();
                  } else if (userRole == 'Looking for roommate') {
                    return const HomeScreen();
                  }
                }
                return const LoginScreen(); // Default if no role found
              },
            );
          }
        }

        return const LoginScreen(); // Default for non-logged-in users
      },
    );
  }
}
