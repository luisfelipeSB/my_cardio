import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:my_cardio/common/apiUser.dart';
import 'package:my_cardio/common/sharedPreferences.dart';
import 'package:my_cardio/models/userProfileData.dart';
import 'package:my_cardio/models/userStatsSummary.dart';
import 'package:my_cardio/screens/login.dart';
import 'package:my_cardio/screens/profile/edit_profile.dart';

import 'package:toggle_switch/toggle_switch.dart';

import 'dart:developer';

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
    return await userAPI.getMedicalRecord(usercode);
  }

  @override
  Widget build(BuildContext context) {
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
                    child: Text('Espere um momento...'),
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
            log(user!.toJson().toString());

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
                                minWidth: 45.0,
                                minHeight: 45.0,
                                cornerRadius: 25.0,
                                totalSwitches: 2,
                                icons: const [
                                  Icons.light_mode,
                                  Icons.dark_mode,
                                ],
                                iconSize: 30.0,
                                activeBgColors: [
                                  [colorscheme.tertiary],
                                  [colorscheme.primary],
                                ],
                                curve: Curves.bounceInOut,
                                onToggle: (mode) async {
                                  // 0 = light; 1 = dark
                                  log('theme toggled $mode');
                                  await MySharedPreferences.instance
                                      .setStringValue("theme", mode.toString());
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
                                    MySharedPreferences.instance
                                        .removeValue("usercode");
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

                        // Medical records title
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text(
                            'Ficha médica',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),

                        // Medical records 1
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
                                    Text(user.nome!)
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

                        // Medical records 2
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
                                    Text(user.tipo_sanguineo!)
                                  ],
                                ),
                                Divider(color: colorscheme.inverseSurface),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Altura'),
                                    Text('${user.altura}')
                                  ],
                                ),
                                Divider(color: colorscheme.inverseSurface),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Peso'),
                                    Text('${user.peso}')
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const Scaffold(body: EditProfilePage()),
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
                    onPressed: () async {
                      final res = await userAPI.getStatsSummary(usercode);

                      // Success
                      if (res.runtimeType == UserStatsSummary) {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            context: context,
                            builder: (BuildContext bc) {
                              return bottomSheet(colorscheme, res);
                            });
                        // Network or server error
                      } else if (res.runtimeType == ClientException) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Erro de rede ou servidor'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                          barrierDismissible: true,
                        );
                      } else {
                        log('idk');
                      }
                    },
                    child: Text(
                      'Resumo de Dados Coletados',
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

  // Bottom sheet content
  Widget bottomSheet(colorscheme, stats) {
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
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Icon(
              Icons.minimize_rounded,
              size: 20,
              color: Colors.grey,
            ),
          ),

          // Title
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14.0),
            child: Text(
              'Resumo dos seus dados',
              style: TextStyle(fontSize: 20),
            ),
          ),

          // Measurements card
          Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                leading: const Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.insights,
                    size: 35,
                  ),
                ),
                title: const Text('Medições'),
                subtitle: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    'Coletadas pelos dispositivos ${stats.remoteDevices.toString().substring(1, stats.remoteDevices.toString().length - 1)}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: colorscheme.outline,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(7)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Text('${stats.totalMeasurements}'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                          'Última medição: ${DateFormat('d/M/y').add_jm().format(stats.lastMeasurement)}'),
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
                    Icons.emergency_outlined,
                    size: 35,
                  ),
                ),
                title: Text('Riscos detetados'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: colorscheme.outline,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(7)),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Text('${stats.totalMeasurementFlags}')),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                          'Última medição: ${DateFormat('d/M/y').add_jm().format(stats.lastMeasurementFlag)}'),
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
                title: Text('Atividades concluídas'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: colorscheme.outline,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(7)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Text('${stats.activitiesCompleted}'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          stats.activitiesCompleted > 0
                              ? 'Bom trabalho! Continue assim.'
                              : 'Não se esqueça de dedicar tempo a si mesmo!',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
