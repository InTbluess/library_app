import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../data/model/book_model.dart';

enum FilterType { all, read, unread }

class FilterController extends ChangeNotifier {
  FilterType currentFilter = FilterType.all;

  final Box<Book> box = Hive.box<Book>('books');

  void setFilter(FilterType filter) {
    currentFilter = filter;
    notifyListeners();
  }

  String get emptyMessage {
  switch (currentFilter) {
    case FilterType.read:
      return "You need to read some books!";
    case FilterType.unread:
      return "No unread books! Great job!";
    case FilterType.all:
    default:
      return "No books yet. Tap the + button to add your first book!";
  }
}

  List<Book> get books {
    final allBooks = box.values.toList();

    switch (currentFilter) {
      case FilterType.read:
        return allBooks.where((b) => b.isRead == true).toList();

      case FilterType.unread:
        return allBooks.where((b) => b.isRead == false).toList();

      case FilterType.all:
      default:
        return allBooks;
    }
  }
}