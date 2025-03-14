import 'package:flutter/material.dart';

class LookingRoomatesCard extends StatelessWidget {
  const LookingRoomatesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Are you looking for roomates? Post an Ad now!',
              style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 16.0),
          const Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Color.fromRGBO(143, 148, 251, 1),
              ),
              SizedBox(width: 8.0),
              Text('Zero Ad cost'),
            ],
          ),
          const SizedBox(height: 8.0),
          const Row(
            children: [
              Icon(Icons.check_circle, color: Color.fromRGBO(143, 148, 251, 1)),
              SizedBox(width: 8.0),
              Text('Verified Profiles'),
            ],
          ),
          const SizedBox(height: 8.0),
          const Row(
            children: [
              Icon(Icons.check_circle, color: Color.fromRGBO(143, 148, 251, 1)),
              SizedBox(width: 8.0),
              Text('On demand assistance'),
            ],
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(143, 148, 251, 0.6),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Get Started'),
            ),
          ),
        ],
      ),
    );
  }
}
