import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:systemates/pages/dashboard/edit_event.dart';
import 'package:systemates/pages/dashboard/scannerpage.dart';

class DetailEvent extends StatefulWidget {
  final String documentId;
  final String title;
  final String description;
  final String imageUrl;

  const DetailEvent({
    super.key,
    required this.documentId,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  _DetailEventState createState() => _DetailEventState();
}

class _DetailEventState extends State<DetailEvent> {
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminRole();
  }

  Future<void> _checkAdminRole() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _isAdmin = userDoc.data()?['role'] == 'admin';
        });
      }
    }
  }

  void _showQRCodeDialog() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Attendance QR Code'),
        content: SizedBox(
          width: 250, // Define a fixed width
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImageView(
                data: widget.documentId,
                version: QrVersions.auto,
                size: 200.0,
                errorStateBuilder: (context, error) => const Center(
                  child: Text('Failed to generate QR Code'),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Scan this QR code for attendance'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Event Details',
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
                  if (_isAdmin)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _showQRCodeDialog();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 93, 56, 134),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Generate Attendance QR Code'),
                      ),
                    ),
                  if (_isAdmin)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditEvent(
                                documentId: widget.documentId,
                                currentTitle: widget.title,
                                currentDescription: widget.description,
                                currentImageUrl: widget.imageUrl,
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
                    ),
                  if (!_isAdmin)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QRScannerPage(documentId: widget.documentId),
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
                        child: const Text('Scan QR Code for Attendance'),
                      ),
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
