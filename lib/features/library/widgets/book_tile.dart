import 'dart:io';
import 'package:flutter/material.dart';
import '../../../data/model/book_model.dart';

class BookTile extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookTile({required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isRead = book.isRead ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            // border: Border.all(color: Colors.grey.shade300),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black12,
            //     blurRadius: 6,
            //     offset: Offset(2, 2),
            //   ),
            // ],
          ),
          child: Stack(
            children: [
              // Main content
              Row(
                children: [
                  // Cover
                  Container(
                    width: 140,
                    height: 210,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: book.coverImagePath != null
                        ? Image.file(
                            File(book.coverImagePath!),
                            fit: BoxFit.cover,
                          )
                        : Icon(Icons.book, size: 50, color: Colors.grey),
                  ),

                  SizedBox(width: 16),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.book, size: 28),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                book.title,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 2.0),
                              child: Icon(Icons.person, size: 22),
                            ),
                            SizedBox(width: 10),
                            Text(book.author, style: TextStyle(fontSize: 22)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // TOP RIGHT BUTTON
              Positioned(
                top: 0,
                right: 0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(90, 30),
                    backgroundColor: isRead
                        ? const Color.fromARGB(255, 76, 175, 79)
                        : const Color.fromARGB(255, 244, 67, 54),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async {
                    book.isRead = !isRead;
                    await book.save();
                  },
                  child: isRead ? Icon(Icons.check_circle, color: Colors.white) : Icon(Icons.close, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
