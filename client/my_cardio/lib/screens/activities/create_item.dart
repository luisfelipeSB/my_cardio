import 'package:flutter/material.dart';
import 'package:my_cardio/common/apiChecklist.dart';

<<<<<<< HEAD
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/sharedPreferences.dart';

=======
>>>>>>> 89668093c0bf086f25b4c438b461f14915e6e73d
class CreateItem extends StatefulWidget {
  const CreateItem({Key? key}) : super(key: key);

  @override
  _CreateItemState createState() => _CreateItemState();
}

class _CreateItemState extends State<CreateItem> {
  final itemNameController = TextEditingController();
  checklistApiMethods checklistAPI = checklistApiMethods();

<<<<<<< HEAD
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
            
=======
  @override
  Widget build(BuildContext context) {
>>>>>>> 89668093c0bf086f25b4c438b461f14915e6e73d
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
<<<<<<< HEAD
              value: selectedTag,
              onChanged: (String? value) {
                selectedTag = value!;
              },
=======
              onChanged: (String? value) {},
>>>>>>> 89668093c0bf086f25b4c438b461f14915e6e73d
            ),
            ElevatedButton(
              onPressed: () async {
                bool response =
<<<<<<< HEAD
                    await checklistAPI.createData(itemNameController.text,selectedTag,usercode);
=======
                    await checklistAPI.createData(itemNameController.text);
>>>>>>> 89668093c0bf086f25b4c438b461f14915e6e73d

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
