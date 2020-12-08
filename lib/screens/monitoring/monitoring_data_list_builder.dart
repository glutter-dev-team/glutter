import 'package:flutter/material.dart';
import 'package:glutter/models/monitoring/cpu.dart';
import 'package:glutter/models/monitoring/memory.dart';
import 'package:glutter/models/monitoring/network.dart';
import 'package:glutter/models/monitoring/sensor.dart';
import 'package:glutter/utils/utils.dart';

/// Build different lists of maps that contain (help-) texts and custom formatted information for the ListView-Builders in CpuTab, MemoryTab, NetworkTab and SensorsTab (on MonitoringScreen).
class DataListBuilder {

  /// CpuTab
  static List<List> cpuList(AsyncSnapshot snapshot) {
    List<List> dataList = new List();
    List<Map> cpuList = new List();
    CPU cpu = snapshot.data;

    var totalLoad = new Map();
    totalLoad["label"] = "Total CPU-load";
    totalLoad["help_text"] = "Percent of total CPU-Load.";
    totalLoad["value"] = cpu.totalLoad.toString() + " %";
    cpuList.add(totalLoad);

    var user = new Map();
    user["label"] = "User CPU usage";
    user["help_text"] = "Percent time spent in user space.";
    user["value"] = cpu.user.toString() + " %";
    cpuList.add(user);

    var system = new Map();
    system["label"] = "System CPU usage";
    system["help_text"] = "Percent time spent in kernel space.";
    system["value"] = cpu.system.toString() + " %";
    cpuList.add(system);

    var idle = new Map();
    idle["label"] = "Idle CPU";
    idle["help_text"] = "Percent of CPU used by any program.";
    idle["value"] = cpu.idle.toString() + " %";
    cpuList.add(idle);

    var nice = new Map();
    nice["label"] = "Nice";
    nice["help_text"] = "Percent time occupied by user level processes with a positive nice value.";
    nice["value"] = cpu.nice.toString() + " %";
    cpuList.add(nice);

    var guestNice = new Map();
    guestNice["label"] = "Guest nice";
    guestNice["value"] = cpu.guestNice.toString();
    cpuList.add(guestNice);

    var ioWait = new Map();
    ioWait["label"] = "I/O wait";
    ioWait["help_text"] = "Linux: Percent time spent by the CPU waiting for I/O operations to complete.";
    ioWait["value"] = cpu.ioWait.toString() + " %";
    cpuList.add(ioWait);

    var softInterruptRequest = new Map();
    softInterruptRequest["label"] = "Soft interrupt request";
    softInterruptRequest["help_text"] = "Percent time spent servicing/handling software interrupts.";
    softInterruptRequest["value"] = cpu.softInterruptRequest.toString() + " %";
    cpuList.add(softInterruptRequest);

    var interruptRequest = new Map();
    interruptRequest["label"] = "Interrupt request";
    interruptRequest["help_text"] = "Percent time spent servicing/handling hardware interrupts.";
    interruptRequest["value"] = cpu.interruptRequest.toString() + " %";
    cpuList.add(interruptRequest);

    var steal = new Map();
    steal["label"] = "Steal";
    steal["help_text"] = "Percentage of time a virtual CPU waits for a real CPU while the hypervisor is servicing another virtual processor.";
    steal["value"] = cpu.steal.toString() + " %";
    cpuList.add(steal);

    var guest = new Map();
    guest["label"] = "Guest";
    guest["value"] = cpu.guest.toString();
    cpuList.add(guest);

    var ctxSwitches = new Map();
    ctxSwitches["label"] = "CTX switches";
    ctxSwitches["help_text"] = "Number of context switches (voluntary + involuntary) per second.";
    ctxSwitches["value"] = cpu.ctxSwitches.toString() + "/s";
    cpuList.add(ctxSwitches);

    var interrupts = new Map();
    interrupts["label"] = "Interrupts";
    interrupts["help_text"] = "Number of interrupts per second.";
    interrupts["value"] = cpu.interrupts.toString() + "/s";
    cpuList.add(interrupts);

    var softwareInterrupts = new Map();
    softwareInterrupts["label"] = "Software interrupts";
    softwareInterrupts["help_text"] = "Number of software interrupts per second. Always set to 0 on Windows and SunOS.";
    softwareInterrupts["value"] = cpu.softwareInterrupts.toString() + "/s";
    cpuList.add(softwareInterrupts);

    var systemCalls = new Map();
    systemCalls["label"] = "System calls";
    systemCalls["help_text"] = "Number of system calls per second. Do not displayed on Linux (always 0).";
    systemCalls["value"] = cpu.systemCalls.toString() + "/s";
    cpuList.add(systemCalls);

    var cpuCore = new Map();
    cpuCore["label"] = "CPU cores";
    cpuCore["help_text"] = "Number of available CPU-Cores.";
    cpuCore["value"] = cpu.cpuCore.toString();
    cpuList.add(cpuCore);

    var timeSinceUpdate = new Map();
    timeSinceUpdate["label"] = "Time since update";
    timeSinceUpdate["help_text"] = "Time passed by since last update.";
    timeSinceUpdate["value"] = cpu.timeSinceUpdate.toStringAsFixed(2) + " s";
    cpuList.add(timeSinceUpdate);

    dataList.add(cpuList);

    return dataList;
  }

