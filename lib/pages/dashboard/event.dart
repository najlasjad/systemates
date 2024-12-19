import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:systemates/pages/dashboard/add_event.dart';
import 'package:systemates/pages/dashboard/detail_event.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool _isAdmin = false; // Default role is non-admin

  @override
  void initState() {
    super.initState();
    _checkAdminRole();
  }

  // Check if the current user has the 'admin' role
  Future<void> _checkAdminRole() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _isAdmin = userDoc.data()?['role'] == 'admin'; // Check the role field
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Computing Events',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 93, 56, 134),
          ),
        ),
        actions: <Widget>[
          if (_isAdmin) 
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddEvent()),
                );
              },
            ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No event available"));
          }

          final eventList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: eventList.length,
            itemBuilder: (context, index) {
              final eventItem = eventList[index];
              final documentId = eventItem.id; // Firestore document ID
              final title = eventItem['title'];
              final description = eventItem['description'];
              final imageUrl = eventItem['imageUrl'];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imageUrl.isNotEmpty)
                      Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Image failed to load'),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 93, 56, 134),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Builder(
                            builder: (context) {
                              List<String> words = description.split(' ');
                              String preview = words.take(20).join(' ');
                              bool hasMore = words.length > 20;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    preview + (hasMore ? '...' : ''),
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailEvent(
                                  documentId: documentId,
                                  title: title,
                                  description: description,
                                  imageUrl: imageUrl,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 93, 56, 134),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Read more'),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
