import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_app/features/library/controllers/theme_controller.dart';
import 'package:library_app/features/library/widgets/change_confirmation_dialogue.dart';
import 'package:provider/provider.dart';
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
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text(
          "Edit Book",
          style: GoogleFonts.pacifico(
            fontSize: 30,
            color: Provider.of<ThemeController>(context).isDark
                ? Colors.white
                : Colors.black,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📝 TEXT FIELDS
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: authorController,
              decoration: InputDecoration(
                labelText: "Author",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🖼️ IMAGE SECTION
            Text(
              "Cover Image",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📸 IMAGE BOX
                Container(
                  height: 210,
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(imagePath!),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(child: Text("No Image")),
                ),

                const SizedBox(width: 16),

                // 🎛️ BUTTONS (RIGHT SIDE)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final newImage = await pickAndSaveImage();
                          if (newImage != null) {
                            setState(() => imagePath = newImage);
                          }
                        },
                        child: imagePath != null
                            ? const Text("Change Image")
                            : const Text("Select Image"),
                      ),

                      const SizedBox(height: 10),

                      if (imagePath != null)
                        OutlinedButton(
                          onPressed: () {
                            setState(() => imagePath = null);
                          },
                          child: const Text("Remove"),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 📄 PDF SECTION
            Text(
              "PDF File",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: Text(
                pdfPath != null
                    ? pdfPath!
                          .split('/')
                          .last // 🔥 filename only
                    : "No PDF selected",
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final newPdf = await pickAndSavePdf();
                      if (newPdf != null) {
                        setState(() => pdfPath = newPdf);
                      }
                    },
                    child: pdfPath != null
                        ? const Text("Change PDF")
                        : const Text("Select PDF"),
                  ),
                ),

                const SizedBox(width: 10),

                if (pdfPath != null)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => pdfPath = null);
                      },
                      child: const Text("Remove"),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 30),

            // 💾 SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final confirm = await confirmSaveChanges(
                    context,
                    titleController.text,
                    authorController.text,
                    widget.book.isRead,
                  );

                  if (confirm) {
                    widget.book.title = titleController.text;
                    widget.book.author = authorController.text;
                    widget.book.pdfPath = pdfPath;
                    widget.book.coverImagePath = imagePath;

                    await widget.book.save();

                    Navigator.pop(context);
                  }
                },
                child: const Text("Save Changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
