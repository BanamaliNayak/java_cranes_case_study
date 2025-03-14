// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:livein/providers/user_provider.dart';
import 'package:provider/provider.dart';
// Make sure to import your UserProvider

class BrokerMyaccount extends StatefulWidget {
  const BrokerMyaccount({super.key});

  @override
  _BrokerMyAccountState createState() => _BrokerMyAccountState();
}

class _BrokerMyAccountState extends State<BrokerMyaccount> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isEditing = false;
  String? profileImageUrl;
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('LiveIn')
          .doc('users')
          .collection('users')
          .doc(user!.uid)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data()!;
        firstNameController.text = data['first_name'] ?? '';
        lastNameController.text = data['last_name'] ?? '';
        genderController.text = data['gender'] ?? '';
        phoneNumberController.text = data['phone_no'] ?? '';
        emailController.text = data['email'] ?? '';
        profileImageUrl = data['profileImageUrl'];
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    setState(() {});
  }

  Future<void> _saveChanges() async {
    try {
      await _firestore
          .collection('LiveIn')
          .doc('users')
          .collection('users')
          .doc(user!.uid)
          .update({
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'gender': genderController.text,
        'phone_no': phoneNumberController.text,
        'email': emailController.text,
        'profileImageUrl': profileImageUrl,
      });

      // Update the UserProvider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setFirstName(firstNameController.text);
      userProvider.setLastName(lastNameController.text);
      userProvider.setEmail(emailController.text);

      setState(() {
        isEditing = false;
      });
    } catch (e) {
      print("Error updating user data: $e");
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Choose Image"),
                onTap: () async {
                  final XFile? pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      profileImageUrl = pickedFile.path;
                    });
                  }
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Picture"),
                onTap: () async {
                  final XFile? pickedFile =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      profileImageUrl = pickedFile.path;
                    });
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          "My Account",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 10),
            Center(
              child: GestureDetector(
                onTap: isEditing ? _showBottomSheet : null,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  backgroundImage: profileImageUrl != null
                      ? File(profileImageUrl!).existsSync()
                          ? FileImage(File(profileImageUrl!))
                          : NetworkImage(profileImageUrl!)
                      : const NetworkImage('https://i.pravatar.cc/600'),
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildInfoContainer(
                "First Name", firstNameController, Icons.person),
            const SizedBox(height: 16),
            _buildInfoContainer(
                "Last Name", lastNameController, Icons.person_outline),
            const SizedBox(height: 16),
            _buildInfoContainer(
                "Gender", genderController, Icons.accessibility),
            const SizedBox(height: 16),
            _buildInfoContainer("Phone No", phoneNumberController, Icons.phone),
            const SizedBox(height: 16),
            Container(
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.email,
                      color: Color.fromRGBO(143, 148, 251, 1)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Email",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        Text(emailController.text)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (isEditing) _saveChanges();
                setState(() {
                  isEditing = !isEditing;
                });
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Text(
                isEditing ? "Save Changes" : "Edit Profile",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoContainer(
      String label, TextEditingController controller, IconData icon) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(icon, color: const Color.fromRGBO(143, 148, 251, 1)),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$label:",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                isEditing
                    ? SizedBox(
                        width: 200,
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter $label",
                            contentPadding: const EdgeInsets.only(top: 2),
                          ),
                        ),
                      )
                    : Text(controller.text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
