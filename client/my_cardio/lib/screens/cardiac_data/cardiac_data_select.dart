import 'package:flutter/material.dart';
import 'package:my_cardio/common/apiCardiacData.dart';
import 'package:my_cardio/models/measurement.dart';

import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/sharedPreferences.dart';
import 'cardiac_data.dart';

class CardiacDataSelectPage extends StatefulWidget {
  const CardiacDataSelectPage({Key? key}) : super(key: key);

  @override
  State<CardiacDataSelectPage> createState() => _CardiacDataSelectPageState();
}

class _CardiacDataSelectPageState extends State<CardiacDataSelectPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
              padding: EdgeInsets.only(top: 20),
              child: Text('Dados Cardíacos')),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
              child: Image.asset('assets/images/logo-horiz-alt.png',
                  width: 100, height: 80, fit: BoxFit.contain),
            ),
          ],
        ),
      ),

      // Options
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 40),
            width: MediaQuery.of(context).size.width * 0.85,
            child: ListView(
              children: <Widget>[
                // 1 - Heart Rate
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    tileColor: colorscheme.tertiary,
                    title: Text(
                      'Frequência Cardíaca',
                      style: TextStyle(color: colorscheme.background),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    // Route
                    onTap: () async {
                      List<int> datatypes = [1];
                      log(datatypes.toString());
                      await MySharedPreferences.instance
                          .setStringValue("datatypes", datatypes.toString());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CardiacDataPage(),
                        ),
                      );
                    },
                  ),
                ),

                // 2, 3, 4 - Steps, Distance, Calories
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    tileColor: colorscheme.tertiary,
                    title: Text(
                      'Actividade',
                      style: TextStyle(color: colorscheme.background),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    // Route
                    onTap: () async {
                      List<int> datatypes = [2, 3, 4];
                      log(datatypes.toString());
                      await MySharedPreferences.instance
                          .setStringValue("datatypes", datatypes.toString());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CardiacDataPage(),
                        ),
                      );
                    },
                  ),
                ),

                // 19, 20 - Diastolic/Systolic Blood Pressure
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    tileColor: colorscheme.tertiary,
                    title: Text(
                      'Tensão Arterial',
                      style: TextStyle(color: colorscheme.background),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () async {
                      List<int> datatypes = [19, 20];
                      log(datatypes.toString());
                      await MySharedPreferences.instance
                          .setStringValue("datatypes", datatypes.toString());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CardiacDataPage(),
                        ),
                      );
                    },
                  ),
                ),

                // 21, 22, 23, 24 - Weight, Fat Free Mass, Fat Ratio/Mass
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    tileColor: colorscheme.tertiary,
                    title: Text(
                      'Peso',
                      style: TextStyle(color: colorscheme.background),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () async {
                      List<int> datatypes = [21, 22, 23, 24];
                      log(datatypes.toString());
                      await MySharedPreferences.instance
                          .setStringValue("datatypes", datatypes.toString());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CardiacDataPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      /*
      FutureBuilder(
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
                    child: Text('A buscar sua lista...'),
                  ),
                ],
              ),
            );

            // Error
          } else if (snapshot.hasError) {
            page = const Center(
              child: Text('Ocorreu um erro :('),
            );

            // Got data
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Measurement>? history = snapshot.data;
            page = Center(
              child: Text(history.toString()),
            );

            // No data
          } else {
            page = Center(
              child: Column(
                children: const [
                  Text('Lista vazia'),
                  Text('Selecione (+) para adicionar um item'),
                  Text('Mantenha um item pressionado para editá-lo'),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            );
          }
          return page;
        },
      ),
      */
    );
  }
}
