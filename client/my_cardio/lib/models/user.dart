class User {
  final int codigo;
  //final String nome;
  final String sexo;
  final DateTime data_nascimento;

  User({
    required this.codigo,
    //required this.nome,
    required this.sexo,
    required this.data_nascimento,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    User user = User(
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
