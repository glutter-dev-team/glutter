/// Represents values from Glances-API for Sensors.
class Sensor {
    /// Name of the specified sensor.
    String label;

    /// Value of the specified sensor.
    double value;

    /// Unit of the value.
    String unit;

    /// Type of the sensor.
    String type;

    String key;

    /// Constructor for Sensor-Objects.
    Sensor(String label, double value, String unit, String type, String key) {
        this.label = label;
        this.value = value;
        this.unit = unit;
        this.type = type;
        this.key = key;
    }

    /// For deserialization of JSON and conversion to Sensor-Object.
    factory Sensor.fromJson(dynamic json) {
        return Sensor(
            json['label'] as String,
            json['value'] as double,
            json['unit'] as String,
            json['type'] as String,
            json['key'] as String
        );
    }
}