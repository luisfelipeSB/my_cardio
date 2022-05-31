import 'package:flutter/material.dart';
import 'package:my_cardio/common/apiCardiacData.dart';
import 'package:my_cardio/models/measurement.dart';
import 'package:my_cardio/screens/cardiac_data/graph.dart';

import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/sharedPreferences.dart';

class CardiacDataPage extends StatefulWidget {
  const CardiacDataPage({Key? key}) : super(key: key);

  @override
  State<CardiacDataPage> createState() => _CardiacDataPageState();
}

class _CardiacDataPageState extends State<CardiacDataPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  CardiacDataApiMethods cardiacDataAPI = CardiacDataApiMethods();

  late Future<List<List<Measurement>>> _myFuture;
  String usercode = 'initialize';
  List<int> datatypes = [];

  @override
  void initState() {
    MySharedPreferences.instance
        .getStringValue("usercode")
        .then((value) => setState(() {
              usercode = value;
            }));
    MySharedPreferences.instance
        .getStringValue("datatypes")
        .then((value) => setState(() {
              value = value.substring(1, value.length - 1);
              List<String> values = value.split(',');
              for (final v in values) {
                datatypes.add(int.parse(v));
              }
              _myFuture = getData(usercode, datatypes);
            }));
    _myFuture = getData(usercode, datatypes);
    super.initState();
  }

  Future<List<List<Measurement>>> getData(usercode, datatypes) async =>
      await cardiacDataAPI.getData(usercode, datatypes);

  @override
  Widget build(BuildContext context) {
    final colorscheme = Theme.of(context).colorScheme;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,

      // App Bar
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
              padding: EdgeInsets.only(top: 20), child: Text('Dashboard')),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
              child: Image.asset('assets/images/logo-horiz-alt.png',
                  width: 100, height: 80, fit: BoxFit.contain),
            ),
          ],
        ),
      ),

      // Cardiac data dashboard
      body: FutureBuilder(
        future: _myFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Widget page;

          // Waiting to get data
          if (snapshot.connectionState == ConnectionState.waiting) {
            page = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text('A buscar seus dados...'),
                  ),
                ],
              ),
            );

            // Error
          } else if (snapshot.hasError) {
            log(snapshot.error.toString());
            page = const Center(
              child: Text('Ocorreu um erro :('),
            );

            // Got data
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<List<Measurement>>? measurements = snapshot.data;

            /*
            for (int i = 0; i < measurements!.length; i++) {
              log('----- type ${datatypes[i]} -----');
              for (int j = 0; j < measurements[i].length; j++) {
                log(measurements[i][j].toJson().toString());
              }
            }
            */
            page = Column(
              children: [
                // Graph
                Graph(),

                // Additional info
                Text("More data for data types $datatypes"),
              ],
            );

            // No data
          } else {
            page = Center(
              child: Column(
                children: const [
                  Text('Sem dados cardíacos deste tipo'),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            );
          }
          return page;
        },
      ),
    );
  }
}
