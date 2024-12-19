import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatefulWidget {
  final String documentId;

  const QRScannerPage({super.key, required this.documentId});

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  late MobileScannerController scannerController;
  bool isTorchOn = false;
  bool isProcessing = false; // Prevent multiple scans

  @override
  void initState() {
    super.initState();
    scannerController = MobileScannerController();
  }

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }

  void toggleTorch() {
    scannerController.toggleTorch();
    setState(() {
      isTorchOn = !isTorchOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: scannerController,
            fit: BoxFit.cover,
            onDetect: (barcodeCapture) async {
              if (isProcessing) return; // Skip if already processing
              isProcessing = true;

              final Barcode? barcode = barcodeCapture.barcodes.first;

              if (barcode == null || barcode.rawValue == null) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to read QR Code')),
                  );
                }
                isProcessing = false;
                return;
              }

              final String qrData = barcode.rawValue!;
              if (qrData == widget.documentId) {
                try {
                  await FirebaseFirestore.instance.collection('attendances').add({
                    'eventId': widget.documentId,
                    'userId': FirebaseAuth.instance.currentUser?.uid,
                    'timestamp': FieldValue.serverTimestamp(),
                  });

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Attendance recorded successfully')),
                    );
                    Navigator.pop(context);
                  }
                } catch (error) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $error')),
                    );
                  }
                } finally {
                  isProcessing = false;
                }
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid QR Code')),
                  );
                }
                isProcessing = false;
              }
            },
          ),

          // Overlay Scan Box
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // Floating Action Buttons
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  heroTag: "torch_button",
                  backgroundColor: theme.colorScheme.primary,
                  onPressed: toggleTorch,
                  child: Icon(
                    isTorchOn ? Icons.flash_on : Icons.flash_off,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                FloatingActionButton(
                  heroTag: "switch_camera_button",
                  backgroundColor: theme.colorScheme.primary,
                  onPressed: () => scannerController.switchCamera(),
                  child: Icon(Icons.switch_camera, color: theme.colorScheme.onPrimary),
                ),
                FloatingActionButton(
                  heroTag: "close_button",
                  backgroundColor: theme.colorScheme.error,
                  onPressed: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: theme.colorScheme.onError),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
