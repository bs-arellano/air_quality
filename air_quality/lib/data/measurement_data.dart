class Measurement {
  final DateTime date;
  final double value;

  Measurement({
    required this.date,
    required this.value,
  });

  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
      date: DateTime.parse(json['date']),
      value: json['value'].toDouble(),
    );
  }
}

class MeasurementList {
  final List<Measurement> measurements;

  MeasurementList({
    required this.measurements,
  });

  factory MeasurementList.fromJson(Map<String, dynamic> json) {
    var list = json['measurements'] as List;
    List<Measurement> measurementList =
        list.map((item) => Measurement.fromJson(item)).toList();

    return MeasurementList(measurements: measurementList);
  }
}
