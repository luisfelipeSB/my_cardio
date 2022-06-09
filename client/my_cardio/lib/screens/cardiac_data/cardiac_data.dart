import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:my_cardio/common/api/api_cardiac_data.dart';
import 'package:my_cardio/common/constants.dart';
import 'package:my_cardio/common/shared_preferences.dart';
import 'package:my_cardio/models/measurement.dart';
import 'package:my_cardio/screens/cardiac_data/graph.dart';

class CardiacDataPage extends StatefulWidget {
  final List<int> datatypes;
  const CardiacDataPage({Key? key, required this.datatypes}) : super(key: key);

  @override
  State<CardiacDataPage> createState() => _CardiacDataPageState();
}

class _CardiacDataPageState extends State<CardiacDataPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  CardiacDataApiMethods cardiacDataAPI = CardiacDataApiMethods();

  late Future<List<List<Measurement>>> _myFuture;
  String usercode = 'initialize';

  @override
  void initState() {
    SharedPreferencesMethods.instance
        .getStringValue("usercode")
        .then((value) => setState(() {
              usercode = value;
              _myFuture = getData(usercode, widget.datatypes);
            }));
    _myFuture = getData(usercode, widget.datatypes);
    super.initState();
  }

  Future<List<List<Measurement>>> getData(usercode, datatypes) async =>
      await cardiacDataAPI.getData(usercode, datatypes);

  @override
  Widget build(BuildContext context) {
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
          } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
            List<List<Measurement>>? measurements = snapshot.data;

            page = ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: measurements!.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Text(measure_types[widget.datatypes[index]]!),
                      Graph(
                          datatype: widget.datatypes[index],
                          measurements: measurements[index]),
                    ],
                  ),
                );
              },
            );

            // No data
          } else {
            page = const Center(
              child: Text('Sem dados cardíacos deste tipo.'),
            );
          }
          return page;
        },
      ),
    );
  }
}
