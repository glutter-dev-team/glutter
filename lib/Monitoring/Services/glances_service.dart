import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart';
import '../Entities/profile.dart';
import '../Entities/cpu.dart';
import '../Entities/memory.dart';
import '../Entities/network.dart';
import '../Entities/sensor.dart';

class GlancesService {

  Profile server;

  /// Constructur for GlancesService-Objects.
  GlancesService(Profile server) {
    this.server = server;
  }

  /// Returns the CPU-Object of the current Server.
  Future<CPU> getCpu() async {
    Response rawResponse;
    CPU cpu;

    try {
      rawResponse = await get(server.getFullServerAddress() + "/cpu");
    } catch(_) {
      throw IOException;
    }

    cpu = CPU.fromJson(rawResponse.body);

    return cpu;
  }

  /// Returns the Memory-Object of the current Server.
  Future<Memory> getMemory() async {
    Response rawResponse;
    Memory memory;

    try {
      rawResponse = await get(server.getFullServerAddress() + "/mem");
    } catch (_) {
      throw IOException;
    }

    memory = Memory.fromJson(rawResponse.body);

    return memory;
  }

  /// Returns list of Network-Objects from Glances for the current server.
  Future<List<Network>> getNetworks() async {
    Response rawResponse;

    try {
      rawResponse = await get(server.getFullServerAddress() + "/network");
    } catch (_) {
      throw IOException;
    }
    var networkObjectsJson = jsonDecode(rawResponse.body)[''] as List;

    List<Network> networkObjects = networkObjectsJson.map((networkJson) => Network.fromJson(networkJson)).toList();

    return networkObjects;
  }

  /// Returns list of Sensor-Objects from Glances for the current server.
  Future<List<Sensor>> getSensors() async {
    Response rawResponse;

    try {
      rawResponse = await get(server.getFullServerAddress() + "/sensors");
    } catch (_) {
      throw IOException;
    }
    var sensorObjectsJson = jsonDecode(rawResponse.body)[''] as List;

    List<Sensor> sensorObjects = sensorObjectsJson.map((sensorJson) => Sensor.fromJson(sensorJson)).toList();

    return sensorObjects;
  }
}
