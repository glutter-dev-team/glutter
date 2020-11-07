import 'dart:convert';
import 'dart:io';

import 'package:glutter/models/monitoring/cpu.dart';
import 'package:glutter/models/monitoring/memory.dart';
import 'package:glutter/models/monitoring/network.dart';
import 'package:glutter/models/monitoring/sensor.dart';
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
      rawResponse = await get(server.getFullServerAddress() + "/cpu");
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
      rawResponse = await get(server.getFullServerAddress() + "/mem");
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
      rawResponse = await get(server.getFullServerAddress() + "/network");
    } catch (_) {
      throw HttpException("Failed to load data from Server(" + server.getFullServerAddress() + ") to get Networks.");
    }
    var networkObjectsJson = jsonDecode(rawResponse.body);

    List<Network> networkObjects = new List<Network>();

    networkObjectsJson.forEach((networkJson) => networkObjects.add(Network.fromJson(networkJson)));

    return networkObjects;
  }

  /// Returns list of Sensor-Objects from Glances for the current server.
  Future<List<Sensor>> getSensors() async {
    Response rawResponse;

    try {
      rawResponse = await get(server.getFullServerAddress() + "/sensors");
    } catch (_) {
      throw HttpException("Failed to load data from Server(" + server.getFullServerAddress() + ") to get Sensors.");
    }
    var sensorObjectsJson = jsonDecode(rawResponse.body);

    List<Sensor> sensorObjects = new List<Sensor>();

    sensorObjectsJson.forEach((sensorJson) => sensorObjects.add(Sensor.fromJson(sensorJson)));

    return sensorObjects;
  }

  /// Checks whether the connection to the glances-APi can be established and the required plugins are installed.
  Future<bool> connectionTest() async {
    Response rawResponse;

    try {
      rawResponse = await get(server.getFullServerAddress() + "/pluginslist");
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
}
