import 'package:flutter/material.dart';
import 'package:mycardio_client/model/Item.dart';
import 'package:mycardio_client/repository/item_repos.dart';

class UpdateItem extends StatefulWidget {
  const UpdateItem({ Key? key }) : super(key: key);

  @override
  _UpdateItemState createState() => _UpdateItemState();
}

class _UpdateItemState extends State<UpdateItem> {
  final itemNameController = TextEditingController();
  ItemRepository itemrepository = ItemRepository();

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)?.settings.arguments as List<String>;
    if(args[1].isNotEmpty) {
      itemNameController.text = args[1];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Atualizar item'),
        leading: IconButton(icon:Icon(Icons.arrow_back),
          onPressed: () {
          Navigator.popAndPushNamed(context, 'home');
        },
        )
        ),
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
              ElevatedButton(onPressed: () async {
                bool response = await itemrepository.updateData(
                  args[0],
                  itemNameController.text);

                  if(response) {
                    Navigator.popAndPushNamed(context, 'home');
                  } else {
                    throw Exception('Failed to update item');
                  }

              }, child: Text('Atualizar'))
            ],
          ),
          ),
    );
  }
}