  /// MemoryTab
  static List<List> memoryList(AsyncSnapshot snapshot) {
    List<List> dataList = new List();
    List<Map> memoryList = new List();
    Memory memory = snapshot.data;

    var total = new Map();
    total["label"] = "Total memory";
    total["help_text"] = "Total physical memory installed.";
    total["value"] = convertBytes(memory.total, 2).toString();
    memoryList.add(total);

    var available = new Map();
    available["label"] = "Available memory";
    available["help_text"] = "The actual amount of available memory that can be given instantly to processes that request more memory in bytes. This is calculated by summing different memory values depending on the platform (e.g. free + buffers + cached on Linux) and it is supposed to be used to monitor actual memory usage in a cross platform fashion.";
    available["value"] = convertBytes(memory.available, 2).toString();
    memoryList.add(available);

    var usagePercent = new Map();
    usagePercent["label"] = "Usage";
    usagePercent["help_text"] = "The percentage usage calculated as (total-available)/total*100.";
    usagePercent["value"] = memory.usagePercent.toString() + " %";
    memoryList.add(usagePercent);

    var used = new Map();
    used["label"] = "Used memory";
    used["help_text"] = "Memory used, calculated differently depending on the platform and designed for informational purposes only.";
    used["value"] = convertBytes(memory.used, 2).toString();
    memoryList.add(used);

    var free = new Map();
    free["label"] = "Free memory";
    free["help_text"] =
    "Memory not being used at all (zeroed) that is readily available; note that this doesn’t reflect the actual memory available (use ‘available’ instead).";
    free["value"] = convertBytes(memory.free, 2).toString();
    memoryList.add(free);

    var active = new Map();
    active["label"] = "Active memory";
    active["help_text"] = "UNIX: Memory currently in use or very recently used, and so it is in RAM.";
    active["value"] = convertBytes(memory.active, 2).toString();
    memoryList.add(active);

    var inactive = new Map();
    inactive["label"] = "Inactive memory";
    inactive["help_text"] = "UNIX: Memory that is marked as not used.";
    inactive["value"] = convertBytes(memory.inactive, 2).toString();
    memoryList.add(inactive);

    var buffers = new Map();
    buffers["label"] = "Buffers memory";
    buffers["help_text"] = "Linux, BSD: Cache for things like file system metadata.";
    buffers["value"] = convertBytes(memory.buffers, 2).toString();
    memoryList.add(buffers);

    var shared = new Map();
    shared["label"] = "Shared memory";
    shared["help_text"] = "BSD: Memory that may be simultaneously accessed by multiple processes.";
    shared["value"] = convertBytes(memory.shared, 2).toString();
    memoryList.add(shared);

    dataList.add(memoryList);

    return dataList;
  }

