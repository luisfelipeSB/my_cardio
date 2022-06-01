import 'package:flutter/material.dart';
import 'package:my_cardio/common/apiCardiacData.dart';
import 'package:my_cardio/common/constants.dart';
import 'package:my_cardio/models/measurement.dart';
import 'package:my_cardio/screens/cardiac_data/graph.dart';

import 'dart:developer';

import '../../common/sharedPreferences.dart';

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
    MySharedPreferences.instance
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
            log(widget.datatypes.toString());
            for (int i = 0; i < measurements!.length; i++) {
              log('----- type ${widget.datatypes[i]} -----');
              for (int j = 0; j < 10; j++) {
                log(measurements[i][j].toJson().toString());
              }
            }
            */

            page = ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: widget.datatypes.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Text(measure_types[widget.datatypes[index]]!),
                      Graph(
                          datatype: widget.datatypes[index],
                          measurements: measurements![index]),
                      /*
                      Container(
                        width: 300,
                        height: 350,
                        child: Graph(
                            datatype: widget.datatypes[index],
                            measurements: measurements![index]),
                      ),
                      */
                    ],
                  ),
                );
              },
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
