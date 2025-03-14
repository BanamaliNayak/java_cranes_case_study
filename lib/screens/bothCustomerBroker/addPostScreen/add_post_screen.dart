// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livein/screens/CustomersInterface/homeScreen/home_screen.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final List<XFile?> _images = []; // To store images
  String? selectedBhk;
  String? selectedGenderPreference;
  String? locationPreference;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _accommodationController =
      TextEditingController();
  final TextEditingController _roommatesController = TextEditingController();
  final TextEditingController _carpetAreaController = TextEditingController();
  final TextEditingController _bathroomsController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null && _images.length < 5) {
      setState(() {
        _images.add(image);
      });
    }
    Navigator.of(context).pop(); // Close the bottom sheet
  }

  void _deleteImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Theme.of(context).scaffoldBackgroundColor,
      hintStyle: TextStyle(
        color: Colors.grey.shade500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide(
          color: Colors.grey.shade400,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2.0,
        ),
      ),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
    );
  }

  InputDecoration _buildInputDecorationLocation(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Theme.of(context).scaffoldBackgroundColor,
      hintStyle: const TextStyle(
        color: Color.fromARGB(255, 244, 244, 244),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 231, 231, 231),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2.0,
        ),
      ),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize:
          const Size.fromHeight(60.0), // Set the height of the AppBar
      child: AppBar(
        elevation: 10,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(75),
            bottomRight: Radius.circular(75),
          ),
        ),
        title: const Text(
          'Add Post',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildPhotoGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _images.length < 5 ? _images.length + 1 : 5,
      itemBuilder: (context, index) {
        if (index < _images.length) {
          return _buildImageItem(index);
        } else {
          return _buildAddImageButton();
        }
      },
    );
  }

  Widget _buildImageItem(int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: FileImage(File(_images[index]!.path)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () => _deleteImage(index),
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: () async {
        await showModalBottomSheet(
          context: context,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Upload Photo'),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Take Photo'),
                onTap: () => _pickImage(ImageSource.camera),
              ),
            ],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Details:'),
        const SizedBox(height: 10),
        TextFormField(
          controller: _titleController,
          decoration: _buildInputDecoration('Title of the Ad'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),
        const SizedBox(height: 14.0),
        TextFormField(
          controller: _priceController,
          keyboardType: TextInputType.number,
          decoration: _buildInputDecoration('Price per month'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a price';
            }
            return null;
          },
        ),
        const SizedBox(height: 14.0),
        TextFormField(
          controller: _descriptionController,
          decoration: _buildInputDecoration('Enter a brief description'),
          maxLines: 2, // Allow multiline input
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
        ),
        const SizedBox(height: 14.0),
        const Text('Apartment Type:'),
        const SizedBox(height: 10),
        _buildApartmentTypeField(),
        const SizedBox(height: 14.0),
        TextFormField(
          controller: _accommodationController,
          decoration: _buildInputDecoration(
              'Accommodation type (e.g., PG or Apartment)'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter accommodation type';
            }
            return null;
          },
        ),
        const SizedBox(height: 14.0),
        TextFormField(
          controller: _roommatesController,
          keyboardType: TextInputType.number,
          decoration: _buildInputDecoration('Number of roommates required'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter number of roommates';
            }
            return null;
          },
        ),
        const SizedBox(height: 14.0),
        TextFormField(
          controller: _carpetAreaController,
          keyboardType: TextInputType.number,
          decoration: _buildInputDecoration('Carpet area (sqft)'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the Carpet Area';
            }
            return null;
          },
        ),
        const SizedBox(height: 14.0),
        const Text('Gender Preference:'),
        const SizedBox(height: 10),
        _buildGenderPreferenceField(),
        const SizedBox(height: 14.0),
        _buildLocationFields(),
        const SizedBox(height: 20.0),
        _buildSubmitButton(),
        const SizedBox(height: 30.0),
      ],
    );
  }

  Widget _buildApartmentTypeField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: selectedBhk,
            onChanged: (value) => setState(() => selectedBhk = value),
            items: ['Single room', '1 HK', '1 BHK', '2 BHK', '3 BHK', '4 BHK']
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ))
                .toList(),
            decoration: _buildInputDecoration('Select Type'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: _bathroomsController,
            keyboardType: TextInputType.number,
            decoration: _buildInputDecoration('Number of bathrooms'),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderPreferenceField() {
    return DropdownButtonFormField<String>(
      value: selectedGenderPreference,
      onChanged: (value) => setState(() => selectedGenderPreference = value),
      items: ['Only Guys', 'Only Girls', 'No Preference']
          .map((preference) => DropdownMenuItem(
                value: preference,
                child: Text(preference),
              ))
          .toList(),
      decoration: _buildInputDecoration('Select Preference'),
    );
  }

  Widget _buildLocationFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Location:'),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: locationPreference,
          onChanged: (value) => setState(() => locationPreference = value),
          items: ['Banglore', 'Mumbai', 'Delhi', 'Chandighar']
              .map((preference) => DropdownMenuItem(
                    value: preference,
                    child: Text(preference),
                  ))
              .toList(),
          decoration: _buildInputDecoration('Select City'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _areaController,
          decoration: _buildInputDecorationLocation('Enter area'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an area';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _pincodeController,
          decoration: _buildInputDecorationLocation('Enter pincode'),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a pincode';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 48,
      width: double.infinity, // Makes the button full width
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          // Removed fixedSize to allow for full width
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Submit',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all required fields.')),
      );
      return;
    }

    // Show a loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Get user ID
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'NO_USER',
          message: 'User is not logged in.',
        );
      }

      print('User ID: ${user.uid}');

      // Upload images to Firebase Storage
      List<String> imageUrls = [];
      for (XFile? image in _images) {
        final File file = File(image!.path);
        final int fileSize = await file.length();
        print('Uploading image: ${image.path}, Size: $fileSize bytes');

        // Optional: Check if file size exceeds a certain limit (e.g., 5 MB)
        if (fileSize > 5 * 1024 * 1024) {
          // 5 MB limit
          print('File is too large, skipping upload.');
          continue; // Skip this image
        }

        final ref = FirebaseStorage.instance
            .ref()
            .child('posts')
            .child('${DateTime.now().toIso8601String()}_${image.name}');

        final uploadTask = await ref.putFile(file);
        final imageUrl = await uploadTask.ref.getDownloadURL();
        print('Image uploaded successfully: $imageUrl');
        imageUrls.add(imageUrl);
      }
      // Get the current logged-in user

