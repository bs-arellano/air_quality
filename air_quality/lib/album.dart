class Album {
  final String name;
  final int value;
  final String unit;
  final int date;
  const Album(
      {required this.name,
      required this.value,
      required this.unit,
      required this.date});

  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String name,
        'value': int value,
        'unit': String unit,
        'date': int date,
      } =>
        Album(name: name, value: value, unit: unit, date: date),
      _ => throw const FormatException('Failed to load album'),
    };
  }
}
