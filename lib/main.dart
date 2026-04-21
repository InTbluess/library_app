import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:library_app/data/model/book_model.dart';
import 'package:library_app/features/library/screens/home_screen.dart';

void main() async {
  //initialize hive
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  //open the box
  Hive.registerAdapter(BookAdapter());
  await Hive.openBox<Book>('books');
  

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HerShelf',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: HomeScreen(),
    );
  }
}
