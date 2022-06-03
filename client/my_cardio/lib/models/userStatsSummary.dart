class UserStatsSummary {
  final int? totalMeasurements;
  final DateTime? lastMeasurement;
  final List<String>? remoteDevices;
  final int? activitiesCompleted;
  final int? totalMeasurementFlags;
  final DateTime? lastMeasurementFlag;

  UserStatsSummary(
      [this.totalMeasurements,
      this.lastMeasurement,
      this.remoteDevices,
      this.activitiesCompleted,
      this.totalMeasurementFlags,
      this.lastMeasurementFlag]);

  factory UserStatsSummary.fromJson(Map<String, dynamic> json) {
    int tm = int.parse(json['totalMeasurements']);
    DateTime lm = DateTime.parse(json['lastMeasurement'].toString());
    List<String> rd = [];
    for (final device in json['remoteDevices']) {
      rd.add(device['description']);
    }
    int ac = int.parse(json['activitiesCompleted']);
    int tmf = int.parse(json['totalMeasurementFlags']);
    DateTime lmf = DateTime.parse(json['lastMeasurementFlag'].toString());
    return UserStatsSummary(
      tm,
      lm,
      rd,
      ac,
      tmf,
      lmf,
    );
  }
}
