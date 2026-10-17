import 'package:blooddonerapp/screens/homescreen/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('dark_mode') ?? false;

  runApp(MyApp(initialDarkMode: isDarkMode));
}

class MyApp extends StatefulWidget {
  final bool initialDarkMode;

  const MyApp({super.key, required this.initialDarkMode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.initialDarkMode;
  }

  Future<void> toggleDarkMode(bool value) async {
    setState(() {
      _isDarkMode = value;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blood Donor App',

      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD71920),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),

      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD71920),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),

      home: const HomeScreen(),
    );
  }
}
