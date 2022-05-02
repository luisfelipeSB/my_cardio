import 'package:flutter/material.dart';
import 'package:my_cardio/main.dart';
import 'package:my_cardio/screens/home.dart';

import '../common/apiUser.dart';
import '../common/sharedPreferences.dart';
import '../models/user.dart';

import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController patientCodeController = TextEditingController();
  TextEditingController patientLoginController = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  UserApiMethods userAPI = UserApiMethods();

  /*Future<User> _login(user) async => await userAPI.login(user);*/

  /*bool _validateCredentialsFormat(code, password) {
    // TODO password length?
    if (password.length != 4) return false;
    if (code == null) return false;
    return double.tryParse(code) != null;
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          height: 240,
                        ),
                      ),

                      // User field
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: patientCodeController,
                          decoration: InputDecoration(
                            labelText: 'Enter your patient code...',
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
                          controller: patientLoginController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Enter your password...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),

                      // Button
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
                            final String password = patientLoginController.text;

                            bool response = await userAPI.login(code,password);

                            if(response) {
                                MySharedPreferences.instance.setStringValue("usercode", code);
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (BuildContext context, _, __) {
                                      return const Scaffold(body: HomePage());
                                    },
                                    /*settings: RouteSettings(arguments: code),*/
                                  ),
                                );
                            } else {
                                showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Incorrect credentials'),
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
                            /*
                            // Validating format
                            if (_validateCredentialsFormat(code, password)) {
                              User user = await _login(usr);

                              // Logging in
                              if (user.code == int.parse(code)) {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (BuildContext context, _, __) {
                                      return const Scaffold(body: HomePage());
                                    },
                                    settings: RouteSettings(arguments: user),
                                  ),
                                );
                              }
                            
                              // TODO Showing error message
                            } else {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Incorrect credentials'),
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
                            }*/
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 20),
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
