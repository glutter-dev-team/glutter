/// Represents values from Glances-API for Sensors.
class Sensor {
  /// Constructor for Sensor-Objects, commonly used by Factory .fromJson.
  Sensor(String label, int value, String unit, String type, String key) {
    this.label = label;
    this.value = value;
    this.unit = unit;
    this.type = type;
    this.key = key;
  }

  /// Name of the specified sensor.
  String label;

  /// Value of the specified sensor.
  int value;

  /// Unit of the value.
  String unit;

  /// Type of the sensor.
  String type;

  String key;

  /// For deserialization of JSON and conversion to Sensor-Object.
  factory Sensor.fromJson(dynamic json) {
    return Sensor(
        json['label'] as String,
        json['value'] as int,
        json['unit'] as String,
        json['type'] as String,
        json['key'] as String
    );
  }
}
