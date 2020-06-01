import 'package:flutter/material.dart';
import 'package:glutter/models/monitoring/cpu.dart';
import 'package:glutter/models/monitoring/memory.dart';
import 'package:glutter/models/settings/settings.dart';
import 'package:glutter/services/monitoring/database_service.dart';
import 'dart:async';

import '../../services/monitoring/glances_service.dart';
import '../../models/monitoring/profile.dart';
import '../../utils/toast.dart';
import 'data_list_builder.dart';
import '../../widgets/drawer.dart';

class MonitoringScreen extends StatefulWidget {
    MonitoringScreen({Key key, this.title: "Glutter Monitoring"}) : super(key: key);

    static const String routeName = '/monitoring';
    final String title;

    @override
    _MonitoringState createState() => _MonitoringState();
}

class _MonitoringState extends State<MonitoringScreen> {

    GlancesService service;
    Future<Settings> settingsFuture;

    Future profilesFuture;
    Profile selectedServer;

    String selectedData;
    List<String> dataChoices;

    Future monitoringFuture;

    @override
    void initState() {
        profilesFuture = DatabaseService.db.getProfiles();
        profilesFuture.then((value) => this.setState(() {
            this.selectedServer = value[0];
            DatabaseService.db.insertSettings(new Settings(value[0].id, false));
        }));
        this.service = new GlancesService(this.selectedServer);
        this.monitoringFuture = service.getCpu();
        this.settingsFuture = DatabaseService.db.getSettings();
        this.selectedData = "CPU";

        dataChoices = [
            "CPU",
            "Memory",
            "Network",
            "Sensor"
        ];

        super.initState();
    }

    _changeDataChoice(String choice) {
        switch (choice) {
            case "CPU":
                monitoringFuture = service.getCpu();
                break;
            case "Memory":
                monitoringFuture = service.getMemory();
                break;
            case "Network":
                monitoringFuture = service.getNetworks();
                break;
            case "Sensor":
                monitoringFuture = service.getSensors();
                break;
        }
    }

    @override
    Widget build(BuildContext context) {
        // This method is rerun every time setState is called
        return Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
            ),
            drawer: AppDrawer(),
            body: Builder(
                builder: (context) => Padding(
                    padding: EdgeInsets.fromLTRB(10.0,10.0,10.0,0),
                    child: Column(
                        children: <Widget> [
                            Row(
                                children: <Widget>[
                                    Text("Profile: "),
                                    FutureBuilder(
                                        future: profilesFuture,
                                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                                            switch (snapshot.connectionState) {
                                                case ConnectionState.active:
                                                    return Text("active");
                                                case ConnectionState.waiting:
                                                    return Text("loading");
                                                case ConnectionState.done:
                                                    return Center(
                                                        child: Padding(
                                                            padding: EdgeInsets.all(0.0),
                                                            child: DropdownButton<Profile>(
                                                                items: snapshot.data.map((Profile item) {
                                                                    return DropdownMenuItem<Profile>(
                                                                        value: item,
                                                                        child: Text(item.caption + " (" + item.serverAddress + ")")
                                                                    );
                                                                }).cast<DropdownMenuItem<Profile>>().toList(),
                                                                onChanged: (Profile selectedServer) {
                                                                    setState(() {
                                                                        this.selectedServer = selectedServer;
                                                                        this.service = new GlancesService(selectedServer);
                                                                        DatabaseService.db.insertSettings(new Settings(selectedServer.id, false));
                                                                        this.settingsFuture = DatabaseService.db.getSettings();
                                                                        _changeDataChoice(this.selectedData);
                                                                    });
                                                                },
                                                                value: selectedServer,
                                                            ),
                                                        )
                                                    );
                                                default:
                                                    return Text("default");
                                            }
                                        }
                                    )
                                ],
                            ),
                            Row(
                                children: <Widget>[
                                    Text("Data: "),
                                    DropdownButton<String>(
                                        items: dataChoices.map((value) {
                                            return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value)
                                            );
                                        }).cast<DropdownMenuItem<String>>().toList(),
                                        onChanged: (selectedData) {
                                            setState(() {
                                                this.selectedData = selectedData;
                                                _changeDataChoice(this.selectedData);
                                            });
                                        },
                                        value: selectedData,
                                    ),
                                ],
                            ),
                            Row(
                                children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(top:10.0),
                                        child: Text(this.selectedData,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22),
                                        ),
                                    ),
                                ],
                            ),
                            Expanded(
                                child: ListView(
                                    shrinkWrap: true,
                                    children: <Widget>[
                                        FutureBuilder(
                                            future: monitoringFuture,
                                            builder: (BuildContext context, AsyncSnapshot snapshot){
                                                switch (snapshot.connectionState) {
                                                    case ConnectionState.none:
                                                        return Text("none");
                                                    case ConnectionState.active:
                                                        return Text("active");
                                                    case ConnectionState.waiting:
                                                        return Center( //Text("Active and maybe waiting");
                                                            child: Container(
                                                                child: new CircularProgressIndicator(),
                                                                alignment: Alignment(0.0, 0.0),
                                                            ),
                                                        );
                                                    case ConnectionState.done:
                                                        List<Map> dataList = buildList(this.selectedData, snapshot);
                                                        return ListView.builder(
                                                            scrollDirection: Axis.vertical,
                                                            physics: NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount: dataList.length,
                                                            itemBuilder: (BuildContext context, int index){
                                                                return ListTile(
                                                                    title: Text(dataList[index]["short_desc"].toString()),
                                                                    subtitle: Text(dataList[index]["value"].toString()), //snapshot.data.total.toString()
                                                                );
                                                            }
                                                        );
                                                    default:
                                                        return Text("default");
                                                }
                                            }
                                        ),
                                    ],
                                )
                            )
                        ],
                    ),
                ),
            )
        );
    }
}
