import 'package:flutter/material.dart';
import 'package:my_cardio/common/apiChecklist.dart';

import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/sharedPreferences.dart';

class CreateItem extends StatefulWidget {
  const CreateItem({Key? key}) : super(key: key);

  @override
  _CreateItemState createState() => _CreateItemState();
}

class _CreateItemState extends State<CreateItem> {
  final itemNameController = TextEditingController();
  checklistApiMethods checklistAPI = checklistApiMethods();

  String usercode = '';
  late String selectedTag;

  @override
  void initState() {
    selectedTag = "Exercise";
    super.initState();
   }

  @override
  Widget build(BuildContext context) {

    MySharedPreferences.instance
        .getStringValue("usercode")
        .then((value) => setState(() {
              usercode = value;
            }));
            
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add item'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: itemNameController,
              decoration: const InputDecoration(hintText: 'Item name'),
            ),
            DropdownButtonFormField(
              items: <String>[
                'Exercise',
                'Build a skill',
                'Family & friends',
                'Me time',
                'Organize'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              value: selectedTag,
              onChanged: (String? value) {
                selectedTag = value!;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                bool response =
                    await checklistAPI.createData(itemNameController.text,selectedTag,usercode);

                if (response) {
                  Navigator.pop(context);
                } else {
                  const SnackBar(content: Text('Failed to add item'));
                }
              },
              child: const Text('Inserir'),
            ),
          ],
        ),
      ),
    );
  }
}
