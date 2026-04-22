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
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Color(0xFF0F1115),

        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: Colors.grey[400]),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
