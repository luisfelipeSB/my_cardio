import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_cardio/repositories/item_repos.dart';
import 'package:my_cardio/pages/create_item.dart';
import 'package:my_cardio/pages/update_item.dart';
import 'package:my_cardio/models/item.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({Key? key}) : super(key: key);

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ItemRepository itemrepository = ItemRepository();
  List<Item> list = [];

  getData() async {
    list = await itemrepository.getData();
    list.sort((a, b) {
      if (a.itemCheck == b.itemCheck) return 0;
      if (a.itemCheck) return 1;
      return -1;
    });
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          Item item = list[index];
          return InkWell(
            onLongPress: () => {
              Navigator.popAndPushNamed(context, 'update', arguments: [
                item.itemId.toString(),
                item.itemName,
              ]),
            },
            child: Dismissible(
              key: Key(item.itemId.toString()),
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
                            bool response = await itemrepository
                                .deleteData(item.itemId.toString());
                            if (response) {
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
              child: CheckboxListTile(
                title: Text(list[index].itemName),
                subtitle: Text('[Tag]'),
                secondary: const Icon(Icons.keyboard_arrow_left),
                tileColor: Theme.of(context).colorScheme.surfaceVariant,
                controlAffinity: ListTileControlAffinity.leading,
                value: list[index].itemCheck,
                onChanged: (val) {
                  itemrepository.updateCheck(list[index].itemId.toString());
                  setState(
                    () {
                      list[index].itemCheck = val!;
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.popAndPushNamed(context, 'create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
