import 'package:flutter/material.dart';
import 'package:badges/src/badge.dart';
import 'package:my_cardio/pages/cardiac_data.dart';
import 'package:my_cardio/pages/patterns.dart';
import 'package:my_cardio/pages/rankings.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://googleflutter.com/sample_image.jpg'),
                              fit: BoxFit.fill),
                        ),
                      ),
                      SizedBox(
                        width: 110,
                        height: 50,
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
                        children: const [
                          // TODO adaptive username and password + style
                          Text('Good Morning'),
                          Text('user_name'),
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
                            badgeContent: Text('1'),
                            child: const Icon(Icons.notifications, size: 50),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Icon(
                                  Icons.circle,
                                  color: colorscheme.primary,
                                  size: 50,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Icon(
                                  Icons.circle,
                                  color: colorscheme.secondary,
                                  size: 50,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Icon(
                                  Icons.circle,
                                  color: colorscheme.tertiary,
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
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: InkWell(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CardiacDataPage(),
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
                                          Icons.auto_graph,
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
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PatternsPage(),
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
                                                  horizontal: 15.0),
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
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RankingsPage(),
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
                                                  horizontal: 15.0),
                                              child: Icon(
                                                Icons.groups,
                                                size: 40,
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text('Rankings'),
                                                Text('Who\'s best?'),
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
