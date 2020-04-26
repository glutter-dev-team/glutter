import "unit.dart";

/// Represents values from Glances-API for Sensors.
class Sensor {
  /// Name of the specified sensor.
  String label;

  /// Value of the specified sensor.
  double value;

  /// Unit of the value.
  Unit unit;

  /// Type of the sensor.
  String type;

  String key;
}