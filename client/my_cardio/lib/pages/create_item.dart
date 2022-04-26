import 'package:flutter/material.dart';
import 'package:my_cardio/repositories/item_repos.dart';

class CreateItem extends StatefulWidget {
  const CreateItem({Key? key}) : super(key: key);

  @override
  _CreateItemState createState() => _CreateItemState();
}

class _CreateItemState extends State<CreateItem> {
  final itemNameController = TextEditingController();
  ItemRepository itemrepository = ItemRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Inserir item'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.popAndPushNamed(context, 'home');
            },
          )),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: itemNameController,
              decoration: InputDecoration(hintText: 'Nome do item'),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  bool response =
                      await itemrepository.createData(itemNameController.text);

                  if (response) {
                    Navigator.popAndPushNamed(context, 'home');
                  } else {
                    //throw Exception('Failed to create item');
                    Navigator.popAndPushNamed(context, 'home');
                  }
                },
                child: Text('Inserir'))
          ],
        ),
      ),
    );
  }
}
