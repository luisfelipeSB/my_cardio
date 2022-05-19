class Measurement {
  final int medidaid;
  final String acto_medico;
  final DateTime instante;
  final String dispositivo;
  final String tipo_medida;
  final String unidades;
  final double valor;

  Measurement({
    required this.medidaid,
    required this.acto_medico,
    required this.instante,
    required this.dispositivo,
    required this.tipo_medida,
    required this.unidades,
    required this.valor,
  });

  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
      medidaid: json['medidaid'],
      acto_medico: json['medidaid'],
      instante: json['medidaid'],
      dispositivo: json['medidaid'],
      tipo_medida: json['medidaid'],
      unidades: json['medidaid'],
      valor: json['medidaid'],
    );
  }
}
