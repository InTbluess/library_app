  import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:library_app/features/library/controllers/filter_controller.dart';
import 'package:library_app/features/library/controllers/searching_controller.dart';
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
    final controller = Provider.of<FilterController>(context);

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            // HEADER
            UserAccountsDrawerHeader(
              accountName: Text("Hello Reader!"),
              accountEmail: Text("Welcome back!"),
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.person, size: 30),
              ),
            ),

            // ALL BOOKS
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text("All Books"), // ALL
              selected: controller.currentFilter == FilterType.all,
              onTap: () {
                controller.setFilter(FilterType.all);
                Navigator.pop(context);
              },
            ),

            // FAVORITES
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text("Favorite Books"),
              selected: controller.currentFilter == FilterType.favorites,
              onTap: () {
                controller.setFilter(FilterType.favorites);
                Navigator.pop(context);
              },
            ),

            // UNREAD
            ListTile(
              leading: Icon(Icons.menu_book),
              title: Text("Unread Books"),
              selected: controller.currentFilter == FilterType.unread,
              onTap: () {
                controller.setFilter(FilterType.unread);
                Navigator.pop(context);
              },
            ),

            // READ
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text("Read Books"),
              selected: controller.currentFilter == FilterType.read,
              onTap: () {
                controller.setFilter(FilterType.read);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 150,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TITLE
            Text(
              "HerShelf",
              style: GoogleFonts.pacifico(
                fontSize: 35,
                color: Provider.of<ThemeController>(context).isDark
                    ? Colors.white
                    : Colors.black,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                // MENU
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, size: 28),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // SEARCH BAR
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.search, size: 20),

                        const SizedBox(width: 8),

                        Expanded(
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            decoration: const InputDecoration(
                              hintText: "Search books...",
                              border: InputBorder.none,
                              isCollapsed: true,
                            ),
                            onChanged: (value) {
                              Provider.of<SearchingController>(
                                context,
                                listen: false,
                              ).setQuery(value);
                            },
                          ),
                        ),

                        const SizedBox(width: 8),

                        GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            Provider.of<SearchingController>(
                              context,
                              listen: false,
                            ).setQuery("");
                          },
                          child: const Icon(Icons.close, size: 18),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // THEME TOGGLE
                IconButton(
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
              ],
            ),
          ],
        ),
      ),

      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box<Book> box, _) {
            final filterController = Provider.of<FilterController>(context);
            final searchingController = Provider.of<SearchingController>(
              context,
            );

            final books = searchingController.getFilteredBooks(
              box,
              filterController.currentFilter,
            );
            if (books.isEmpty) {
              return Center(
                child: Text(
                  searchingController.query.isNotEmpty
                      ? "No matching books 😢"
                      : filterController.emptyMessage,
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.65, //important for poster look
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];

                return BookTile(
                  book: book,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    showBookDialog(context, book, index);
                  },
                );
              },
            );
          },
        ),
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
