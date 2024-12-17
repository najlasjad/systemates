import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:systemates/pages/dashboard/edit_news.dart';

class DetailNews extends StatefulWidget {
  final String documentId;
  final String title;
  final String description;
  final String imageUrl;

  const DetailNews({
    super.key,
    required this.documentId,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  _DetailNewsState createState() => _DetailNewsState();
}

class _DetailNewsState extends State<DetailNews> {
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
        title: const Text(
          'News Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 93, 56, 134),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.imageUrl.isNotEmpty)
              Image.network(
                widget.imageUrl,
                width: double.infinity,
                height: 250,
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
                    widget.title,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 93, 56, 134),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (_isAdmin) // Show Edit/Delete button only if the user is an admin
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditNews(
                              documentId: widget.documentId, // Pass the document ID
                              currentTitle: widget.title, // Pass the current title
                              currentDescription: widget.description, // Pass the current description
                              currentImageUrl: widget.imageUrl, // Pass the current image URL
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 93, 56, 134),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Edit/Delete'),
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
