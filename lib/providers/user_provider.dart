import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _profilePicture = ''; // New property for profile picture

  // Getters
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  String get profilePicture => _profilePicture; // Getter for profile picture

   void setUserData(String firstName, String lastName, String email) {
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    notifyListeners(); // Notify listeners to rebuild UI
  }

  // Setters with notifyListeners to update listeners when data changes
  void setFirstName(String value) {
    _firstName = value;
    notifyListeners();
  }

  void setLastName(String value) {
    _lastName = value;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setProfilePicture(String value) {
    _profilePicture = value;
    notifyListeners();
  }

  // Optionally, you can create a method to update multiple fields at once
  void updateUserData({
    required String firstName,
    required String lastName,
    required String email,
    required String profilePicture,
  }) {
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _profilePicture = profilePicture;
    notifyListeners();
  }
}
