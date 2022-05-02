import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:my_cardio/common/apiChecklist.dart';
import 'package:my_cardio/screens/activities/create_item.dart';
import 'package:my_cardio/screens/activities/update_item.dart';
import 'package:my_cardio/models/item.dart';

<<<<<<< HEAD
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/sharedPreferences.dart';

=======
>>>>>>> 89668093c0bf086f25b4c438b461f14915e6e73d
class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({Key? key}) : super(key: key);

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final itemNameController = TextEditingController();
  checklistApiMethods checklistAPI = checklistApiMethods();

<<<<<<< HEAD
  late Future<List<Item>> _myFuture;
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

   Future<List<Item>> getData(String usercode) async {
       return await checklistAPI.getData(usercode);
  }

  @override
  Widget build(BuildContext context) {
=======
  Future<List<Item>> getData() async => await checklistAPI.getData();

  @override
  Widget build(BuildContext context) {
    print('build');
>>>>>>> 89668093c0bf086f25b4c438b461f14915e6e73d

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          title: const Padding(
              padding: EdgeInsets.only(top: 20), child: Text('My Activities')),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
              child: Image.asset('assets/images/logo-horiz.png',
                  width: 100, height: 80, fit: BoxFit.contain),
            ),
          ],
        ),
      ),

      // Activity list
      body: FutureBuilder(
<<<<<<< HEAD
        future: _myFuture,
=======
        future: getData(),
>>>>>>> 89668093c0bf086f25b4c438b461f14915e6e73d
        builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
          Widget page;

          // Waiting to get items
          if (snapshot.connectionState == ConnectionState.waiting) {
            page = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text('Fetching your checklist...'),
                  ),
                ],
              ),
            );

            // Error
          } else if (snapshot.hasError) {
            page = const Center(
              child: Text('An error occurred :('),
            );

            // Got data
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Item>? list = snapshot.data;
            page = ListView.builder(
              itemCount: list!.length,
              itemBuilder: (context, index) {
                // List item
                Item item = list[index];

                return InkWell(
                  // Deleting an item
                  child: Dismissible(
                    key: UniqueKey(), // Not sure about this
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: const Icon(Icons.delete),
                    ),
                    confirmDismiss: (direction) {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Delete item'),
                            content: const Text('Are you sure?'),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  bool response = await checklistAPI
                                      .deleteData(item.itemId.toString());

                                  if (response) {
<<<<<<< HEAD
                                    setState(() {
      _myFuture = getData(usercode);
    });
=======
>>>>>>> 89668093c0bf086f25b4c438b461f14915e6e73d
                                    Navigator.pop(context, true);
                                  } else {
                                    Navigator.pop(context, false);
                                  }
                                },
                                child: const Text('Yes'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: const Text('No'),
                              ),
                            ],
                          );
                        },
                      );
                    },

                    // Item tile
                    child: CheckboxListTile(
                      title: Text(list[index].itemName),
<<<<<<< HEAD
                      subtitle: Text(list[index].itemTag),
=======
                      subtitle: Text('[Tag]'),
>>>>>>> 89668093c0bf086f25b4c438b461f14915e6e73d
                      secondary: const Icon(Icons.keyboard_arrow_left),
                      tileColor: Theme.of(context).colorScheme.surfaceVariant,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: list[index].itemCheck,
                      onChanged: (val) async {
                        bool response = await checklistAPI
                            .updateCheck(list[index].itemId.toString());

                        if (response) {
                          setState(
                            () {
                              list[index].itemCheck = val!;
                            },
                          );
                        }
                      },
                    ),
                  ),

                  // Editing an item
                  onLongPress: () {
<<<<<<< HEAD
                    Navigator.of(context)
  .push(MaterialPageRoute(
     builder: (context) => UpdateItem(),
      settings: RouteSettings(arguments: [ list[index].itemId.toString(),
                        list[index].itemName.toString(),
                        list[index].itemTag.toString()
                        ]),
  ))
  .then((value) {
    setState(() {
      _myFuture = getData(usercode);
    });
  });
=======
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (BuildContext context, _, __) {
                          return const UpdateItem();
                        },
                        settings: RouteSettings(arguments: list[index].itemId),
                      ),
                    );
>>>>>>> 89668093c0bf086f25b4c438b461f14915e6e73d
                  },
                );
              },
            );

            // No data
          } else {
            page = Center(
              child: Column(children: const [
                Text('No items'),
                Text('Add an item by selecting (+)'),
                Text('Long press an item to edit it'),
              ]),
            );
          }
          return page;
        },
      ),

      // Adding an item
      floatingActionButton: FloatingActionButton(
        onPressed: () {
<<<<<<< HEAD
         Navigator.of(context)
  .push(MaterialPageRoute(
     builder: (context) => CreateItem(),
  ))
  .then((value) {
    setState(() {
      _myFuture = getData(usercode);
    });
  });
=======
          Navigator.push(context, PageRouteBuilder(
            pageBuilder: (BuildContext context, _, __) {
              return const CreateItem();
            },
          ));
>>>>>>> 89668093c0bf086f25b4c438b461f14915e6e73d
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
