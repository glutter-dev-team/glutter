import 'package:flutter/material.dart';
import 'package:glutter/utils/convert_bytes.dart';

List<List> buildList(String choice, AsyncSnapshot snapshot) {
    List<List> list = new List();
    switch (choice) {
        case "Memory":
            list = memoryListBuilder(snapshot);
            break;
        case "CPU":
            list = cpuListBuilder(snapshot);
            break;
        case "Sensors":
            list = sensorsListBuilder(snapshot);
            break;
        case "Network":
            list = networkListBuilder(snapshot);
            break;
    }
    return list;
}

List<List> memoryListBuilder(AsyncSnapshot snapshot) {

    List<List> dataList = new List();
    List<Map> memoryList = new List();

    var total = new Map();
    total["short_desc"] = "Total memory";
    total["value"] = convertBytes(snapshot.data.total, 2).toString();
    memoryList.add(total);

    var available = new Map();
    available["short_desc"] = "Available memory";
    available["value"] = convertBytes(snapshot.data.available, 2).toString();
    memoryList.add(available);

    var usagePercent = new Map();
    usagePercent["short_desc"] = "Usage";
    usagePercent["value"] = snapshot.data.usagePercent.toString() + "%";
    memoryList.add(usagePercent);

    var used = new Map();
    used["short_desc"] = "Used memory";
    used["value"] = convertBytes(snapshot.data.used, 2).toString();
    memoryList.add(used);

    var free = new Map();
    free["short_desc"] = "Free memory";
    free["value"] = convertBytes(snapshot.data.free, 2).toString();
    memoryList.add(free);

    var active = new Map();
    active["short_desc"] = "Active memory";
    active["value"] = convertBytes(snapshot.data.active, 2).toString();
    memoryList.add(active);

    var inactive = new Map();
    inactive["short_desc"] = "Inactive memory";
    inactive["value"] = convertBytes(snapshot.data.inactive, 2).toString();
    memoryList.add(inactive);

    var buffers = new Map();
    buffers["short_desc"] = "Buffers memory";
    buffers["value"] = convertBytes(snapshot.data.buffers, 2).toString();
    memoryList.add(buffers);

    var shared = new Map();
    shared["short_desc"] = "Shared memory";
    shared["value"] = convertBytes(snapshot.data.shared, 2).toString();
    memoryList.add(shared);

    dataList.add(memoryList);

    print(">>> full memory data list: " + dataList.toString());
    return dataList;
}

List<List> cpuListBuilder(AsyncSnapshot snapshot) {

    List<List> dataList = new List();
    List<Map> cpuList = new List();

    var totalLoad = new Map();
    totalLoad["short_desc"] = "Total CPU-load";
    totalLoad["value"] = snapshot.data.totalLoad.toString() + "%";
    cpuList.add(totalLoad);

    var user = new Map();
    user["short_desc"] = "User CPU usage";
    user["value"] = snapshot.data.user.toString() + "%";
    cpuList.add(user);

    var system = new Map();
    system["short_desc"] = "System CPU usage";
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
    ioWait["short_desc"] = "I/O wait";
    ioWait["value"] = snapshot.data.ioWait.toString();
    cpuList.add(ioWait);

    var softInterruptRequest = new Map();
    softInterruptRequest["short_desc"] = "Soft interrupt request";
    softInterruptRequest["value"] = snapshot.data.softInterruptRequest.toString();
    cpuList.add(softInterruptRequest);

    var interruptRequest = new Map();
    interruptRequest["short_desc"] = "Interrupt request";
    interruptRequest["value"] = snapshot.data.interruptRequest.toString();
    cpuList.add(interruptRequest);

    var steal = new Map();
    steal["short_desc"] = "Steal";
    steal["value"] = snapshot.data.steal.toString();
    cpuList.add(steal);

    var guest = new Map();
    guest["short_desc"] = "Guest";
    guest["value"] = snapshot.data.guest.toString();
    cpuList.add(guest);

    var ctxSwitches = new Map();
    ctxSwitches["short_desc"] = "CTX switches";
    ctxSwitches["value"] = snapshot.data.ctxSwitches.toString();
    cpuList.add(ctxSwitches);

    var interrupts = new Map();
    interrupts["short_desc"] = "Interrupts";
    interrupts["value"] = snapshot.data.interrupts.toString();
    cpuList.add(interrupts);

    var softwareInterrupts = new Map();
    softwareInterrupts["short_desc"] = "Software interrupts";
    softwareInterrupts["value"] = snapshot.data.softwareInterrupts.toString();
    cpuList.add(softwareInterrupts);

    var systemCalls = new Map();
    systemCalls["short_desc"] = "System calls";
    systemCalls["value"] = snapshot.data.systemCalls.toString();
    cpuList.add(systemCalls);

    var timeSinceUpdate = new Map();
    timeSinceUpdate["short_desc"] = "Time since update";
    timeSinceUpdate["value"] = snapshot.data.timeSinceUpdate.toString();
    cpuList.add(timeSinceUpdate);

    var cpuCore = new Map();
    cpuCore["short_desc"] = "CPU cores";
    cpuCore["value"] = snapshot.data.cpuCore.toString();
    cpuList.add(cpuCore);

    dataList.add(cpuList);

    print(">>> full cpu data list: " + dataList.toString());
    return dataList;
}

