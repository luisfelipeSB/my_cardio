import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:badges/badges.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController nameController = TextEditingController();
  late String selectedBloodType;

  @override
  void initState() {
    selectedBloodType = "O+";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorscheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar perfil',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          children: [
            // Edit profile picture
            Padding(
              padding: const EdgeInsets.all(10),
              child: Badge(
                badgeContent: const Icon(Icons.edit),
                badgeColor: colorscheme.onPrimary,
                position: BadgePosition.bottomEnd(),

                // TODO dynamic value
                child: const Icon(
                  Icons.account_circle,
                  size: 130,
                ),
              ),
            ),
            const Text('Selecionar nova foto de perfil'),

            // Save
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),

                // TODO change profile icon
                onPressed: () async {
                  log('profile icon change');
                },
                child:
                    const Text('Salvar', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
