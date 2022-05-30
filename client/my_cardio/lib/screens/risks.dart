import 'package:flutter/material.dart';

import '../common/apiCardiacData.dart';

import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class RisksPage extends StatefulWidget {
  const RisksPage({Key? key}) : super(key: key);

  @override
  State<RisksPage> createState() => _RisksPageState();
}

class _RisksPageState extends State<RisksPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  CardiacDataApiMethods cardiacDataAPI = CardiacDataApiMethods();

  Future<Object> getData() async => await cardiacDataAPI.getRiskData();

  @override
  Widget build(BuildContext context) {
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
              padding: EdgeInsets.only(top: 20),
              child: Text('Riscos Cardíacos')),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
              child: Image.asset('assets/images/logo-horiz.png',
                  width: 100, height: 80, fit: BoxFit.contain),
            ),
          ],
        ),
      ),

      // Risks dashboard
      body: FutureBuilder(
        future: getData(),
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
                    child: Text('Fetching detected risks...'),
                  ),
                ],
              ),
            );

            // Error
          } else if (snapshot.hasError) {
            page = Container();

            // Got data
            // TODO check if has data too
          } else if (snapshot.hasData) {
            Object? data = snapshot.data;
            page = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  width: MediaQuery.of(context).size.width * 0.85,
                  color: Colors.green,
                  child: Center(child: Text('List goes here')),
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
