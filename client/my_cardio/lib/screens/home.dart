import 'package:flutter/material.dart';
import 'package:my_cardio/common/constants.dart';

import 'package:my_cardio/common/shared_preferences.dart';
import 'package:my_cardio/screens/activities/activities.dart';
import 'package:my_cardio/screens/cardiac_data/cardiac_data_select.dart';
import 'package:my_cardio/screens/notifications.dart';
import 'package:my_cardio/screens/risks.dart';
import 'package:my_cardio/screens/profile/profile.dart';

// ignore: implementation_imports
import 'package:badges/src/badge.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String usercode = '';

  @override
  void initState() {
    SharedPreferencesMethods.instance
        .getStringValue("usercode")
        .then((value) => setState(() {
              usercode = value;
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorscheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          // Top row
          Container(
            decoration: BoxDecoration(
              color: colorscheme.secondaryContainer,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 10,
                  color: Color.fromARGB(125, 126, 126, 126),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Top icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Profile
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfilePage(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorscheme.background,
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.medical_information_outlined,
                              size: 35,
                              color: colorscheme.inverseSurface,
                            ),
                          ),
                        ),
                      ),

                      // Profile picture
                      Icon(
                        Icons.account_circle,
                        size: 120,
                        color: colorscheme.background,
                      ),

                      // Notifications
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationsPage(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorscheme.background,
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Badge(
                              badgeContent: const Text('0'), // TODO dynamic val
                              badgeColor: colorscheme.onPrimary,
                              child: Icon(
                                Icons.notifications_outlined,
                                size: 35,
                                color: colorscheme.inverseSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          usercode,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Panels
          Container(
            margin: EdgeInsets.only(top: screenHeight * 0.015),
            width: screenWidth * 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CardiacDataSelectPage(),
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
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: Icon(
                                          Icons.insights,
                                          size: 60,
                                          color: colorscheme.background,
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Dados Cardíacos',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: colorscheme.background),
                                          ),
                                          Text(
                                            'Acompanhe sua saúde',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: colorscheme.background),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Minor panels
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Panel 1
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const RisksPage(),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color: colorscheme.secondary,
                                          ),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                child: Icon(
                                                  Icons.emergency_outlined,
                                                  size: 40,
                                                  color: colorscheme.background,
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Riscos',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: colorscheme
                                                          .background,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Padrões detetados',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: colorscheme
                                                            .background),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                                // Panel 2
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ActivitiesPage(),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color: colorscheme.tertiary,
                                          ),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                child: Icon(
                                                  Icons.edit_note_rounded,
                                                  size: 40,
                                                  color: colorscheme.background,
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Checklist',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: colorscheme
                                                          .background,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Minhas atividades',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: colorscheme
                                                            .background),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
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
