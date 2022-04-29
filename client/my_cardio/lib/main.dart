import 'package:flutter/material.dart';
import 'package:my_cardio/screens/login.dart';
import 'package:my_cardio/screens/home.dart';
import 'package:my_cardio/screens/cardiac_data.dart';
import 'package:my_cardio/screens/activities/activities.dart';
import 'package:my_cardio/screens/profile.dart';
import 'package:my_cardio/common/colorScheme.dart';

void main() {
  runApp(const MyCardioApp());
}

class MyCardioApp extends StatefulWidget {
  const MyCardioApp({Key? key}) : super(key: key);

  @override
  State<MyCardioApp> createState() => _MyCardioAppState();
}

class _MyCardioAppState extends State<MyCardioApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyCardio',
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'LexendDeca',
        colorScheme: lightColorScheme,
        backgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'LexendDeca',
        colorScheme: darkColorScheme,
        backgroundColor: const Color(0x1a1f24),
      ),
      themeMode: _themeMode,
      home: const LoginPage(),
    );
  }
}

class NavBar extends StatefulWidget {
  const NavBar({Key? key, required this.initialPage}) : super(key: key);

  final String initialPage;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  String _currentPage = 'homePage';

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    final colorscheme = Theme.of(context).colorScheme;

    return const Scaffold(body: HomePage());
  }
}
