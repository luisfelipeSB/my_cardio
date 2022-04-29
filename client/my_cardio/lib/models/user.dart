class User {
  final int code;
  final String sex;
  final DateTime birthDate;

  User({
    required this.code,
    required this.sex,
    required this.birthDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      code: json['codigo'],
      sex: json['sexo'],
      birthDate: json['data_nascimento'],
    );
  }
}
