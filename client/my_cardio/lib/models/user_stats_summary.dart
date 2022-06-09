// Properties are strings because they are only ever printed to screen;
// properties are converted to their actual type before type-specific manipulation

class UserStatsSummary {
  final String totalMeasurements;
  final String lastMeasurement;
  final List<String> remoteDevices;
  final String activitiesCompleted;
  final String totalMeasurementFlags;
  final String lastMeasurementFlag;

  UserStatsSummary(
    this.totalMeasurements,
    this.lastMeasurement,
    this.remoteDevices,
    this.activitiesCompleted,
    this.totalMeasurementFlags,
    this.lastMeasurementFlag,
  );

  factory UserStatsSummary.fromJson(Map<String, dynamic> json) {
    final a = json['totalMeasurements'] ?? '';
    final b = json['lastMeasurement'] ?? '';

    final c = json['activitiesCompleted'] ?? '';
    final d = json['totalMeasurementFlags'] ?? '';
    final e = json['lastMeasurementFlag'] ?? '';

    List<String> rd = [];
    for (final device in json['remoteDevices']) {
      rd.add(device['description']);
    }

    return UserStatsSummary(
      json['totalMeasurements'] ?? '0',
      json['lastMeasurement'] ?? '',
      rd,
      json['activitiesCompleted'] ?? '0',
      json['totalMeasurementFlags'] ?? '0',
      json['lastMeasurementFlag'] ?? '',
    );
  }
}
