import 'package:flutter/material.dart';
import 'cardiac_data.dart';

class CardiacDataSelectPage extends StatefulWidget {
  const CardiacDataSelectPage({Key? key}) : super(key: key);

  @override
  State<CardiacDataSelectPage> createState() => _CardiacDataSelectPageState();
}

class _CardiacDataSelectPageState extends State<CardiacDataSelectPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  void _openGraphPage(BuildContext context, List<int> datatypes) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardiacDataPage(datatypes: datatypes),
      ),
    );
  }

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
                      _openGraphPage(context, datatypes);
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
                    onTap: () {
                      List<int> datatypes = [2, 3, 4];
                      _openGraphPage(context, datatypes);
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
                    onTap: () {
                      List<int> datatypes = [19, 20];
                      _openGraphPage(context, datatypes);
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
                    onTap: () {
                      List<int> datatypes = [21, 22, 23, 24];
                      _openGraphPage(context, datatypes);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
