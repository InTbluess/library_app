import 'package:hive/hive.dart';
import 'package:library_app/data/model/book_model.dart';

Future<void> addBook({
  required String title,
  required String author,
  String? pdfPath,
  String? imagePath,
}) async {
  final box = Hive.box<Book>('books');

  final book = Book(
    title: title,
    author: author,
    pdfPath: pdfPath,
    coverImagePath: imagePath,
  );

  await box.add(book);
}