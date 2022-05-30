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
  ChecklistApiMethods checklistAPI = ChecklistApiMethods();

  String usercode = '';
  late String selectedTag;

  @override
  void initState() {
    selectedTag = "Exercício";
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
        title: const Text(
          'Adicionar item',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: itemNameController,
              decoration: const InputDecoration(hintText: 'Título'),
            ),
            DropdownButtonFormField(
              items: <String>[
                'Exercício',
                'Desenvolver habilidade',
                'Família e amigos',
                'Atividae pessoal',
                'Organizar a vida'
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  bool response = await checklistAPI.createData(
                      itemNameController.text, selectedTag, usercode);

                  if (response) {
                    Navigator.pop(context);
                  } else {
                    const SnackBar(content: Text('Falha ao adicionar item'));
                  }
                },
                child: const Text('Inserir',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
