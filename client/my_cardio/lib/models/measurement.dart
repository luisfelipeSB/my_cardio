class Measurement {
  //final int medidaid;
  //final String acto_medico;
  final DateTime instante;
  //final String dispositivo;
  //final String tipo_medida;
  //final String unidades;
  final double valor;

  Measurement({
    //required this.medidaid,
    //required this.acto_medico,
    required this.instante,
    //required this.dispositivo,
    //required this.tipo_medida,
    //required this.unidades,
    required this.valor,
  });

  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
      //medidaid: json['medidaid'],
      //acto_medico: json['acto_medico'],
      instante: DateTime.parse(json['instante'].toString()),
      //dispositivo: json['dispositivo'],
      //tipo_medida: json['tipo_medida'],
      //unidades: json['unidades'],
      valor: double.parse(json['valor']),
    );
  }

  Map<String, dynamic> toJson() => {
        //'medidaid': medidaid,
        //'acto_medico': acto_medico,
        'instante': instante,
        //'dispositivo': dispositivo,
        //'tipo_medida': tipo_medida,
        //'unidades': unidades,
        'valor': valor,
      };
}
