import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:library_app/core/utils/string_sanitizer.dart';
import 'package:library_app/features/library/controllers/filter_controller.dart';
import '../../../data/model/book_model.dart';

class SearchingController extends ChangeNotifier {
  String query = "";

  void setQuery(String value) {
    query = value.toLowerCase();
    notifyListeners();
  }

  List<Book> getFilteredBooks(
    Box<Book> box,
    FilterType filter,
  ) {
    final books = box.values.toList();
    final sanitizedQuery = sanitize(query);

    return books.where((book) {
      // SEARCH MATCH
      final matchesSearch =
          book.title.toLowerCase().contains(sanitizedQuery) ||
          book.author.toLowerCase().contains(sanitizedQuery);

      // FILTER MATCH
      bool matchesFilter;
      switch (filter) {
        case FilterType.read:
          matchesFilter = book.isRead == true;
          break;
        case FilterType.unread:
          matchesFilter = book.isRead == false;
          break;
        case FilterType.favorites:
          matchesFilter = book.isFavorite == true;
          break;
        case FilterType.all:
        default:
          matchesFilter = true;
      }

      return matchesSearch && matchesFilter;
    }).toList();
  }
}