import 'package:flutter/material.dart';

class LocationProvider with ChangeNotifier {
  String _currentCity = "Select Location"; // Default city

  String get currentCity => _currentCity;

  void setCurrentCity(String city) {
    _currentCity = city;
    notifyListeners(); // Notify listeners when the city is updated
  }
}
