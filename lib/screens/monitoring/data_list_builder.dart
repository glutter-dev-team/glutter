import 'package:flutter/material.dart';
import 'package:glutter/utils/convert_bytes.dart';

List<Map> buildList(String choice, AsyncSnapshot snapshot) {
    List<Map> list = new List();
    switch (choice) {
        case "Memory":
            list = memoryListBuilder(snapshot);
            break;
        case "CPU":
            list = cpuListBuilder(snapshot);
            break;
    }
    return list;
}

List<Map> memoryListBuilder(AsyncSnapshot snapshot) {

    List<Map> memoryList = new List();
    memoryList = [];

    var total = new Map();
    total["short_desc"] = "total memory";
    total["value"] = convertBytes(snapshot.data.total, 2).toString();
    memoryList.add(total);

    var available = new Map();
    available["short_desc"] = "available memory";
    available["value"] = convertBytes(snapshot.data.available, 2).toString();
    memoryList.add(available);

    var usagePercent = new Map();
    usagePercent["short_desc"] = "usage";
    usagePercent["value"] = snapshot.data.usagePercent.toString() + "%";
    memoryList.add(usagePercent);

    var used = new Map();
    used["short_desc"] = "used memory";
    used["value"] = convertBytes(snapshot.data.used, 2).toString();
    memoryList.add(used);

    var free = new Map();
    free["short_desc"] = "free memory";
    free["value"] = convertBytes(snapshot.data.free, 2).toString();
    memoryList.add(free);

    var active = new Map();
    active["short_desc"] = "active memory";
    active["value"] = convertBytes(snapshot.data.active, 2).toString();
    memoryList.add(active);

    var inactive = new Map();
    inactive["short_desc"] = "inactive memory";
    inactive["value"] = convertBytes(snapshot.data.inactive, 2).toString();
    memoryList.add(inactive);

    var buffers = new Map();
    buffers["short_desc"] = "buffers memory";
    buffers["value"] = convertBytes(snapshot.data.buffers, 2).toString();
    memoryList.add(buffers);

    var shared = new Map();
    shared["short_desc"] = "shared memory";
    shared["value"] = convertBytes(snapshot.data.shared, 2).toString();
    memoryList.add(shared);

    //print(memoryList.toString());
    return memoryList;
}

List<Map> cpuListBuilder(AsyncSnapshot snapshot) {

    List<Map> cpuList = new List();
    cpuList = [];

    var totalLoad = new Map();
    totalLoad["short_desc"] = "Total CPU-Load";
    totalLoad["value"] = snapshot.data.totalLoad.toString() + "%";
    cpuList.add(totalLoad);

    var user = new Map();
    user["short_desc"] = "User CPU Usage";
    user["value"] = snapshot.data.user.toString() + "%";
    cpuList.add(user);

    var system = new Map();
    system["short_desc"] = "System CPU Usage";
    system["value"] = snapshot.data.system.toString() + "%";
    cpuList.add(system);

    var idle = new Map();
    idle["short_desc"] = "Idle CPU";
    idle["value"] = snapshot.data.idle.toString() + "%";
    cpuList.add(idle);

    var nice = new Map();
    nice["short_desc"] = "Nice";
    nice["value"] = snapshot.data.nice.toString();
    cpuList.add(nice);

    var guestNice = new Map();
    guestNice["short_desc"] = "Guest nice";
    guestNice["value"] = snapshot.data.guestNice.toString();
    cpuList.add(guestNice);

    var ioWait = new Map();
    ioWait["short_desc"] = "I/O Wait";
    ioWait["value"] = snapshot.data.ioWait.toString();
    cpuList.add(ioWait);

    var softInterruptRequest = new Map();
    softInterruptRequest["short_desc"] = "Soft Interrupt Request";
    softInterruptRequest["value"] = snapshot.data.softInterruptRequest.toString();
    cpuList.add(softInterruptRequest);

    var interruptRequest = new Map();
    interruptRequest["short_desc"] = "Interrupt Request";
    interruptRequest["value"] = snapshot.data.interruptRequest.toString();
    cpuList.add(interruptRequest);

    var steal = new Map();
    steal["short_desc"] = "steal";
    steal["value"] = snapshot.data.steal.toString();
    cpuList.add(steal);

    var guest = new Map();
    guest["short_desc"] = "guest";
    guest["value"] = snapshot.data.guest.toString();
    cpuList.add(guest);

    var ctxSwitches = new Map();
    ctxSwitches["short_desc"] = "ctx switches";
    ctxSwitches["value"] = snapshot.data.ctxSwitches.toString();
    cpuList.add(ctxSwitches);

    var interrupts = new Map();
    interrupts["short_desc"] = "interrupts";
    interrupts["value"] = snapshot.data.interrupts.toString();
    cpuList.add(interrupts);

    var softwareInterrupts = new Map();
    softwareInterrupts["short_desc"] = "software interrupts";
    softwareInterrupts["value"] = snapshot.data.softwareInterrupts.toString();
    cpuList.add(softwareInterrupts);

    var systemCalls = new Map();
    systemCalls["short_desc"] = "system calls";
    systemCalls["value"] = snapshot.data.systemCalls.toString();
    cpuList.add(systemCalls);

    var timeSinceUpdate = new Map();
    timeSinceUpdate["short_desc"] = "time since update";
    timeSinceUpdate["value"] = snapshot.data.timeSinceUpdate.toString();
    cpuList.add(timeSinceUpdate);

    var cpuCore = new Map();
    cpuCore["short_desc"] = "cpu cores";
    cpuCore["value"] = snapshot.data.cpuCore.toString();
    cpuList.add(cpuCore);

    //print(cpuList.toString());
    return cpuList;
}