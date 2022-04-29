import 'package:flutter/material.dart';
import 'package:my_cardio/common/apiChecklist.dart';

class UpdateItem extends StatefulWidget {
  const UpdateItem({Key? key}) : super(key: key);

  @override
  _UpdateItemState createState() => _UpdateItemState();
}

class _UpdateItemState extends State<UpdateItem> {
  final itemNameController = TextEditingController();
  checklistApiMethods checklistAPI = checklistApiMethods();

  @override
  Widget build(BuildContext context) {
    final String itemId = ModalRoute.of(context)!.settings.arguments.toString();
    print(itemId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update item'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: itemNameController,
              decoration: const InputDecoration(hintText: 'New item name'),
            ),
            ElevatedButton(
              onPressed: () async {
                bool response = await checklistAPI.updateData(
                    itemId, itemNameController.text);

                if (response) {
                  Navigator.pop(context);
                } else {
                  const SnackBar(content: Text('Failed to add item'));
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
