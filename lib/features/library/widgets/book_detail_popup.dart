import 'dart:io';
import 'package:flutter/material.dart';
import 'package:library_app/features/library/screens/edit_book_screen.dart';
import 'package:library_app/features/library/widgets/delete_confirmation_tile.dart';
import 'package:open_filex/open_filex.dart';
import '../../../data/model/book_model.dart';

void showBookDialog(BuildContext context, Book book, int index) {
  Future<void> openPdf(BuildContext context, String path) async {
    final result = await OpenFilex.open(path);

    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to open PDF 😔"),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );

      print("Error opening file: ${result.message}");
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image
              if (book.coverImagePath != null)
                AspectRatio(
                  aspectRatio: 3 / 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      File(book.coverImagePath!),
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Icon(Icons.book, size: 80),
                ),

              SizedBox(height: 12),

              // Title
              Text(
                book.title,
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),

              // Author
              Text(
                book.author,
                style: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 114, 114, 114)),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),

              // Button / Message
              book.pdfPath != null
                  ? SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // close dialog
                          openPdf(context, book.pdfPath!);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.picture_as_pdf_outlined),
                            ),
                            Text("Read PDF"),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.error_outline,
                                color: Colors.redAccent,
                              ),
                            ),
                            const Text("No PDF available"),
                          ],
                        ),
                      ),
                    ),

              SizedBox(height: 10),

              Row(
                children: [
                  // Edit button
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // close dialog
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditBookScreen(book: book, index: index),
                            ),
                          );
                        },
                        child: Icon(Icons.edit_outlined),
                      ),
                    ),
                  ),

                  // Delete button
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context); // close dialog 
                          final confirm = await confirmDelete(context, book.title, book.author, book.isRead);

                          if (confirm) {
                            await book.delete();
                          }
                        },
                        child: Icon(
                          Icons.delete_outlined,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),

                  // Close Button
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Icon(Icons.close_outlined),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
