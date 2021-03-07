import 'package:glutter/utils/utils.dart';

/// Represents List of installed Glances-plugins on the server
class PluginsList {
  /// Constructor for pluginsList
  PluginsList(List<String> installedPlugins) {
    this.installedPlugins = installedPlugins;
  }

  /// List of installed Glances-plugins on the server
  List<String> installedPlugins;

  /// For deserialization of JSON and conversion to PluginsList-Object.
  factory PluginsList.fromJson(dynamic json) {
    List<String> list = [];

    json.forEach((plugin) => list.add(plugin.toString()));
    return new PluginsList(list);
  }
}

/// An enum with the names of all possible Glances plugins.
enum PluginsListOption {
  load,
  core,
  uptime,
  fs,
  memswap,
  monitor,
  percpu,
  mem,
  sensors,
  system,
  alert,
  psutilversion,
  processlist,
  diskio,
  hddtemp,
  processcount,
  batpercent,
  now,
  cpu,
  network,
  help
}

extension PluginsListOptionExtension on PluginsListOption {
  String get value {
    return getEnumOptionAsString(this);
  }
}