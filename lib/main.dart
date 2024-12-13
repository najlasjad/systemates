import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:systemates/pages/auth/login.dart'; // Your LoginPage
import 'package:systemates/pages/dashboard/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), // Listen to auth state changes
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()), // Show loading while checking auth state
            );
          }
          
          // If user is logged in, navigate to HomePage, otherwise LoginPage
          if (snapshot.hasData) {
            return const HomePage(); // User is logged in, show home page
          } else {
            return const LoginPage(); // User is not logged in, show login page
          }
        },
      ),
    );
  }
}
