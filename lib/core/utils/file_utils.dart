import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

//Pick Image
Future<String?> pickAndSaveImage() async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(source: ImageSource.gallery);

  if (picked == null) return null;

  final file = File(picked.path);

  final dir = await getApplicationDocumentsDirectory();
  final newPath = '${dir.path}/${picked.name}';

  final newFile = await file.copy(newPath);

  return newFile.path;
}

//Pick PDF
Future<String?> pickAndSavePdf() async {
  final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

  if (result == null) return null;

  final file = File(result.files.single.path!);

  final dir = await getApplicationDocumentsDirectory();
  final newPath = '${dir.path}/${result.files.single.name}';

  final newFile = await file.copy(newPath);

  return newFile.path;
}