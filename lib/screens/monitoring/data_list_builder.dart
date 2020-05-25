import 'package:flutter/material.dart';

List<Map> memoryListBuilder(AsyncSnapshot snapshot) {

    List<Map> memoryList = new List();
    memoryList = [];

    var total = new Map();
    total["short_desc"] = "total memory";
    total["value"] = snapshot.data.total.toString();
    memoryList.add(total);

    var available = new Map();
    available["short_desc"] = "available memory";
    available["value"] = snapshot.data.available.toString();
    memoryList.add(available);

    var usagePercent = new Map();
    usagePercent["short_desc"] = "usage (%)";
    usagePercent["value"] = snapshot.data.usagePercent.toString();
    memoryList.add(usagePercent);

    var used = new Map();
    used["short_desc"] = "used memory";
    used["value"] = snapshot.data.used.toString();
    memoryList.add(used);

    var free = new Map();
    free["short_desc"] = "free memory";
    free["value"] = snapshot.data.free.toString();
    memoryList.add(free);

    var active = new Map();
    active["short_desc"] = "active memory";
    active["value"] = snapshot.data.active.toString();
    memoryList.add(active);

    var inactive = new Map();
    inactive["short_desc"] = "inactive memory";
    inactive["value"] = snapshot.data.inactive.toString();
    memoryList.add(inactive);

    var buffers = new Map();
    buffers["short_desc"] = "buffers memory";
    buffers["value"] = snapshot.data.buffers.toString();
    memoryList.add(buffers);

    var shared = new Map();
    shared["short_desc"] = "shared memory";
    shared["value"] = snapshot.data.shared.toString();
    memoryList.add(shared);

    print(memoryList.toString());

    return memoryList;
}