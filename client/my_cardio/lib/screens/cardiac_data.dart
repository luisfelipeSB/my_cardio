import 'package:flutter/material.dart';
import 'package:my_cardio/common/apiCardiacData.dart';

<<<<<<< HEAD
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

=======
>>>>>>> 89668093c0bf086f25b4c438b461f14915e6e73d
class CardiacDataPage extends StatefulWidget {
  const CardiacDataPage({Key? key}) : super(key: key);

  @override
  State<CardiacDataPage> createState() => _CardiacDataPageState();
}

class _CardiacDataPageState extends State<CardiacDataPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  CardiacDataApiMethods cardiacDataAPI = CardiacDataApiMethods();

  Future<Object> getData() async => await cardiacDataAPI.getData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          title: const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text('Cardiac History')),
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
                    child: Text('Fetching your cardiac data...'),
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
