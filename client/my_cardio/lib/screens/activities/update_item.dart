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
    var colorscheme = Theme.of(context).colorScheme;

    selectedTag = args[2];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Atualizar item',
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
              decoration: const InputDecoration(hintText: 'Novo título'),
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
                  minimumSize: const Size(160, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  bool response = await checklistAPI.updateData(
                      args[0], itemNameController.text, selectedTag);

                  if (response) {
                    Navigator.pop(context);
                  } else {
                    const SnackBar(content: Text('Falha ao atualizar item'));
                  }
                },
                child: const Text(
                  'Atualizar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
