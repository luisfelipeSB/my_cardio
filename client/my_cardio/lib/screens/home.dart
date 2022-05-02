import 'package:flutter/material.dart';
import 'package:badges/src/badge.dart';
import 'package:my_cardio/screens/activities/activities.dart';
import 'package:my_cardio/screens/cardiac_data.dart';
import 'package:my_cardio/screens/risks.dart';
import 'package:my_cardio/screens/profile.dart';

import '../common/sharedPreferences.dart';
import '../models/user.dart';

import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String usercode = '';

  @override
  Widget build(BuildContext context) {
    /*final usercode = ModalRoute.of(context)!.settings.arguments;
    log('usercode: $usercode');*/

    MySharedPreferences.instance
        .getStringValue("usercode")
        .then((value) => setState(() {
              usercode = value;
            }));

    final colorscheme = Theme.of(context).colorScheme;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 60),
            width: MediaQuery.of(context).size.width * 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Top row
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Scaffold(body: ProfilePage()),
                            ),
                          );
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          child: Icon(Icons.account_circle, size: 60), // TODO
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        height: 60,
                        child: Image.asset('assets/images/logo-horiz.png'),
                      ),
                    ],
                  ),
                ),

                // Welcome message
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          // TODO adaptive username and password + style
                          Text('Good Morning'),
                          Text('$usercode'),
                          Text('Hope you have a nice day!'),
                        ],
                      ),
                    ],
                  ),
                ),

                // Notifications
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Badge(
                            badgeContent: Text('1'), // TODO
                            child: const Icon(Icons.notifications, size: 55),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            // TODO
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Icon(
                                  Icons.circle,
                                  color: colorscheme.secondary,
                                  size: 50,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Icon(
                                  Icons.circle,
                                  color: colorscheme.tertiary,
                                  size: 50,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Icon(
                                  Icons.circle,
                                  color: colorscheme.primary,
                                  size: 50,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Panels
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            // Main panel
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Scaffold(body: CardiacDataPage()),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        colorscheme.primary,
                                        colorscheme.tertiary
                                      ],
                                      stops: const [0, 1],
                                      begin: const AlignmentDirectional(0, 1),
                                      end: const AlignmentDirectional(0, -1),
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: Icon(
                                          Icons.monitor_heart_rounded,
                                          size: 50,
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text('Cardiac Data'),
                                          Text('Check your heart\'s health'),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Minor panels
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Panel 1
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Scaffold(body: RisksPage()),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: colorscheme.primary,
                                        ),
                                        child: Row(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.0),
                                              child: Icon(
                                                Icons.error,
                                                size: 40,
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text('Patterns'),
                                                Text('Risks found'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                // Panel 2
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Scaffold(body: ActivitiesPage()),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.40,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: colorscheme.secondary,
                                        ),
                                        child: Row(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.0),
                                              child: Icon(
                                                Icons.edit_note_rounded,
                                                size: 40,
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text('Activities'),
                                                Text('Take notes'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            /* Upload new data
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 50.0),
                                  child: Ink(
                                    width: 110,
                                    height: 110,
                                    decoration: const ShapeDecoration(
                                      color: Color.fromARGB(255, 95, 204, 255),
                                      shape: CircleBorder(),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.upload),
                                      iconSize: 40,
                                      color: Colors.white,
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            */
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
