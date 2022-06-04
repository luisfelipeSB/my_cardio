import 'package:flutter/material.dart';

import 'package:my_cardio/common/apiChecklist.dart';
import 'package:my_cardio/screens/activities/create_item.dart';
import 'package:my_cardio/screens/activities/update_item.dart';
import 'package:my_cardio/models/checklistItem.dart';

import '../../common/sharedPreferences.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({Key? key}) : super(key: key);

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final itemNameController = TextEditingController();
  ChecklistApiMethods checklistAPI = ChecklistApiMethods();

  late Future<List<ChecklistItem>> _myFuture;
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

  Future<List<ChecklistItem>> getData(String usercode) async {
    return await checklistAPI.getData(usercode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,

      // App Bar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          leading: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          title: const Padding(
              padding: EdgeInsets.only(top: 20), child: Text('Actividades')),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
              child: Image.asset('assets/images/logo-horiz-alt.png',
                  width: 100, height: 80, fit: BoxFit.contain),
            ),
          ],
        ),
      ),

      // Activity list
      body: FutureBuilder(
        future: _myFuture,
        builder: (BuildContext context,
            AsyncSnapshot<List<ChecklistItem>> snapshot) {
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
                    child: Text('A buscar sua lista...'),
                  ),
                ],
              ),
            );

            // Error
          } else if (snapshot.hasError) {
            page = const Center(
              child: Text('Ocorreu um erro :('),
            );

            // Got data
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<ChecklistItem>? list = snapshot.data;
            page = ListView.builder(
              itemCount: list!.length,
              itemBuilder: (context, index) {
                // List item
                ChecklistItem item = list[index];

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
                            title: const Text('Deletar item'),
                            content: const Text('Tens certeza?'),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  bool response = await checklistAPI
                                      .deleteData(item.itemId.toString());

                                  if (response) {
                                    setState(() {
                                      _myFuture = getData(usercode);
                                    });
                                    Navigator.pop(context, true);
                                  } else {
                                    Navigator.pop(context, false);
                                  }
                                },
                                child: const Text('Sim'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: const Text('Não'),
                              ),
                            ],
                          );
                        },
                      );
                    },

                    // Item tile
                    child: CheckboxListTile(
                      title: Text(list[index].itemName),
                      subtitle: Text(list[index].itemTag),
                      secondary: const Icon(Icons.keyboard_arrow_left),
                      tileColor: Theme.of(context).colorScheme.onSecondary,
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
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                      builder: (context) => const UpdateItem(),
                      settings: RouteSettings(arguments: [
                        list[index].itemId.toString(),
                        list[index].itemName.toString(),
                        list[index].itemTag.toString()
                      ]),
                    ))
                        .then((value) {
                      setState(() {
                        _myFuture = getData(usercode);
                      });
                    });
                  },
                );
              },
            );

            // No data
          } else {
            page = Center(
              child: Column(
                children: const [
                  Text('Lista vazia'),
                  Text('Selecione (+) para adicionar um item'),
                  Text('Mantenha um item pressionado para editá-lo'),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            );
          }
          return page;
        },
      ),

      // Adding an item
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
              builder: (context) => const CreateItem(),
            ))
                .then((value) {
              setState(() {
                _myFuture = getData(usercode);
              });
            });
          },
          child: const Icon(Icons.add),
          backgroundColor: Theme.of(context).colorScheme.tertiary),
    );
  }
}
