import 'package:flutter/material.dart';

class CardiacDataPage extends StatefulWidget {
  const CardiacDataPage({Key? key}) : super(key: key);

  @override
  State<CardiacDataPage> createState() => _CardiacDataPageState();
}

class _CardiacDataPageState extends State<CardiacDataPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: const Text('My Cardiac History'),
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
