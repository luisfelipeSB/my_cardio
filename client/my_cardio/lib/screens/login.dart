import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:my_cardio/main.dart';
import 'package:my_cardio/screens/home.dart';
import 'package:my_cardio/screens/profile.dart';

import '../common/apiUser.dart';
import '../common/sharedPreferences.dart';
import '../models/userProfileData.dart';

import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController patientCodeController = TextEditingController();
  TextEditingController patientPassController = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  UserApiMethods userAPI = UserApiMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 70),
            width: MediaQuery.of(context).size.width * 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Form(
                  key: _loginFormKey,
                  child: Column(
                    children: [
                      // Logo
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Image.asset(
                          'assets/images/logo-alt.png',
                          height: 200,
                        ),
                      ),

                      // User field
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: patientCodeController,
                          decoration: InputDecoration(
                            labelText: 'Código de paciente',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),

                      // Password field
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: patientPassController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),

                      // Login button
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(160, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),

                          // Verifying credentials
                          onPressed: () async {
                            final String code = patientCodeController.text;
                            final String password = patientPassController.text;

                            var res = await userAPI.login(code, password);

                            if (res.runtimeType == bool && res) {
                              await MySharedPreferences.instance
                                  .setStringValue("usercode", code);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              );
                            } else if (res.runtimeType == ClientException) {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Erro de servidor'),
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
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Credenciais inválidas'),
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
                            }
                          },
                          child: const Text(
                            'Entrar',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
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
