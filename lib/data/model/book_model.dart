import 'package:hive/hive.dart';

part 'book_model.g.dart';

@HiveType(typeId: 0)
class Book extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String author;

  @HiveField(2)
  String? pdfPath;

  @HiveField(3)
  String? coverImagePath;

  Book({
    required this.title,
    required this.author,
    this.pdfPath,
    this.coverImagePath,
  });
}