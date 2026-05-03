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

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // IMAGE
            Positioned.fill(
              child: book.coverImagePath != null
                  ? Image.file(File(book.coverImagePath!), fit: BoxFit.cover)
                  : Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.book, size: 40),
                    ),
            ),

            // GRADIENT (for text readability)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
              ),
            ),

            // FAVORITE BUTTON (TOP LEFT)
            Positioned(
              top: 8,
              left: 8,
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: Icon(
                    book.isFavorite == true
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: book.isFavorite == true
                        ? Colors.redAccent
                        : Colors.white,
                  ),
                  onPressed: () async {
                    book.isFavorite = !book.isFavorite;
                    await book.save();
                  },
                ),
              ),
            ),

            // READ / UNREAD BUTTON (TOP RIGHT)
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                backgroundColor: isRead
                    ? const Color.fromARGB(200, 76, 175, 79)
                    : Colors.black54,
                child: IconButton(
                  icon: Icon(
                    isRead ? Icons.menu_book : Icons.book_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    book.isRead = !isRead;
                    await book.save();
                  },
                ),
              ),
            ),

            // TITLE + AUTHOR (BOTTOM)
            Positioned(
              left: 10,
              right: 10,
              bottom: 35,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.author,
                    style: const TextStyle(
                      color: Color.fromARGB(200, 255, 255, 255),
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
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
