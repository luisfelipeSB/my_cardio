import 'package:flutter/material.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({Key? key}) : super(key: key);

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: const Text('My Activities'),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 20, 5),
            child: Image.asset('assets/images/logo-horiz.png',
                width: 90, height: 70, fit: BoxFit.fitWidth),
          ),
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            width: MediaQuery.of(context).size.width * 0.85,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
