import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino package
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavigation extends StatefulWidget {
  final int selectedPage;
  final Function(int) onPageChanged;

  const BottomNavigation({
    super.key,
    required this.selectedPage,
    required this.onPageChanged,
  });

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12, // Adjust the elevation to increase or decrease the shadow
      color: Colors.white, // Set background color of nav bar
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: GNav(
          selectedIndex: widget.selectedPage,
          onTabChange: widget.onPageChanged,
          color: Theme.of(context)
              .colorScheme
              .secondary, // Icon color when not active
          gap: 8,
          activeColor: Colors.white, // Active icon and text color
          backgroundColor: Colors.white, // Background color of the nav bar
          tabBackgroundColor:
              Theme.of(context).colorScheme.primary, // Active tab background
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Active text color
          ),
          tabs: const [
            GButton(
              icon: CupertinoIcons.home,
              text: 'Home',
            ),
            GButton(
              icon: CupertinoIcons.chat_bubble,
              text: 'Chats',
            ),
            GButton(
              icon: CupertinoIcons.building_2_fill,
              text: 'Properties',
            ),
            GButton(
              icon: CupertinoIcons.person,
              text: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
