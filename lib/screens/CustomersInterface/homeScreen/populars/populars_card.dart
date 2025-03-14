import 'package:flutter/material.dart';
import 'package:livein/screens/CustomersInterface/productScreen/product_screen.dart';

class PopularsCard extends StatelessWidget {
  final String title;
  final String host;
  final String price;
  final String apartmentType;
  final String numberOfBaths;
  final String accommodationType;
  final String numberOfRoomatesRequired;
  final String label;
  final String genderPreference;
  final String area;
  final String city;
  final String pincode;
  final List<String>? imageUrls;
  final String description;
  final String hostId;

  const PopularsCard({
    super.key,
    required this.title,
    required this.host,
    required this.label,
    required this.price,
    required this.apartmentType,
    required this.numberOfBaths,
    required this.accommodationType,
    required this.numberOfRoomatesRequired,
    required this.genderPreference,
    required this.area,
    required this.city,
    required this.pincode,
    this.imageUrls,
    this.description = "A beautiful property with all modern amenities.", required this.hostId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductScreen(
              title: title,
              host: host,
              price: price,
              apartmentType: apartmentType,
              numberOfBaths: numberOfBaths,
              accommodationType: accommodationType,
              numberOfRoomatesRequired: numberOfRoomatesRequired,
              genderPreference: genderPreference,
              area: area,
              city: city,
              pincode: pincode,
              imageUrls: imageUrls,
              description: description,
              hostId: hostId,
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              child: Image.network(
                imageUrls != null && imageUrls!.isNotEmpty
                    ? imageUrls![0]
                    : 'https://via.placeholder.com/200',
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    color: Theme.of(context).colorScheme.secondary,
                    child: const Center(
                        child: Icon(
                      Icons.error,
                      color: Colors.white,
                    )),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$apartmentType • $numberOfBaths',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '\$$price / month',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Color.fromRGBO(143, 148, 251, .6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        area,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
