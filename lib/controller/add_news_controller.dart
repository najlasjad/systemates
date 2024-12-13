import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddNewsController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Method to save news to Firestore
  Future<bool> saveNews({required String title, required String description}) async {
    try {
      // Get the current logged-in user
      User? user = _firebaseAuth.currentUser;
      if (user == null) {
        return false; // If no user is logged in, return false
      }

      // Add the news data to Firestore
      await _firebaseFirestore.collection('news').add({
        'title': title,
        'description': description,
        'createdAt': Timestamp.now(),
        'userId': user.uid, // Store the user ID who created the news
      });

      return true; // Success
    } catch (e) {
      print("Error saving news: $e");
      return false; // Failure
    }
  }
}
