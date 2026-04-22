import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:library_app/features/library/screens/add_book_screen.dart';
import 'package:library_app/features/library/widgets/book_detail_popup.dart';
import 'package:library_app/features/library/widgets/book_tile.dart';
import '../../../data/model/book_model.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Book>('books');

    return Scaffold(
      appBar: AppBar(title: Text("HerShelf")),

      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Book> box, _) {
          if (box.isEmpty) {
            return Center(child: Text("No books yet"));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final book = box.getAt(index)!;

              return BookTile(
                book: book,
                onTap: () {
                  showBookDialog(context, book, index);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddBookScreen()),
          );
        },
        icon: Icon(Icons.add),
        label: Text("Add Book"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
