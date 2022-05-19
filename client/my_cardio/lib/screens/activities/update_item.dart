import 'package:flutter/material.dart';
import 'package:my_cardio/common/apiChecklist.dart';

import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateItem extends StatefulWidget {
  const UpdateItem({Key? key}) : super(key: key);

  @override
  _UpdateItemState createState() => _UpdateItemState();
}

class _UpdateItemState extends State<UpdateItem> {
  final itemNameController = TextEditingController();
  ChecklistApiMethods checklistAPI = ChecklistApiMethods();

  late String selectedTag;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as List<String>;
    if (args[1].isNotEmpty) {
      itemNameController.text = args[1];
    }

    selectedTag = args[2];

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
                bool response = await checklistAPI.updateData(
                    args[0], itemNameController.text, selectedTag);

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
