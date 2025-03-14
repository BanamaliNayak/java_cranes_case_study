import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
const SettingsPage({ super.key });

  @override
  Widget build(BuildContext context){
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
          "Settings",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
  
    );
  }
}