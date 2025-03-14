// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:livein/screens/CustomersInterface/navbar/bottom_navbar.dart';
import 'package:livein/screens/bothCustomerBroker/addPostScreen/add_post_screen.dart';
import 'package:livein/screens/bothCustomerBroker/chatBoxScreen/chatbox_screen.dart';
import 'package:livein/screens/CustomersInterface/homeScreen/appBar/slivers_app_bar.dart';
import 'package:livein/screens/CustomersInterface/homeScreen/categories/categories.dart';
import 'package:livein/screens/CustomersInterface/homeScreen/lookingForRoomates/looking_roomates_card.dart';
import 'package:livein/screens/CustomersInterface/homeScreen/populars/populars_card.dart';
import 'package:livein/screens/CustomersInterface/homeScreen/tweetStyle/tweet_style_card.dart';
import 'package:livein/screens/CustomersInterface/profileScreen/profile_screen.dart';
import 'package:livein/screens/CustomersInterface/propertiesScreen/properties_screen.dart';
import 'package:livein/screens/CustomersInterface/searchResultsScreen/search_home_results.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPage = 0;

  final List<Widget> _pages = [
    const HomePage(),
    ChatboxScreen(),
    const PropertiesScreen(),
    const ProfileScreen(),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPage],
      bottomNavigationBar: BottomNavigation(
        selectedPage: _selectedPage,
        onPageChanged: _onPageChanged,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(onSearchSubmitted: (query) {
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchHomeResultsPage(
            searchQuery: query,
            
          ),
        ),
      );
    }
  },
),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(right: 16, left: 8),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                "Categories",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 120, // Set height for the category section
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0, right: 16),
                      child: Category(
                        name: 'Category',
                        onTap: () {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0, right: 16),
                      child: Category(
                        name: 'Category',
                        onTap: () {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0, right: 16),
                      child: Category(
                        name: 'Category',
                        onTap: () {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0, right: 16),
                      child: Category(
                        name: 'Category',
                        onTap: () {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0, right: 16),
                      child: Category(
                        name: 'Category',
                        onTap: () {},
                      ),
                    ),
                    // Repeat for other categories...
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Popular Listings",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 253, // Set height for the popular listings section
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children:  const [
                    Padding(
                      padding: EdgeInsets.only(right: 0),
                      child: PopularsCard(
                        imageUrls: ['https://picsum.photos/200'],
                        label: 'For Rent',
                        host: 'hello',
                        accommodationType: 'apartment',
                        genderPreference: 'only male',
                        numberOfRoomatesRequired: '4',
                        apartmentType: '3 Bhk',
                        numberOfBaths: '2 Baths',
                        title: 'Beautiful Apartment in the City',
                        price: '1,200',
                        area: 'Downtown',
                        city: 'Banglore',
                        pincode: "575001", hostId: '',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 0),
                      child: PopularsCard(
                        imageUrls: ['https://picsum.photos/201'],
                        label: 'For Rent',
                        host: 'hello',
                        accommodationType: 'apartment',
                        genderPreference: 'only male',
                        numberOfRoomatesRequired: '4',
                        apartmentType: '4 Bhk',
                        numberOfBaths: '3 Baths',
                        title: 'Luxury House with Garden',
                        price: '2,500',
                        area: 'Suburb',
                        city: 'Banglore',
                        pincode: "575001", hostId: '',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 0),
                      child: PopularsCard(
                        imageUrls: ['https://picsum.photos/202'],
                        label: 'For Rent',
                        host: 'hello',
                        accommodationType: 'apartment',
                        genderPreference: 'only male',
                        numberOfRoomatesRequired: '4',
                        apartmentType: '2 Bhk',
                        numberOfBaths: '1 Bath',
                        title: 'Cozy Studio Apartment',
                        price: '800',
                        area: 'City Center',
                        city: 'Banglore',
                        pincode: "575001", hostId: '',
                      ),
                    ),

                    // Add more PopularsCard widgets as needed
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const TweetCard(
                title: "Room Available",
                host: "Jane Doe",
                hostProfilePicUrl:
                    'https://i.pravatar.cc/300', // "https://avatar.iran.liara.run/public/42",
                price: "500",
                apartmentType: "2BHK",
                numberOfBaths: "2",
                accommodationType: "Apartment",
                numberOfRoomatesRequired: "3",
                label: "Roommates Needed",
                genderPreference: "female",
                area: "Fraser Town",
                city: "Bangalore",
                pincode: "560005",
                imageUrls: [
                  'https://picsum.photos/600',
                  //'https://picsum.photos/620',
                  // 'https://picsum.photos/201'
                ],
                description: "Looking for a relaxed and friendly environment.", hostId: '',
              ),
              const SizedBox(height: 16),
              const LookingRoomatesCard(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddPostScreen()));
          // Define the action for the FAB here (e.g., navigate to a new page)
        },
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(CupertinoIcons.plus, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
