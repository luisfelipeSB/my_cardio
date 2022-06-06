// ignore_for_file: non_constant_identifier_names

import 'package:my_cardio/common/constants.dart';

class MeasurementFlag {
  final int id;
  final String title;
  final String description;
  final String device;
  final String measurement_type;
  final DateTime instant;
  final double value;

  MeasurementFlag(this.id, this.title, this.description, this.device,
      this.measurement_type, this.instant, this.value);

  factory MeasurementFlag.fromJson(Map<String, dynamic> json) {
    int id = json['id'];
    String ti = json['measure_flag_title'];
    String ds = json['measure_flag_text'];
    String dv = json['device'];
    String mt = measure_types[json['measure_type']]!;
    DateTime dt = DateTime.parse(json['instant'].toString());
    double vl = double.parse(json['value']);
    return MeasurementFlag(
      id,
      ti,
      ds,
      dv,
      mt,
      dt,
      vl,
    );
  }
}
