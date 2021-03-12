import 'dart:convert';
import 'dart:io';

import 'package:glutter/models/monitoring/cpu.dart';
import 'package:glutter/models/monitoring/memory.dart';
import 'package:glutter/models/monitoring/network.dart';
import 'package:glutter/models/monitoring/pluginsList.dart';
import 'package:glutter/models/monitoring/sensor.dart';
import 'package:glutter/models/monitoring/system.dart';
import 'package:glutter/models/shared/profile.dart';
import 'package:http/http.dart';

/// Provides services to interact with the glances-Restful API.
class GlancesService {
  Profile server;

  /// Constructor for GlancesService-Objects.
  GlancesService(Profile server) {
    this.server = server;
  }

  /// Returns the CPU-Object of the current Server.
  Future<CPU> getCpu() async {
    Response rawResponse;
    CPU cpu;

    try {
      Uri uri = new Uri.http(server.getAuthorityWithPort(), server.getApiVersionPath() + "/cpu");
      rawResponse = await get(uri);
    } catch (_) {
      throw HttpException("Failed to load data from Server(" + server.getFullServerAddress() + ") to get CPU.");
    }

    cpu = CPU.fromJson(jsonDecode(rawResponse.body));
    cpu.timeStamp = DateTime.now();
    cpu.profileId = server.id;

    return cpu;
  }

  /// Returns the Memory-Object of the current Server.
  Future<Memory> getMemory() async {
    Response rawResponse;
    Memory memory;

    try {
      Uri uri = new Uri.http(server.getAuthorityWithPort(), server.getApiVersionPath() + "/mem");
      rawResponse = await get(uri);
    } catch (_) {
      throw HttpException("Failed to load data from Server(" + server.getFullServerAddress() + ") to get Memory.");
    }

    memory = Memory.fromJson(jsonDecode(rawResponse.body));

    return memory;
  }

  /// Returns list of Network-Objects from Glances for the current server.
  Future<List<Network>> getNetworks() async {
    Response rawResponse;

    try {
      Uri uri = new Uri.http(server.getAuthorityWithPort(), server.getApiVersionPath() + "/network");
      rawResponse = await get(uri);
    } catch (_) {
      throw HttpException("Failed to load data from Server(" + server.getFullServerAddress() + ") to get Networks.");
    }
    var networkObjectsJson = jsonDecode(rawResponse.body);

    List<Network> networkObjects = [];

    networkObjectsJson.forEach((networkJson) => networkObjects.add(Network.fromJson(networkJson)));

    return networkObjects;
  }

  /// Returns list of Sensor-Objects from Glances for the current server.
  Future<List<Sensor>> getSensors() async {
    Response rawResponse;

    try {
      Uri uri = new Uri.http(server.getAuthorityWithPort(), server.getApiVersionPath() + "/sensors");
      rawResponse = await get(uri);
    } catch (_) {
      throw HttpException("Failed to load data from Server(" + server.getFullServerAddress() + ") to get Sensors.");
    }
    var sensorObjectsJson = jsonDecode(rawResponse.body);

    List<Sensor> sensorObjects = [];

    sensorObjectsJson.forEach((sensorJson) => sensorObjects.add(Sensor.fromJson(sensorJson)));

    return sensorObjects;
  }

  /// Checks whether the connection to the glances-APi can be established and the required plugins are installed.
  Future<bool> connectionTest() async {
    Response rawResponse;

    try {
      Uri uri = new Uri.http(server.getAuthorityWithPort(), server.getApiVersionPath() + "/pluginslist");
      rawResponse = await get(uri);
    } catch (_) {
      throw HttpException(
          "Failed to load data from Server(" + server.getFullServerAddress() + ") to get pluginslist while testing connection.");
    }

    List<dynamic> pluginsList = jsonDecode(rawResponse.body);
    bool containsRequiredPlugins = false;

    var filteredPluginsList =
        pluginsList.where((element) => element == 'network' || element == 'cpu' || element == 'mem' || element == 'sensors');

    // All required plugins installed?
    containsRequiredPlugins = filteredPluginsList.length == 4;

    // If Response-Code is OK and required plugins are installed, return true.
    if (rawResponse.statusCode == 200 && containsRequiredPlugins) {
      return true;
    }

    // Otherwise return false.
    return false;
  }

  /// Returns the PluginsList-Object of the current Server.
  Future<PluginsList> getPluginsList() async {
    Response rawResponse;
    PluginsList pluginsList;

    try {
      Uri uri = new Uri.http(server.getAuthorityWithPort(), server.getApiVersionPath() + "/pluginslist");
      rawResponse = await get(uri);
    } catch (_) {
      throw HttpException("Failed to load data from Server(" + server.getFullServerAddress() + ") to get Plugins-List.");
    }

    pluginsList = PluginsList.fromJson(jsonDecode(rawResponse.body));

    return pluginsList;
  }

  /// Returns the System-Object of the current Server.
  Future<System> getSystem() async {
    Response rawResponse;
    System system;

    try {
      Uri uri = new Uri.http(server.getAuthorityWithPort(), server.getApiVersionPath() + "/system");
      rawResponse = await get(uri);
    } catch (_) {
      throw HttpException("Failed to load data from Server(" + server.getFullServerAddress() + ") to get System info.");
    }

    system = System.fromJson(jsonDecode(rawResponse.body));

    return system;
  }
}
