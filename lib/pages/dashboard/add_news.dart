import 'package:flutter/material.dart';
import 'package:systemates/controller/add_news_controller.dart';

class AddNews extends StatelessWidget {
  const AddNews({super.key});

  @override
  Widget build(BuildContext context) {
    // Create TextEditingControllers for Title and Description
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _descriptionController = TextEditingController();
    final TextEditingController _imageUrlController = TextEditingController();

    final AddNewsController _addNewsController = AddNewsController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add News'),        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16,),

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
                controller: _descriptionController,
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
              controller: _imageUrlController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                // Get the title, description, and imageUrl from the controllers
                String title = _titleController.text.trim();
                String description = _descriptionController.text.trim();
                String imageUrl = _imageUrlController.text.trim();

                // Check if title, description, and imageUrl are not empty
                if (title.isEmpty || description.isEmpty || imageUrl.isEmpty) {
                  // Show a message if fields are empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Title, description, and image URL cannot be empty')),
                  );
                  return;
                }

                // Call the saveNews method from the controller
                bool success = await _addNewsController.saveNews(
                  title: title,
                  description: description,
                  imageUrl: imageUrl, // Correct usage of the parameter
                );

                if (success) {
                  // Show success message and navigate back
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('News saved successfully')),
                  );
                  Navigator.of(context).pop(); // Navigate back
                } else {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to save news')),
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
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}