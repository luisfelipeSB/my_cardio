import 'package:flutter/material.dart';
import 'package:my_cardio/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController passwordCreateController = TextEditingController();
  bool passwordCreateVisibility = false;
  TextEditingController passwordConfirmController = TextEditingController();
  bool passwordConfirmVisibility = false;
  TextEditingController emailAddressLoginController = TextEditingController();
  TextEditingController passwordLoginController = TextEditingController();
  bool passwordLoginVisibility = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print('login page');

    return Column(
      children: [
        Expanded(
          child: DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('MyCardio'),
                bottom: TabBar(
                  tabs: const [
                    Tab(text: 'Login'),
                    Tab(text: 'Register'),
                  ],
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                ),
              ),
              body: TabBarView(
                children: [
                  // Login
                  Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        // Name field
                        TextFormField(
                          controller: emailAddressController,
                          decoration: const InputDecoration(
                            labelText: 'Enter your name...',
                          ),
                        ),

                        // Password field
                        TextFormField(
                          controller: passwordLoginController,
                          decoration: const InputDecoration(
                            labelText: 'Enter your password...',
                          ),
                        ),

                        // Button
                        ElevatedButton(
                          onPressed: () async {
                            // TODO login user here
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const NavBar(initialPage: 'homePage'),
                              ),
                            );
                          },
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ),

                  // Register
                  Form(
                    key: _registerFormKey,
                    child: Column(
                      children: [
                        // Name field
                        TextFormField(
                          controller: emailAddressController,
                          decoration: const InputDecoration(
                            labelText: 'Enter your name...',
                          ),
                        ),

                        // Password field
                        TextFormField(
                          controller: passwordLoginController,
                          decoration: const InputDecoration(
                            labelText: 'Enter your password...',
                          ),
                        ),

                        // Confirm password
                        TextFormField(
                          controller: passwordLoginController,
                          decoration: const InputDecoration(
                            labelText: 'Confirm your password...',
                          ),
                        ),

                        // Button
                        ElevatedButton(
                          onPressed: () async {
                            // TODO login user here
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const NavBar(initialPage: 'homePage'),
                              ),
                            );
                          },
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
