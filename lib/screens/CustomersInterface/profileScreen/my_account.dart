import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:livein/providers/user_provider.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isEditing = false;
  String? profileImageUrl;
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      if (user == null) {
        throw Exception("User not logged in.");
      }

      final snapshot = await _firestore
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
        profileImageUrl = data['profileImageUrl'] ?? '';
      } else {
        throw Exception("User data does not exist in Firestore.");
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      _showErrorSnackBar("Failed to fetch user data.");
    } finally {
      setState(() {});
    }
  }

  Future<void> _saveChanges() async {
    try {
      if (user == null) {
        throw Exception("User not logged in.");
      }

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
        'profileImageUrl': profileImageUrl ?? '',
      });

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setFirstName(firstNameController.text);
      userProvider.setLastName(lastNameController.text);
      userProvider.setEmail(emailController.text);

      setState(() {
        isEditing = false;
      });

      _showSuccessSnackBar("Profile updated successfully!");
    } catch (e) {
      debugPrint("Error updating user data: $e");
      _showErrorSnackBar("Failed to save changes.");
    }
  }

  Future<void> _uploadProfileImage(File imageFile) async {
    try {
      if (user == null) {
        throw Exception("User not logged in.");
      }

      final storageRef =
          _storage.ref().child('profile_images').child('${user!.uid}.jpg');

      await storageRef.putFile(imageFile);
      final downloadUrl = await storageRef.getDownloadURL();

      setState(() {
        profileImageUrl = downloadUrl;
      });

      _showSuccessSnackBar("Profile image updated!");
    } catch (e) {
      debugPrint("Error uploading profile image: $e");
      _showErrorSnackBar("Failed to upload profile image.");
    }
  }

  Future<void> _deleteProfileImage() async {
    try {
      if (user == null) {
        throw Exception("User not logged in.");
      }

      final storageRef =
          _storage.ref().child('profile_images').child('${user!.uid}.jpg');

      await storageRef.delete();

      setState(() {
        profileImageUrl = null;
      });

      await _firestore
          .collection('LiveIn')
          .doc('users')
          .collection('users')
          .doc(user!.uid)
          .update({'profileImageUrl': ''});

      _showSuccessSnackBar("Profile image removed.");
    } catch (e) {
      debugPrint("Error deleting profile image: $e");
      _showErrorSnackBar("Failed to remove profile image.");
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
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
                    final File imageFile = File(pickedFile.path);
                    await _uploadProfileImage(imageFile);
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
                    final File imageFile = File(pickedFile.path);
                    await _uploadProfileImage(imageFile);
                  }
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever),
                title: const Text("Remove Profile Picture"),
                onTap: () async {
                  await _deleteProfileImage();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
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
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      backgroundImage:
                          profileImageUrl != null && profileImageUrl!.isNotEmpty
                              ? NetworkImage(profileImageUrl!)
                              : null,
                      child: profileImageUrl == null || profileImageUrl!.isEmpty
                          ? Text(
                              '${(firstNameController.text.isNotEmpty ? firstNameController.text[0] : '').toUpperCase()}${(lastNameController.text.isNotEmpty ? lastNameController.text[0] : '').toUpperCase()}',
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                    if (isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.edit,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                  ],
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
            _buildEmailContainer(),
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
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Enter here',
                          ),
                        ),
                      )
                    : Text(
                        controller.text.isNotEmpty
                            ? controller.text
                            : 'Not set',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailContainer() {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Icon(Icons.email, color: Color.fromRGBO(143, 148, 251, 1)),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Email:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  emailController.text,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
