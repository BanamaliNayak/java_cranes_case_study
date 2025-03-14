import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:livein/providers/location_provider.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(String) onSearchSubmitted;
  const CustomAppBar({
    super.key,
    required this.onSearchSubmitted,
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(125);
}

class _CustomAppBarState extends State<CustomAppBar> {
  void _showCitySelectionDialog() {
    if (Platform.isIOS) {
      _showCupertinoCitySelectionDialog();
    } else {
      _showMaterialCitySelectionDialog();
    }
  }

  void _showCupertinoCitySelectionDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Choose Your Location"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoDialogAction(
                onPressed: () {
                  context.read<LocationProvider>().setCurrentCity("Banglore");
                  Navigator.of(context).pop();
                },
                child: const Text("Banglore"),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  context.read<LocationProvider>().setCurrentCity("Mumbai");
                  Navigator.of(context).pop();
                },
                child: const Text("Mumbai"),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  context.read<LocationProvider>().setCurrentCity("Delhi");
                  Navigator.of(context).pop();
                },
                child: const Text("Delhi"),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  context.read<LocationProvider>().setCurrentCity("Chandigarh");
                  Navigator.of(context).pop();
                },
                child: const Text("Chandigarh"),
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

void _showMaterialCitySelectionDialog() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Choose Your Location"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Bangalore"),
              onTap: () {
                context.read<LocationProvider>().setCurrentCity("Bangalore");
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text("Mumbai"),
              onTap: () {
                context.read<LocationProvider>().setCurrentCity("Mumbai");
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text("Delhi"),
              onTap: () {
                context.read<LocationProvider>().setCurrentCity("Delhi");
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text("Chandigarh"),
              onTap: () {
                context.read<LocationProvider>().setCurrentCity("Chandigarh");
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text("Cancel"),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 10,
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(100),
          bottomRight: Radius.circular(100),
        ),
      ),
      leadingWidth: 300,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.white),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                _showCitySelectionDialog();
              },
              child: Consumer<LocationProvider>(
                builder: (context, locationProvider, child) {
                  return Text(
                    locationProvider.currentCity,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: GestureDetector(
            onTap: () {
              // Handle profile icon click event
            },
            child: const Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 48,
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: 'Search...',
                                border: InputBorder.none,
                              ),
                              onTap: () {
                                // Search logic
                              },
                              onSubmitted: (query) {
                                widget.onSearchSubmitted(query);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.white),
                    onPressed: () {
                      // Filter logic
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
