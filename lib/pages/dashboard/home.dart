import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:systemates/pages/dashboard/add_news.dart';
import 'package:systemates/pages/dashboard/detail_news.dart';
import 'package:systemates/pages/dashboard/event.dart';
import 'package:systemates/pages/dashboard/profile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a ValueNotifier to manage the current index
    final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

    // Define the pages
    final List<Widget> pages = [
      const HomeContent(),
      const EventPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: currentIndex,
        builder: (context, index, _) {
          return pages[index];
        },
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: currentIndex,
        builder: (context, index, _) {
          return BottomNavigationBar(
            currentIndex: index,
            onTap: (newIndex) {
              currentIndex.value = newIndex;
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.article),
                label: 'Events',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          );
        },
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
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
          'Computing News',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 93, 56, 134),
          ),
        ),
        actions: <Widget>[
          if (_isAdmin) // Show Add button only if user is admin
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddNews()),
                );
              },
            ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('news')
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
            return const Center(child: Text("No news available"));
          }

          final newsList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              final newsItem = newsList[index];
              final documentId = newsItem.id; // Firestore document ID
              final title = newsItem['title'];
              final description = newsItem['description'];
              final imageUrl = newsItem['imageUrl'];

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
                                builder: (context) => DetailNews(
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
