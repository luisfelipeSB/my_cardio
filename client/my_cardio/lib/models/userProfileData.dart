// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:my_cardio/common/constants.dart';

class UserProfileData {
  final int codigo;
  final String sexo;
  final DateTime data_nascimento;
  final String? nome;
  final String? tipo_sanguineo;
  final double? peso;
  final double? altura;

  UserProfileData(
    this.codigo,
    this.sexo,
    this.data_nascimento, [

    // DEMO ONLY (optional default values)
    this.nome = DEFULT_NAME,
    this.tipo_sanguineo = 'AB+',
    this.peso = 91.25,
    this.altura = 1.76,
  ]);

  // Building user depending on what we get
  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    UserProfileData user;
    if (json['nome'] != null &&
        json['tipo_sanguineo'] != null &&
        json['peso'] != null &&
        json['altura'] != null) {
      user = UserProfileData(
        json['codigo'] as int,
        json['sexo'] as String,
        DateTime.parse(json['data_nascimento'].toString()),
        json['nome'] as String,
        json['tipo_sanguineo'] as String,
        json['peso'] as double,
        json['altura'] as double,
      );
    } else {
      user = UserProfileData(
        json['codigo'] as int,
        json['sexo'] as String,
        DateTime.parse(json['data_nascimento'].toString()),
      );
    }

    return user;
  }

  Map<String, dynamic> toJson() => {
        'codigo': codigo,
        'nome': nome,
        'sexo': sexo,
        'tipo_sanguineo': tipo_sanguineo,
        'peso': peso,
        'altura': altura,
        'data_nascimento': data_nascimento,
      };
}
