class Measurement {
  final DateTime instante;
  final double valor;

  Measurement({
    required this.instante,
    required this.valor,
  });

  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
      instante: DateTime.parse(json['instante'].toString()),
      valor: double.parse(json['valor']),
    );
  }

  Map<String, dynamic> toJson() => {
        'instante': instante,
        'valor': valor,
      };
}