// Fetch the user document from the 'users' collection within 'LiveIn' collection
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('LiveIn') // Access the 'LiveIn' collection
          .doc('users') // Access the 'users' document inside 'LiveIn'
          .collection(
              'users') // Access the subcollection 'users' inside the document
          .doc(user.uid) // Use the UID of the logged-in user
          .get();

// Get the first name from the user document
      String firstName = userDoc['first_name'];
      // Add post data to Firestore
      final post = {
        'host': firstName,
        'title': _titleController.text,
        'price': double.parse(_priceController.text),
        'description': _descriptionController.text,
        'apartmentType': selectedBhk,
        'bathrooms': int.parse(_bathroomsController.text),
        'accommodation': _accommodationController.text,
        'roommates': int.parse(_roommatesController.text),
        'carpetArea': double.parse(_carpetAreaController.text),
        'genderPreference': selectedGenderPreference,
        'city': locationPreference,
        'area': _areaController.text,
        'pincode': _pincodeController.text,
        'images': imageUrls,
        'userId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'likes': 0,
        'label': "Available"
      };

      // Add listing to the user-specific collection
      DocumentReference userListingDoc = await FirebaseFirestore.instance
          .collection('LiveIn')
          .doc('users')
          .collection('users')
          .doc(user.uid)
          .collection('listings')
          .add(post);

// Get the generated document ID for the listing
      String listingId = userListingDoc.id;

// Now, use the same listingId to add the listing to the global collection
      await FirebaseFirestore.instance
          .collection('listings')
          .doc(listingId) // Use the same ID for the global listing
          .set(post); // Use set to ensure the same document ID is used

      // Close the loading indicator
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post added successfully!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();

      if (e is FirebaseException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Firebase Error: ${e.message}')),
        );
        print('Firebase Exception caught: ${e.message}');
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
        print('General Exception caught: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 16.0, right: 16, top: 0, bottom: 0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                _buildPhotoGrid(),
                _buildFormFields(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
