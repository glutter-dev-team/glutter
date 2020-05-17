import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart';
import '../../models/monitoring/profile.dart';
import '../../models/monitoring/cpu.dart';
import '../../models/monitoring/memory.dart';
import '../../models/monitoring/network.dart';
import '../../models/monitoring/sensor.dart';

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
        } catch(_) {
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
            throw HttpException("Failed to load data from Server to get Memory.");
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
            throw HttpException("Failed to load data from Server to get Networks.");
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
            throw HttpException("Failed to load data from Server to get Sensors.");
        }
        var sensorObjectsJson = jsonDecode(rawResponse.body);

        List<Sensor> sensorObjects = new List<Sensor>();

        sensorObjectsJson.forEach((sensorJson) => sensorObjects.add(Sensor.fromJson(sensorJson)));

        return sensorObjects;
    }
}
