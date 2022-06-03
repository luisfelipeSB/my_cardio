import 'package:flutter/material.dart';
import 'package:my_cardio/screens/login.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyCardio',
      theme: ThemeData(
        fontFamily: 'LexendDeca',
        colorScheme: lightColorScheme,
        backgroundColor: Colors.white,
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
