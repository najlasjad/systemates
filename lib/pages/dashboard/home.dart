import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:systemates/pages/dashboard/add_news.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Computing News',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 93, 56, 134),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Go to the next page',
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
            .orderBy('createdAt', descending: true) // Sort by creation date
            .snapshots(),
        builder: (context, snapshot) {
          // Check if data is available
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No news available"));
          }

          // List of documents retrieved from Firestore
          final newsList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              var newsItem = newsList[index].data() as Map<String, dynamic>;

              // Extract title, description, and imageUrl from the document data
              String title = newsItem['title'] ?? 'No Title';
              String description = newsItem['description'] ?? 'No Description';
              String imageUrl = newsItem['imageUrl'] ?? '';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imageUrl.isNotEmpty)
                      Image.network(
                        imageUrl,
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
                              fontSize: 20.0, // Larger font size for title
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 93, 56, 134),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Builder(
                            builder: (context) {
                              // Extract the first 20 words from the description
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
                        padding: const EdgeInsets.all(8.0), // Add margin to the button
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(title),
                                content: Text(description),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 93, 56, 134), // Change button background color
                            foregroundColor: Colors.white, // Change button text color
                          ),
                          child: const Text(
                            'Read more',
                          ),
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