  /// NetworksTab
  static List<List> networksList(AsyncSnapshot snapshot) {
    List<List> dataList = new List();

    for (var i = 0; i < snapshot.data.length; i++) {
      Network network = snapshot.data[i];
      List<Map> networkList = new List();

      var interfaceName = new Map();
      interfaceName["label"] = "Interface name";
      interfaceName["value"] = network.interfaceName.toString();
      networkList.add(interfaceName);

      var cumulativeReceive = new Map();
      cumulativeReceive["label"] = "Cumulative receive";
      cumulativeReceive["help_text"] = "Cumulative rate of network-traffic receive to the server.";
      cumulativeReceive["value"] = convertBits(network.cumulativeReceive, 2);
      networkList.add(cumulativeReceive);

      var receive = new Map();
      receive["label"] = "Receive";
      receive["help_text"] = "Rate of network-traffic receive to the server.";
      receive["value"] = convertBits(network.receive, 2).toString() + "/s";
      networkList.add(receive);

      var cumulativeTx = new Map();
      cumulativeTx["label"] = "Cumulative Tx";
      cumulativeTx["help_text"] = "Cumulative rate of network-traffic send by the server.";
      cumulativeTx["value"] = convertBits(network.cumulativeTx, 2);
      networkList.add(cumulativeTx);

      var tx = new Map();
      tx["label"] = "tx";
      tx["help_text"] = "Rate of network-traffic send by the server.";
      tx["value"] = convertBits(network.tx, 2) + "/s";
      networkList.add(tx);

      var cumulativeCx = new Map();
      cumulativeCx["label"] = "Cumulative cx";
      cumulativeCx["value"] = convertBits(network.cumulativeCx, 2);
      networkList.add(cumulativeCx);

      var cx = new Map();
      cx["label"] = "cx";
      cx["value"] = network.cx.toString();
      networkList.add(cx);

      var isUp = new Map();
      isUp["label"] = "Is up";
      isUp["help_text"] = "Specifies whether the specifies network-interface is up (online).";
      isUp["value"] = network.isUp;
      networkList.add(isUp);

      var speed = new Map();
      speed["label"] = "Speed";
      speed["help_text"] = "Specifies the speed of the current network-interface.";
      speed["value"] = convertBits(network.speed, 2) + "/s";
      networkList.add(speed);

      var timeSinceUpdate = new Map();
      timeSinceUpdate["label"] = "Time since update";
      timeSinceUpdate["help_text"] = "Time passed by since last update.";
      timeSinceUpdate["value"] = network.timeSinceUpdate.toStringAsFixed(2) + " s";
      networkList.add(timeSinceUpdate);

      dataList.add(networkList);
    }

    return dataList;
  }

  /// SensorsTab
  static List<List> sensorsList(AsyncSnapshot snapshot) {
    List<List> dataList = new List();

    for (var i = 0; i < snapshot.data.length; i++) {
      Sensor sensor = snapshot.data[i];
      List<Map> sensorsList = new List();

      var label = new Map();
      label["label"] = "Label";
      label["value"] = sensor.label.toString();
      sensorsList.add(label);

      var value = new Map();
      value["label"] = "Value";
      value["value"] = sensor.value.toString();
      sensorsList.add(value);

      var unit = new Map();
      unit["label"] = "Unit";
      if (sensor.unit.toString() == "C" || sensor.unit.toString() == "F") {
        unit["value"] = "°" + sensor.unit.toString();
      } else {
        unit["value"] = sensor.unit.toString();
      }
      sensorsList.add(unit);

      var type = new Map();
      type["label"] = "Type";
      type["value"] = sensor.type.toString();
      sensorsList.add(type);

      dataList.add(sensorsList);
    }

    return dataList;
  }
}

