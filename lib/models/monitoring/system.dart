/// Represents the System values from the Glances-API.
class System {
  /// Constructor for JSON-Decoding.
  System(
      String osName,
      String hostname,
      String platform,
      String linuxDistro,
      String osVersion,
      String hrName) {
    this.osName = osName;
    this.hostname = hostname;
    this.platform = platform;
    this.linuxDistro = linuxDistro;
    this.osVersion = osVersion;
    this.hrName = hrName;
  }

  /// Name of the OS e.g. "Linux"
  String osName;

  /// Hostname
  String hostname;

  /// System-Architecture e.g. "64 Bit"
  String platform;

  /// Linux-Distribution e.g. "Ubuntu 20.04."
  String linuxDistro;

  /// Specific OS-Version
  String osVersion;

  /// Common OS-Name with distribution and architecture
  String hrName;

  /// For deserialization of JSON and conversion to System-Object.
  factory System.fromJson(Map json) {
    return System(
        json['os_name'],
        json['hostname'],
        json['platform'],
        json['linux_distro'],
        json['os_version'],
        json['hr_name']);
  }

  /// Creates a map from the System-Object. For storing the object in the database.
  Map<String, dynamic> toMap() {
    return {
      'osName': this.osName,
      'hostname': this.hostname,
      'platform': this.platform,
      'linuxDistro': this.linuxDistro,
      'osVersion': this.osVersion,
      'hrName': this.hrName,
    };
  }
}
