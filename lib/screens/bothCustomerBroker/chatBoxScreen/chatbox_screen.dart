import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'chat_screen.dart'; // Assuming ChatScreen is in the same directory

class ChatboxScreen extends StatelessWidget {
  ChatboxScreen({super.key});

  final CollectionReference _firestore =
      FirebaseFirestore.instance.collection("chats");

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
          title: const Center(
            child: Text(
              "Chats",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          bottom: const TabBar(
            dividerColor: Color(0x00000000),
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.white,
            indicatorWeight: 5,
            tabs: [
              Tab(text: "      All      "),
              Tab(text: "     Sent      "),
              Tab(text: " Received "),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildContactsList(context, "all"),
            _buildContactsList(context, "sent"),
            _buildContactsList(context, "received"),
          ],
        ),
      ),
    );
  }

  Widget _buildContactsList(BuildContext context, String filter) {
    return StreamBuilder(
      stream: _firestore.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text("Something went wrong!"));
        }

        final List<DocumentSnapshot> docs = snapshot.data!.docs;

        List<Map<String, dynamic>> contacts = docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id,
            'name': data['name'] ?? 'Unknown',
            'status': data['status'] ?? 'Offline',
            'lastMessage': data['lastMessage'] ?? '',
            'lastMessageTime':
                (data['lastMessageTime'] as Timestamp?)?.toDate() ??
                    DateTime.now(),
            'initiatedByMe': data['initiatedByMe'] ?? false,
            'profilePicture': data['profilePicture'],
          };
        }).toList();

        // Apply filter
        if (filter == "sent") {
          contacts = contacts.where((c) => c['initiatedByMe']).toList();
        } else if (filter == "received") {
          contacts = contacts.where((c) => !c['initiatedByMe']).toList();
        }

        return ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (ctx, index) {
            final contact = contacts[index];
            final formattedTime =
                DateFormat('h:mm a').format(contact['lastMessageTime']);
            final profileImage = contact['profilePicture'] != null
                ? NetworkImage(contact['profilePicture'])
                : null;

            return Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    backgroundImage: profileImage,
                    child:
                        profileImage == null ? Text(contact['name'][0]) : null,
                  ),
                  title: Text(contact['name']),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(contact['lastMessage'])),
                      Text(
                        formattedTime,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          chatId: contact['id'], // Pass the Firestore document ID
                          contactName: contact['name'],
                          profilePicture: contact['profilePicture'] ?? '', 
                        ),
                      ),
                    );
                  },
                ),
                Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                  indent: 15,
                  endIndent: 15,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
