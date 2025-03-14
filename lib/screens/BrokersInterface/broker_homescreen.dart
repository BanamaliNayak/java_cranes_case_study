// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:livein/screens/BrokersInterface/broker_post_screen.dart';
import 'package:livein/screens/BrokersInterface/brokerProfile/broker_profile_screen.dart';

import 'package:livein/screens/BrokersInterface/navbar/broker_navbar.dart';
import 'package:livein/screens/bothCustomerBroker/chatBoxScreen/chatbox_screen.dart';

class BrokerHomescreen extends StatefulWidget {
  const BrokerHomescreen({super.key});

  @override
  _BrokerHomescreenState createState() => _BrokerHomescreenState();
}

class _BrokerHomescreenState extends State<BrokerHomescreen> {
  int _selectedPageBroker = 0;

  final List<Widget> _pages = [
    const BrokerHomePage(),
    ChatboxScreen(),
    const BrokerPostScreen(),
    const BrokerProfileScreen(),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _selectedPageBroker = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageBroker],
      bottomNavigationBar: BrokerNavbar(
        selectedPage: _selectedPageBroker,
        onPageChanged: _onPageChanged,
      ),
    );
  }
}

class BrokerHomePage extends StatelessWidget {
  const BrokerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
