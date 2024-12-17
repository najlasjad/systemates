import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Sign up method
  Future<User?> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String batch,
  }) async {
    try {
      // Create the user with email and password
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user after successful sign-up
      User? user = userCredential.user;
      if (user != null) {
        // Create a user document in Firestore with extra information and default role as "user"
        await _firebaseFirestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'phone': phone,
          'batch': batch,
          'role': 'user',  // Default role set to "user"
          'createdAt': Timestamp.now(),
        });

        return user; // Returning the user object after successful sign-up
      }
    } catch (e) {
      print("Sign Up Failed: $e");
      return null;
    }
    return null;
  }

  // Login method
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      // Log in with email and password
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Login Failed: $e");
      return null;
    }
  }

  // Sign out method
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Get current user synchronously
  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  // Update user data
  Future<void> updateUserData({
    required String uid,
    required String name,
    required String phone,
    required String batch,
  }) async {
    try {
      await _firebaseFirestore.collection('users').doc(uid).update({
        'name': name,
        'phone': phone,
        'batch': batch,
      });
    } catch (e) {
      print("Failed to update user data: $e");
    }
  }

  // Delete user account
  Future<void> deleteUser(String uid) async {
    try {
      // Delete user document from Firestore
      await _firebaseFirestore.collection('users').doc(uid).delete();
      // Delete the user's Firebase Authentication account
      User? user = await _firebaseAuth.currentUser;
      if (user != null) {
        await user.delete();
      }
    } catch (e) {
      print("Failed to delete account: $e");
    }
  }
}
