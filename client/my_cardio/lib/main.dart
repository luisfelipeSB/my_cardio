import 'package:flutter/material.dart';
import 'package:my_cardio/pages/login.dart';
import 'package:my_cardio/pages/home.dart';
import 'package:my_cardio/pages/cardiac_data.dart';
import 'package:my_cardio/pages/activities.dart';
import 'package:my_cardio/pages/profile.dart';
import 'package:my_cardio/helpers/colorScheme.dart';

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
    final tabs = {
      'homePage': HomePage(),
      'cardiacData': CardiacDataPage(),
      'myActivities': ActivitiesPage(),
      'profilePage': ProfilePage(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPage);
    final colorscheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: tabs[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => _currentPage = tabs.keys.toList()[i]),
        backgroundColor: colorscheme.surfaceVariant,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: 24,
            ),
            activeIcon: Icon(
              Icons.home_rounded,
              size: 24,
            ),
            label: ' Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.monitor_heart_outlined,
              size: 24,
            ),
            activeIcon: Icon(
              Icons.monitor_heart,
              size: 24,
            ),
            label: ' Cardiac Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.edit_note_outlined,
              size: 24,
            ),
            activeIcon: Icon(
              Icons.edit_note_rounded,
              size: 24,
            ),
            label: ' Activities',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              size: 24,
            ),
            activeIcon: Icon(
              Icons.person,
              size: 24,
            ),
            label: ' Profile',
          ),
        ],
      ),
    );
  }
}
