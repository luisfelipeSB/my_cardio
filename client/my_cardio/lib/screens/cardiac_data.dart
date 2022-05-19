import 'package:flutter/material.dart';
import 'package:my_cardio/common/apiCardiacData.dart';
import 'package:my_cardio/models/measurement.dart';

import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/sharedPreferences.dart';

class CardiacDataPage extends StatefulWidget {
  const CardiacDataPage({Key? key}) : super(key: key);

  @override
  State<CardiacDataPage> createState() => _CardiacDataPageState();
}

class _CardiacDataPageState extends State<CardiacDataPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  CardiacDataApiMethods cardiacDataAPI = CardiacDataApiMethods();

  late Future<List<Measurement>> _myFuture;
  String usercode = 'initialize';

  @override
  void initState() {
    MySharedPreferences.instance
        .getStringValue("usercode")
        .then((value) => setState(() {
              usercode = value;
              _myFuture = getData(usercode);
            }));
    _myFuture = getData(usercode);
    super.initState();
  }

  Future<List<Measurement>> getData(code) async =>
      await cardiacDataAPI.getData(code);

  @override
  Widget build(BuildContext context) {
    MySharedPreferences.instance
        .getStringValue("usercode")
        .then((value) => setState(() {
              usercode = value;
            }));

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          leading: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          title: const Padding(
              padding: EdgeInsets.only(top: 20), child: Text('Cardiac Risks')),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
              child: Image.asset('assets/images/logo-horiz.png',
                  width: 100, height: 80, fit: BoxFit.contain),
            ),
          ],
        ),
      ),

      // Cardiac data dashboard
      body: FutureBuilder(
        future: getData(usercode),
        builder: (BuildContext context, AsyncSnapshot<Object> snapshot) {
          Widget page;

          // Waiting to get items
          if (snapshot.connectionState == ConnectionState.waiting) {
            page = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text('Fetching your cardiac data...'),
                  ),
                ],
              ),
            );

            // Error
          } else if (snapshot.hasError) {
            page = Container();

            // Got data
          } else if (snapshot.hasData) {
            String? data = snapshot.data.toString();
            print(data);
            page = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  width: MediaQuery.of(context).size.width * 0.85,
                  color: Colors.green,
                  child: Center(child: Text('Dashboard goes here')),
                ),
              ],
            );

            // No data
          } else {
            page = Container();
          }
          return page;
        },
      ),
    );
  }
}
