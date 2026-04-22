import 'dart:io';
import 'package:flutter/material.dart';
import '../../../data/model/book_model.dart';
import '../../../core/utils/file_utils.dart';

class EditBookScreen extends StatefulWidget {
  final Book book;
  final int index;

  const EditBookScreen({required this.book, required this.index});

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  late TextEditingController titleController;
  late TextEditingController authorController;

  String? pdfPath;
  String? imagePath;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.book.title);
    authorController = TextEditingController(text: widget.book.author);

    pdfPath = widget.book.pdfPath;
    imagePath = widget.book.coverImagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Book")),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Title"),
              ),

              TextField(
                controller: authorController,
                decoration: InputDecoration(labelText: "Author"),
              ),

              const SizedBox(height: 20),

              // Image Preview
              imagePath != null
                  ? Image.file(File(imagePath!), height: 120)
                  : Text("No image selected"),

              ElevatedButton(
                onPressed: () async {
                  final newImage = await pickAndSaveImage();
                  if (newImage != null) {
                    setState(() => imagePath = newImage);
                  }
                },
                child: Text("Change Cover Image"),
              ),

              const SizedBox(height: 10),

              // PDF Status
              Text(pdfPath != null ? "PDF selected" : "No PDF"),

              ElevatedButton(
                onPressed: () async {
                  final newPdf = await pickAndSavePdf();
                  if (newPdf != null) {
                    setState(() => pdfPath = newPdf);
                  }
                },
                child: Text("Change PDF"),
              ),

              ElevatedButton(
                onPressed: () async {
                  widget.book.title = titleController.text;
                  widget.book.author = authorController.text;
                  widget.book.pdfPath = pdfPath;
                  widget.book.coverImagePath = imagePath;

                  await widget.book.save();

                  Navigator.pop(context);
                },
                child: Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
