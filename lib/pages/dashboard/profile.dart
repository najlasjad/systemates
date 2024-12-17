import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:systemates/pages/auth/login.dart';
import '../../controller/auth_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController _authController = AuthController();
  User? _user;
  String _name = '';
  String _phone = '';
  String _batch = '';
  String _email = '';

  bool _isEditing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _batchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fetch user data from Firestore
  Future<void> _loadUserData() async {
    _user = FirebaseAuth.instance.currentUser;

    if (_user != null) {
      // Fetch user data from Firestore using UID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(_user!.uid).get();
      
      if (userDoc.exists) {
        setState(() {
          _name = userDoc['name'] ?? 'N/A';
          _phone = userDoc['phone'] ?? 'N/A';
          _batch = userDoc['batch'] ?? 'N/A';
          _email = _user!.email ?? 'N/A';
          
          // Pre-fill the text controllers with existing data
          _nameController.text = _name;
          _phoneController.text = _phone;
          _batchController.text = _batch;
        });
      }
    }
  }

  // Update profile
  Future<void> _updateProfile() async {
    if (_user != null) {
      await _authController.updateUserData(
        uid: _user!.uid,
        name: _nameController.text,
        phone: _phoneController.text,
        batch: _batchController.text,
      );
      setState(() {
        _name = _nameController.text;
        _phone = _phoneController.text;
        _batch = _batchController.text;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully')));
    }
  }

  // Cancel edit
  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      // Revert text controllers to the current values
      _nameController.text = _name;
      _phoneController.text = _phone;
      _batchController.text = _batch;
    });
  }

  // Log out method
  Future<void> _logOut() async {
    await _authController.signOut();
    // Navigate to the Login page after logging out
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile', 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 93, 56, 134),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_user == null)
              const Center(child: CircularProgressIndicator())
            else ...[
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color.fromARGB(255, 93, 56, 134),
                  child: Text(
                    _name.isNotEmpty ? _name[0].toUpperCase() : 'U',
                    style: const TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Display name
              TextField(
                controller: _nameController,
                enabled: _isEditing,
                decoration: InputDecoration(
                  labelText: 'Name',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _isEditing ? Colors.blue : Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Display phone
              TextField(
                controller: _phoneController,
                enabled: _isEditing,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _isEditing ? Colors.blue : Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Display batch
              TextField(
                controller: _batchController,
                enabled: _isEditing,
                decoration: InputDecoration(
                  labelText: 'Batch',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _isEditing ? Colors.blue : Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Show Edit or Save buttons
              if (_isEditing)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _cancelEdit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(150, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 93, 56, 134),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(150, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Save"),
                      ),
                    ),
                  ],
                )
              else ...[
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 93, 56, 134),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Edit Profile"),
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (_user != null) {
                    await _authController.deleteUser(_user!.uid);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Delete Account"),
              ),
              const SizedBox(height: 16),
              // Logout Button
              ElevatedButton(
                onPressed: _logOut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Log Out"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}