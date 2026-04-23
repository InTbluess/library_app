import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:library_app/data/model/book_model.dart';
import 'package:library_app/features/library/screens/home_screen.dart';
import 'package:library_app/core/theme/ui_theme.dart';
import 'package:library_app/features/library/controllers/theme_controller.dart';
import 'package:provider/provider.dart';

void main() async {
  //initialize hive
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  //open the box
  Hive.registerAdapter(BookAdapter());
  await Hive.openBox<Book>('books');

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.currentTheme,
      home: HomeScreen(),
    );
  }
}