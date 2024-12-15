import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewsController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Method to save news to Firestore
  Future<bool> saveNews({required String title, required String description, required String imageUrl}) async {
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
        'imageUrl' : imageUrl,
        'createdAt': Timestamp.now(),
        'userId': user.uid, // Store the user ID who created the news
      });

      return true; // Success
    } catch (e) {
      print("Error saving news: $e");
      return false; // Failure
    }
  }

  Future<bool> updateNews({
  required String documentId,
  required String title,
  required String description,
  required String imageUrl,
  }) async {
    try {
      await _firebaseFirestore.collection('news').doc(documentId).update({
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'updatedAt': Timestamp.now(),
      });
      return true;
    } catch (e) {
      print("Error updating news: $e");
      return false;
    }
  }

  Future<bool> deleteNews({required String documentId}) async {
    try {
      await _firebaseFirestore.collection('news').doc(documentId).delete();
      return true;
    } catch (e) {
      print("Error deleting news: $e");
      return false;
    }
  }

}