List<List> sensorsListBuilder(AsyncSnapshot snapshot) {

    List<List> dataList = new List();

    for(var i = 0; i < snapshot.data.length; i++) {

        var obj = snapshot.data[i];
        List<Map> sensorsList = new List();

        var label = new Map();
        label["short_desc"] = "Label";
        label["value"] = obj.label.toString();
        sensorsList.add(label);

        var value = new Map();
        value["short_desc"] = "Value";
        value["value"] = obj.value.toString();
        sensorsList.add(value);

        var unit = new Map();
        unit["short_desc"] = "Unit";
        unit["value"] = obj.unit.toString();
        sensorsList.add(unit);

        var type = new Map();
        type["short_desc"] = "Type";
        type["value"] = obj.type.toString();
        sensorsList.add(type);

        var key = new Map();
        key["short_desc"] = "Key";
        key["value"] = obj.key.toString();
        sensorsList.add(key);

        dataList.add(sensorsList);
    }

    print(">>> full sensors data list: " + dataList.toString());
    return dataList;
}

List<List> networkListBuilder(AsyncSnapshot snapshot) {

    List<List> dataList = new List();

    for(var i = 0; i < snapshot.data.length; i++) {

        var obj = snapshot.data[i];
        List<Map> networkList = new List();

        var interfaceName = new Map();
        interfaceName["short_desc"] = "Interface name";
        interfaceName["value"] = obj.interfaceName.toString();
        networkList.add(interfaceName);

        var timeSinceUpdate = new Map();
        timeSinceUpdate["short_desc"] = "Time since update";
        timeSinceUpdate["value"] = obj.timeSinceUpdate.toString();
        networkList.add(timeSinceUpdate);

        var cumulativeReceive = new Map();
        cumulativeReceive["short_desc"] = "Cumulative receive";
        cumulativeReceive["value"] = obj.cumulativeReceive.toString();
        networkList.add(cumulativeReceive);

        var receive = new Map();
        receive["short_desc"] = "Receive";
        receive["value"] = obj.receive.toString();
        networkList.add(receive);

        var cumulativeTx = new Map();
        cumulativeTx["short_desc"] = "Cumulative Tx";
        cumulativeTx["value"] = obj.cumulativeTx.toString();
        networkList.add(cumulativeTx);

        var tx = new Map();
        tx["short_desc"] = "tx";
        tx["value"] = obj.tx.toString();
        networkList.add(tx);

        var cumulativeCx = new Map();
        cumulativeCx["short_desc"] = "Cumulative cx";
        cumulativeCx["value"] = obj.cumulativeCx.toString();
        networkList.add(cumulativeCx);

        var cx = new Map();
        cx["short_desc"] = "cx";
        cx["value"] = obj.cx.toString();
        networkList.add(cx);

        var isUp = new Map();
        isUp["short_desc"] = "Is up";
        isUp["value"] = obj.isUp.toString();
        networkList.add(isUp);

        var speed = new Map();
        speed["short_desc"] = "Speed";
        speed["value"] = obj.speed.toString();
        networkList.add(speed);

        var key = new Map();
        key["short_desc"] = "Key";
        key["value"] = obj.key.toString();
        networkList.add(key);

        dataList.add(networkList);        
    }
    
    print(">>> full network data list: " + dataList.toString());
    return dataList;
}
