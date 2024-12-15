import 'package:flutter/material.dart';
import 'package:systemates/controller/event_controller.dart';

class EditEvent extends StatelessWidget {
  final String documentId;
  final String currentTitle;
  final String currentDescription;
  final String currentImageUrl;

  const EditEvent({
    super.key,
    required this.documentId,
    required this.currentTitle,
    required this.currentDescription,
    required this.currentImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Create TextEditingControllers for Title, Description, and Image URL
    final TextEditingController titleController = TextEditingController(text: currentTitle);
    final TextEditingController descriptionController = TextEditingController(text: currentDescription);
    final TextEditingController imageUrlController = TextEditingController(text: currentImageUrl);

    final EventController editEventController = EventController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Title',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 93, 56, 134),
              ),
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Description',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 93, 56, 134),
              ),
            ),
            SizedBox(
              height: 200.0,
              child: TextField(
                controller: descriptionController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Image URL',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 93, 56, 134),
              ),
            ),
            TextField(
              controller: imageUrlController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () async {
                String newTitle = titleController.text.trim();
                String newDescription = descriptionController.text.trim();
                String newImageUrl = imageUrlController.text.trim();

                if (newTitle.isEmpty || newDescription.isEmpty || newImageUrl.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fields cannot be empty')),
                  );
                  return;
                }

                bool success = await editEventController.updateEvent(
                  documentId: documentId,
                  title: newTitle,
                  description: newDescription,
                  imageUrl: newImageUrl,
                );

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Event updated successfully')),
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Event to update news')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 93, 56, 134),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Save Changes"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                bool success = await editEventController.deleteEvent(documentId: documentId);

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Event deleted successfully')),
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to delete event')),
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
              child: const Text("Delete Event"),
            ),
          ],
        ),
      ),
    );
  }
}