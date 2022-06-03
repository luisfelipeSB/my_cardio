import 'dart:convert';
import 'dart:developer';

class UserStatsSummary {
  final int? totalMeasurements;
  final DateTime? lastMeasurement;
  final List<String>? remoteDevices;
  final int? activitiesCompleted;

  UserStatsSummary([
    this.totalMeasurements,
    this.lastMeasurement,
    this.remoteDevices,
    this.activitiesCompleted,
  ]);

  factory UserStatsSummary.fromJson(Map<String, dynamic> json) {
    int tm = int.parse(json['totalMeasurements']);
    DateTime lm = DateTime.parse(json['lastMeasurement'].toString());
    List<String> rd = [];
    for (final device in json['remoteDevices']) {
      rd.add(device['description']);
    }
    int ac = int.parse(json['activitiesCompleted']);
    return UserStatsSummary(
      tm,
      lm,
      rd,
      ac,
    );
  }
}
