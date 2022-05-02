import 'package:flutter/material.dart';
import 'package:my_cardio/common/sharedPreferences.dart';
import 'package:my_cardio/screens/login.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String usercode = '';

  @override
  Widget build(BuildContext context) {

    MySharedPreferences.instance
        .getStringValue("usercode")
        .then((value) => setState(() {
              usercode = value;
            }));

    var colorscheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        // Top section
        Container(
          height: 300,
          color: Theme.of(context).colorScheme.onInverseSurface,
          alignment: const Alignment(0, 0),
          child: Container(
            margin: const EdgeInsets.only(top: 60),
            width: MediaQuery.of(context).size.width * 0.85,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.account_circle, size: 50), // TODO
                    Row(
                      children: [
                        // Light/dark mode
                        ToggleSwitch(
                          minWidth: 50.0,
                          minHeight: 50.0,
                          cornerRadius: 25.0,
                          totalSwitches: 2,
                          icons: const [Icons.dark_mode, Icons.light_mode],
                          iconSize: 30.0,
                          activeBgColors: [
                            const [Colors.black45, Colors.black26],
                            [colorscheme.secondary, colorscheme.tertiary],
                          ],
                          animate: true,
                          curve: Curves.bounceInOut,
                          onToggle: (index) {
                            print('theme toggled'); // TODO toggle theme
                          },
                        ),

                        // Log out
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.login_rounded),
                              onPressed: () {
                                MySharedPreferences.instance.removeAll();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const Scaffold(body: LoginPage()),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // User information
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(usercode), // TODO
                      Text('other information...'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom section
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14.0),
                child: Text('This Week\'s Summary'),
              ),

              // Measurements card
              Card(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const ListTile(
                    leading: Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Icon(
                        Icons.monitor_heart_outlined,
                        size: 35,
                      ),
                    ),
                    title: Text('Measurements'),
                    subtitle: Text('Collected from devices x, y, z, ...'),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: colorscheme.onSurface,
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Text(
                              '[13]',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text('Last measurement: [datetime]'),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),

              // Risks card
              Card(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const ListTile(
                    leading: Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Icon(
                        Icons.error_outline,
                        size: 35,
                      ),
                    ),
                    title: Text('Risks detected'),
                    subtitle: Text('[Severity_level_of_risks?]'),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: colorscheme.onSurface,
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Text(
                              '[2]',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text('Latest risk found on [datetime]'),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),

              // Activities card
              Card(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const ListTile(
                    leading: Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Icon(
                        Icons.edit_note_outlined,
                        size: 35,
                      ),
                    ),
                    title: Text('Activities completed'),
                    subtitle: Text('[description_variety_of_activities]'),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: colorscheme.onSurface,
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Text(
                              '[10]',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text('Last completed activity: [days_ago]'),
                        ),
                      ],
                    ),
                  ),
                ]),
              )
            ],
          ),
        ),
      ],
    );
  }
}
