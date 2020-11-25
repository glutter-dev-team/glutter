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
    List<String> list = new List<String>();

    json.forEach((plugin) => list.add(plugin.toString()));
    return new PluginsList(list);
  }
}