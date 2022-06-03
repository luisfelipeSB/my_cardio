import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_cardio/common/sharedPreferences.dart';
import 'package:my_cardio/models/measurementFlag.dart';

import '../common/apiCardiacData.dart';

import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  CardiacDataApiMethods cardiacDataAPI = CardiacDataApiMethods();

  late Future<List<MeasurementFlag>> _myFuture;
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

  Future<List<MeasurementFlag>> getData(String usercode) async {
    return await cardiacDataAPI.getRiskData(usercode);
  }

  @override
  Widget build(BuildContext context) {
    final colorscheme = Theme.of(context).colorScheme;
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
              padding: EdgeInsets.only(top: 20), child: Text('Notificações')),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
              child: Image.asset('assets/images/logo-horiz-alt.png',
                  width: 100, height: 80, fit: BoxFit.contain),
            ),
          ],
        ),
      ),

      // Notifications list
      body: FutureBuilder(
        future: _myFuture,
        builder: (BuildContext context,
            AsyncSnapshot<List<MeasurementFlag>> snapshot) {
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
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<MeasurementFlag>? risks = snapshot.data;

            page = ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: risks!.length,
              itemBuilder: (BuildContext context, int index) {
                final risk = risks[index];

                // Notification card
                return Card(
                  child: Container(),
                );
              },
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
