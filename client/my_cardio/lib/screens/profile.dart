import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_cardio/common/apiUser.dart';
import 'package:my_cardio/common/sharedPreferences.dart';
import 'package:my_cardio/screens/login.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/userProfileData.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  UserApiMethods userAPI = UserApiMethods();
  late Future<UserProfileData> _myFuture;
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

  Future<UserProfileData> getData(String usercode) async {
    return await userAPI.getProfileData(usercode);
  }

  @override
  Widget build(BuildContext context) {
    print(usercode);
    final colorscheme = Theme.of(context).colorScheme;
    return Scaffold(
      key: scaffoldKey,
      body: FutureBuilder(
        future: _myFuture,
        builder:
            (BuildContext context, AsyncSnapshot<UserProfileData> snapshot) {
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
                    child: Text('Espete um momento...'),
                  ),
                ],
              ),
            );

            // Error
          } else if (snapshot.hasError) {
            page = Center(
              child: Column(
                children: const [
                  Text('Ocorreu um erro'),
                  Text('Por favor tente novamente'),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            );

            // Got data
          } else if (snapshot.hasData) {
            UserProfileData? user = snapshot.data;
            print(user!.toJson().toString());

            page = Column(
              children: [
                // Top section
                Container(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  alignment: const Alignment(0, 0),
                  child: Container(
                    margin: const EdgeInsets.only(top: 40),
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top row
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Return to home screen
                              Container(
                                decoration: BoxDecoration(
                                  color: colorscheme.background,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),

                              // Profile picture
                              Icon(
                                Icons.account_circle,
                                size: 50,
                                color: colorscheme.background,
                              ),

                              // Light/dark mode
                              ToggleSwitch(
                                minWidth: 50.0,
                                minHeight: 50.0,
                                cornerRadius: 25.0,
                                totalSwitches: 2,
                                icons: const [
                                  Icons.light_mode,
                                  Icons.dark_mode,
                                ],
                                iconSize: 30.0,
                                activeBgColors: const [
                                  [Colors.grey],
                                  [Colors.black],
                                ],
                                curve: Curves.bounceInOut,
                                onToggle: (index) {
                                  print('theme toggled'); // TODO toggle theme
                                },
                              ),

                              // Log out
                              Container(
                                decoration: BoxDecoration(
                                  color: colorscheme.background,
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
                            ],
                          ),
                        ),

                        // Ficha médica
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text(
                            'Ficha médica',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),

                        // User information 1
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: colorscheme.background,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              // Items
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Nome'),
                                    Text('${user.codigo}')
                                    //Text(user.name.toString()),
                                  ],
                                ),
                                Divider(color: colorscheme.inverseSurface),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Código de paciente'),
                                    Text(user.codigo.toString()),
                                  ],
                                ),
                                Divider(color: colorscheme.inverseSurface),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Data de nascimento'),
                                    Text(user.data_nascimento
                                        .toString()
                                        .substring(0, 11)),
                                  ],
                                ),
                                Divider(color: colorscheme.inverseSurface),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Sexo'),
                                    Text(user.sexo),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // User information 2
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: colorscheme.background,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              // Items
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Tipo sanguíneo'),
                                    Text('${user.codigo}')
                                  ],
                                ),
                                Divider(color: colorscheme.inverseSurface),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Altura'),
                                    Text('${user.codigo}')
                                  ],
                                ),
                                Divider(color: colorscheme.inverseSurface),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Peso'),
                                    Text('${user.codigo}')
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Edit profile button
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: colorscheme.background,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.edit),
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
                      ],
                    ),
                  ),
                ),

                // Show bottom sheet button
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          context: context,
                          builder: (BuildContext bc) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.8,
                              decoration: BoxDecoration(
                                color: colorscheme.background,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(25.0),
                                  topLeft: Radius.circular(25.0),
                                ),
                              ),

                              // Bottom sheet content
                              child: Column(
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 4.0),
                                    child: Icon(
                                      Icons.minimize_rounded,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  // Title
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 14.0),
                                    child: Text(
                                      'Resumo desta semana',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),

                                  // Measurements card
                                  Card(
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const ListTile(
                                            leading: Padding(
                                              padding: EdgeInsets.all(3.0),
                                              child: Icon(
                                                Icons.monitor_heart_outlined,
                                                size: 35,
                                              ),
                                            ),
                                            title: Text('Medições'),
                                            subtitle:
                                                Text('Coletadas pelo ...'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 0, 16, 16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: colorscheme.outline,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(7)),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            7.0),
                                                    child:
                                                        Text('${user.codigo}'),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0),
                                                  child: Text(
                                                      'Última medição: ${user.codigo}'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                  ),

                                  // Risks card
                                  Card(
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const ListTile(
                                            leading: Padding(
                                              padding: EdgeInsets.all(3.0),
                                              child: Icon(
                                                Icons.error_outline,
                                                size: 35,
                                              ),
                                            ),
                                            title: Text('Riscos detetatos'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 0, 16, 16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: colorscheme.outline,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(7)),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            7.0),
                                                    child:
                                                        Text('${user.codigo}'),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0),
                                                  child: Text(
                                                      'Último risco detetado em ${user.codigo}'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                  ),

                                  // Activities card
                                  Card(
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const ListTile(
                                            leading: Padding(
                                              padding: EdgeInsets.all(3.0),
                                              child: Icon(
                                                Icons.edit_note_outlined,
                                                size: 35,
                                              ),
                                            ),
                                            title:
                                                Text('Atividades concluídas'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 0, 16, 16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: colorscheme.outline,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(7)),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            7.0),
                                                    child:
                                                        Text('${user.codigo}'),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0),
                                                  child: Text(
                                                      'Última atividade concluída 3 dias atrás'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    child: Text(
                      'Resumo Semanal',
                      style: TextStyle(color: colorscheme.background),
                    ),
                  ),
                )
              ],
            );

            // No data
          } else {
            page = Center(
              child: Column(
                children: const [
                  Text('Ocorreu um erro'),
                  Text('Por favor tente novamente'),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            );
          }
          return page;
        },
      ),
    );
  }
}
