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
      
      // Save additional user info to Firestore
      User? user = userCredential.user;
      if (user != null) {
        // Create a user document in Firestore with extra information
        await _firebaseFirestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'phone': phone,
          'batch': batch,
          'createdAt': Timestamp.now(),
        });
        return user;
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

  // Check if user is logged in
  Stream<User?> get currentUser => _firebaseAuth.authStateChanges();
}
