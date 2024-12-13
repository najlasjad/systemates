import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:systemates/pages/dashboard/add_news.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Computing News'),
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

              // Extract title and description from the document data
              String title = newsItem['title'] ?? 'No Title';
              String description = newsItem['description'] ?? 'No Description';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(title),
                  subtitle: Text(description),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}