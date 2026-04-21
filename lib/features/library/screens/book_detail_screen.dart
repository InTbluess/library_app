import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import '../../../data/model/book_model.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),

      body: book.pdfPath == null
          ? Center(
              child: Text(
                "No PDF available 😔",
                style: TextStyle(fontSize: 18),
              ),
            )
          : PDFView(
              filePath: book.pdfPath!,
            ),
    );
  }
}