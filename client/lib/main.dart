import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mycardio_client/repository/item_repos.dart';
import 'package:mycardio_client/screens/create_item.dart';
import 'package:mycardio_client/screens/update_item.dart';

import 'model/item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChecklistPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        'home' : (context) => ChecklistPage(),
        'create' : (context) => CreateItem(),
        'update' : (context) => UpdateItem()
      },
    );
  }
}

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({ Key? key }) : super(key: key);

  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {

  ItemRepository itemrepository = ItemRepository();
  List<Item> listItem = [];
  

  getData() async {
    listItem = await itemrepository.getData();
    setState(() {
      
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Checklist"),
      ),
      body: ListView.builder(
        itemCount: listItem.length,
        itemBuilder: (context, index) {
        Item item = listItem[index];
        return InkWell(
          onLongPress: () => {
	 Navigator.popAndPushNamed(context, 'update', arguments: [
              item.itemId.toString(),
              item.itemName,
            ])
          },
          child: Dismissible(
            key: Key(item.itemId.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal:30),
              child: Icon(Icons.delete),
              ),
            confirmDismiss: (direction) {
              return showDialog(
                context: context,
                builder: (context) {
                return AlertDialog(
                  title: Text('Apagar item'),
                  content: Text('Tem a certeza?'),
                  actions: [
                    TextButton(onPressed: () async {
                      bool response = await itemrepository.deleteData(item.itemId.toString());
                      if(response) {
                        Navigator.pop(context, true);
                      } else {
                        Navigator.pop(context, false);
                      }
                    }, child: Text('Sim')),
                    TextButton(onPressed: () {
                      Navigator.pop(context, false);
                    }, child: Text('Não'))
                  ],
                );
              },
            );
            },
            child: CheckboxListTile (
              title: Text(
                listItem[index].itemName,
              ),
              controlAffinity: ListTileControlAffinity.leading,
              value: listItem[index].itemCheck,
              onChanged: (val) {
                itemrepository.updateCheck(listItem[index].itemId.toString());
                setState(() {
                  listItem[index].itemCheck = val!;
               },
              );
            },
          ),
            /*child: ListTile(
              leading: Container(
              width: 60,
              height: 60,
            ),
            title: Text('${item.itemName}'),
            ),*/
          ),
        );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.popAndPushNamed(context, 'create');
        },
        child: Icon(Icons.add),
        ),
    );
  }






}


