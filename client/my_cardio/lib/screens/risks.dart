import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_cardio/common/sharedPreferences.dart';
import 'package:my_cardio/models/measurementFlag.dart';

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
              padding: EdgeInsets.only(top: 20),
              child: Text('Riscos Cardíacos')),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
              child: Image.asset('assets/images/logo-horiz-alt.png',
                  width: 100, height: 80, fit: BoxFit.contain),
            ),
          ],
        ),
      ),

      // Risks dashboard
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

                // Risk card
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),

                        // Icon and title
                        child: ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Icon(
                              Icons.error_outline,
                              size: 35,
                              color: colorscheme.inverseSurface,
                            ),
                          ),
                          title: Text(
                              'Risco detetado em ${DateFormat('d/M/y').add_jm().format(risk.instant)}'),
                        ),
                      ),

                      // Nurse tag
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, bottom: 10, right: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                            'Tag: ${risk.title} | ${risk.description}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      // Measure type and device
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, bottom: 20, right: 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                'Disparado ao medir ${risk.measurement_type}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: colorscheme.onPrimary,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(7)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Text(risk.device),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  elevation: 10,
                  color: colorscheme.onPrimaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
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
