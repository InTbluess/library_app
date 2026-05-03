import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:library_app/data/model/book_model.dart';
import 'package:library_app/features/library/controllers/filter_controller.dart';
import 'package:library_app/features/library/screens/home_screen.dart';
import 'package:library_app/core/theme/ui_theme.dart';
import 'package:library_app/features/library/controllers/theme_controller.dart';
import 'package:library_app/features/library/controllers/searching_controller.dart'; 
import 'package:provider/provider.dart';

void main() async {
  //initialize hive
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  //open the box
  Hive.registerAdapter(BookAdapter());
  
  // await Hive.deleteBoxFromDisk('books');
  await Hive.openBox<Book>('books');
  // await Hive.box<Book>('books').clear();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => FilterController()),
        ChangeNotifierProvider(create: (_) => SearchingController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // @override //This rebuilds the whole app every time theme changes.
  // Widget build(BuildContext context) {
  //   final themeController = Provider.of<ThemeController>(context);

  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     theme: AppTheme.lightTheme,
  //     darkTheme: AppTheme.darkTheme,
  //     themeMode: themeController.currentTheme,
  //     home: HomeScreen(),
  //   );
  // }

  @override
Widget build(BuildContext context) {
  final themeController = context.watch<ThemeController>();

  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    themeMode: themeController.currentTheme,
    home: HomeScreen(),
  );
}
}
