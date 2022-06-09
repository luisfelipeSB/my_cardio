// ignore_for_file: non_constant_identifier_names

class UserProfileData {
  final int codigo;
  final String sexo;
  final DateTime data_nascimento;
  final String nome;
  final String tipo_sanguineo;
  final String peso;
  final String altura;

  const UserProfileData._(
    this.codigo,
    this.sexo,
    this.data_nascimento,
    this.nome,
    this.tipo_sanguineo,
    this.peso,
    this.altura,
  );

  // Building user depending on what we get
  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData._(
      json['codigo'],
      json['sexo'],
      DateTime.parse(json['data_nascimento'].toString()),
      json['nome'] ?? '',
      json['tipo_sanguineo'] ?? '',
      json['peso']?.substring(0, 7) ?? '',
      json['altura']?.substring(0, 7) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'codigo': codigo,
        'nome': nome,
        'data_nascimento': data_nascimento,
        'sexo': sexo,
        'tipo_sanguineo': tipo_sanguineo,
        'peso': peso,
        'altura': altura,
      };
}
