class User {
  final int code;
  final String sex;
  final DateTime birthDate;
<<<<<<< HEAD
  final String dead;
=======
>>>>>>> 89668093c0bf086f25b4c438b461f14915e6e73d

  User({
    required this.code,
    required this.sex,
    required this.birthDate,
<<<<<<< HEAD
    required this.dead,
=======
>>>>>>> 89668093c0bf086f25b4c438b461f14915e6e73d
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      code: json['codigo'],
      sex: json['sexo'],
      birthDate: json['data_nascimento'],
<<<<<<< HEAD
      dead: json['falecido'],
=======
>>>>>>> 89668093c0bf086f25b4c438b461f14915e6e73d
    );
  }
}
