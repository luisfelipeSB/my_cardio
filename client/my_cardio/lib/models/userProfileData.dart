class UserProfileData {
  final int codigo;
  //final String nome;
  final String sexo;
  final DateTime data_nascimento;

  UserProfileData({
    required this.codigo,
    //required this.nome,
    required this.sexo,
    required this.data_nascimento,
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    UserProfileData user = UserProfileData(
      codigo: json['codigo'] as int,
      //nome: json['nome'] as String,
      sexo: json['sexo'] as String,
      data_nascimento: DateTime.parse(json['data_nascimento'].toString()),
    );
    return user;
  }

  Map<String, dynamic> toJson() => {
        'codigo': codigo,
        //'nome': nome,
        'sexo': sexo,
        'data_nascimento': data_nascimento,
      };
}
