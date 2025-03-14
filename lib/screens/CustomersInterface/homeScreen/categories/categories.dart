import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const Category({
    super.key,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // Circular Container without shadow
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(24),
              color: Colors.white, // Background color
            ),
            child: const Icon(
              Icons.category,
              size: 40,
              color: Color.fromRGBO(143, 148, 251, 1),
            ), // Placeholder Icon
          ),
          const SizedBox(height: 8),
          // Category label
          Text(
            name,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
