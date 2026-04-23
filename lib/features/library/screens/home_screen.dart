import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:library_app/features/library/controllers/theme_controller.dart';
import 'package:library_app/features/library/screens/add_book_screen.dart';
import 'package:library_app/features/library/widgets/book_detail_popup.dart';
import 'package:library_app/features/library/widgets/book_tile.dart';
import 'package:provider/provider.dart';
import '../../../data/model/book_model.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Book>('books');

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            // 👤 HEADER
            UserAccountsDrawerHeader(
              accountName: Text("Indranil"), // you can replace later
              accountEmail: Text("Welcome back 👋"),
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.person, size: 30),
              ),
            ),

            // 📚 ALL BOOKS
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text("All Books"),
              onTap: () {
                Navigator.pop(context);
                // default view
              },
            ),

            // 📖 UNREAD
            ListTile(
              leading: Icon(Icons.menu_book),
              title: Text("Unread Books"),
              onTap: () {
                Navigator.pop(context);
                // we’ll filter soon
              },
            ),

            // ✅ READ
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text("Read Books"),
              onTap: () {
                Navigator.pop(context);
                // we’ll filter soon
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        toolbarHeight: 100,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Text(
          "HerShelf",
          style: GoogleFonts.pacifico(
            fontSize: 30,
            color: Provider.of<ThemeController>(context).isDark
                ? Colors.white
                : Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(
                Provider.of<ThemeController>(context).isDark
                    ? Icons.light_mode
                    : Icons.dark_mode,
                size: 28,
              ),
              onPressed: () {
                Provider.of<ThemeController>(
                  context,
                  listen: false,
                ).toggleTheme();
              },
            ),
          ),
        ],
      ),

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
