import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../data/model/book_model.dart';
import '../../../core/utils/file_utils.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();

  String? pdfPath;
  String? imagePath;

  Future<void> addBook() async {
    final box = Hive.box<Book>('books');

    final book = Book(
      title: titleController.text,
      author: authorController.text,
      pdfPath: pdfPath,
      coverImagePath: imagePath,
    );

    await box.add(book);

    Navigator.pop(context); // go back after saving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Book")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(labelText: "Author"),
            ),

            const SizedBox(height: 20),

            /// 📄 PICK PDF
            ElevatedButton(
              onPressed: () async {
                final path = await pickAndSavePdf();
                setState(() {
                  pdfPath = path;
                });
              },
              child: const Text("Pick PDF"),
            ),

            /// 🖼️ PICK IMAGE
            ElevatedButton(
              onPressed: () async {
                final path = await pickAndSaveImage();
                setState(() {
                  imagePath = path;
                });
              },
              child: const Text("Pick Cover Image"),
            ),

            const SizedBox(height: 20),

            /// 💾 SAVE BOOK
            ElevatedButton(
              onPressed: addBook,
              child: const Text("Save Book"),
            ),
          ],
        ),
      ),
    );
  }
}