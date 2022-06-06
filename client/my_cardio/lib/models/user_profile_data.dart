// ignore_for_file: non_constant_identifier_names

class UserProfileData {
  final int codigo;
  final String sexo;
  final DateTime data_nascimento;
  final String nome;
  final String tipo_sanguineo;
  final double peso;
  final double altura;

  const UserProfileData._({
    required this.codigo,
    required this.sexo,
    required this.data_nascimento,
    required this.nome,
    required this.tipo_sanguineo,
    required this.peso,
    required this.altura,
  });

  // Building user depending on what we get
  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    final co = json['codigo'];
    final sx = json['sexo'];
    final dt = DateTime.parse(json['data_nascimento'].toString());

    final nm = json['nome'] ?? '';
    final ts = json['tipo_sanguineo'] ?? '';
    final ps = double.parse(json['peso'] ?? '0');
    final al = double.parse(json['altura'] ?? '0');

    return UserProfileData._(
      codigo: co,
      sexo: sx,
      data_nascimento: dt,
      nome: nm,
      tipo_sanguineo: ts,
      peso: ps,
      altura: al,
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
