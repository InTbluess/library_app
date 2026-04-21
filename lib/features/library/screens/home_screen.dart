import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/model/book_model.dart';
import 'book_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Book>('books');

    return Scaffold(
      appBar: AppBar(title: Text("My Library")),

      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Book> box, _) {
          if (box.isEmpty) {
            return Center(child: Text("No books yet 😢"));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final book = box.getAt(index)!;

              return ListTile(
                leading: book.coverImagePath != null
                    ? Image.file(
                        File(book.coverImagePath!),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.book),

                title: Text(book.title),
                subtitle: Text(book.author),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookDetailScreen(book: book),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}