import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:glutter/models/settings/settings.dart';
import 'package:glutter/services/shared/database_service.dart';
import 'package:glutter/services/monitoring/glances_service.dart';
import 'package:glutter/models/shared/profile.dart';
import 'package:glutter/widgets/drawer.dart';
import 'data_list_builder.dart';

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

    MonitoringOption selectedOption;
    List<MonitoringOption> monitoringOptions;

    Future monitoringFuture;

    @override
    void initState() {
        profilesFuture = DatabaseService.db.getProfiles();

        this.monitoringOptions = new List();
        for (var value in MonitoringOption.values) {
            this.monitoringOptions.add(value);
        }
        //print(">>> monitoringOptions List: " + this.monitoringOptions.toString());

        super.initState();

        profilesFuture.then((value) => this.setState(() {
            this.selectedServer = value[0];
            DatabaseService.db.insertSettings(new Settings(value[0].id));
            this.service = new GlancesService(selectedServer);
            this.selectedOption = MonitoringOption.CPU;
            this.monitoringFuture = service.getCpu();
        }));
    }

    _changeDataChoice(MonitoringOption choice) {
        switch (choice) {
            case MonitoringOption.CPU:
                monitoringFuture = service.getCpu();
                break;
            case MonitoringOption.Memory:
                monitoringFuture = service.getMemory();
                break;
            case MonitoringOption.Network:
                monitoringFuture = service.getNetworks();
                break;
            case MonitoringOption.Sensors:
                monitoringFuture = service.getSensors();
                break;
        }
    }

    RefreshController _refreshController = RefreshController(initialRefresh: false);

    void _onRefresh() async{
        // monitor network fetch
        await Future.delayed(Duration(milliseconds: 500));

        this.setState(() {
            _changeDataChoice(this.selectedOption);
        });

        // if failed,use refreshFailed()
        _refreshController.refreshCompleted();
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
                                                                        DatabaseService.db.insertSettings(new Settings(selectedServer.id));
                                                                        this.settingsFuture = DatabaseService.db.getSettings();
                                                                        _changeDataChoice(this.selectedOption);
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
                                    DropdownButton<MonitoringOption>(
                                        items: this.monitoringOptions.map((value) {
                                            return DropdownMenuItem<MonitoringOption>(
                                                value: value,
                                                child: Text(_getOptionAsString(value))
                                            );
                                        }).cast<DropdownMenuItem<MonitoringOption>>().toList(),
                                        onChanged: (selectedOption) {
                                            setState(() {
                                                this.selectedOption = selectedOption;
                                                _changeDataChoice(this.selectedOption);
                                            });
                                        },
                                        value: selectedOption,
                                    ),
                                ],
                            ),
                            Expanded(
                                child: SmartRefresher(
                                    enablePullDown: true,
                                    enablePullUp: false,
                                    header: ClassicHeader(),
                                    controller: _refreshController,
                                    onRefresh: _onRefresh,
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
                                                            return Center(
                                                                child: Container(
                                                                    child: new CircularProgressIndicator(),
                                                                    alignment: Alignment(0.0, 0.0),
                                                                ),
                                                            );
                                                        case ConnectionState.done:
                                                            List<List> dataList = buildList(this.selectedOption, snapshot);
                                                            return ListView.builder(
                                                                scrollDirection: Axis.vertical,
                                                                physics: NeverScrollableScrollPhysics(),
                                                                shrinkWrap: true,
                                                                itemCount: dataList.length,
                                                                itemBuilder: (BuildContext context, int entity){
                                                                    var entityProps = dataList[entity];
                                                                    //print(">>> dataList entity: " + entityProps.toString());

                                                                    switch (this.selectedOption) {
                                                                        case MonitoringOption.CPU:
                                                                            return Card(
                                                                                child: Column(
                                                                                    children: [
                                                                                        PurpleCardHeader(
                                                                                            title: "CPU",
                                                                                            iconData: Icons.memory,
                                                                                        ),
                                                                                        ListView.builder(
                                                                                            scrollDirection: Axis.vertical,
                                                                                            physics: NeverScrollableScrollPhysics(),
                                                                                            shrinkWrap: true,
                                                                                            itemCount: entityProps.length,
                                                                                            itemBuilder: (BuildContext context, int index){
                                                                                                return ListTile(
                                                                                                    title: Text(entityProps[index]["short_desc"]),
                                                                                                    subtitle: Text(entityProps[index]["value"]),
                                                                                                    onTap: () {
                                                                                                        _showHelpTextDialog(context, entityProps[index]);
                                                                                                    },
                                                                                                );
                                                                                            }
                                                                                        )
                                                                                    ],
                                                                                )
                                                                            );
                                                                        case MonitoringOption.Memory:
                                                                            return Card(
                                                                                child: Column(
                                                                                    children: [
                                                                                        PurpleCardHeader(
                                                                                            title: "Memory",
                                                                                            iconData: Icons.storage,
                                                                                        ),
                                                                                        ListView.builder(
                                                                                            scrollDirection: Axis.vertical,
                                                                                            physics: NeverScrollableScrollPhysics(),
                                                                                            shrinkWrap: true,
                                                                                            itemCount: entityProps.length,
                                                                                            itemBuilder: (BuildContext context, int index){
                                                                                                return ListTile(
                                                                                                    title: Text(entityProps[index]["short_desc"]),
                                                                                                    subtitle: Text(entityProps[index]["value"]),
                                                                                                    onTap: () {
                                                                                                        _showHelpTextDialog(context, entityProps[index]);
                                                                                                    },
                                                                                                );
                                                                                            }
                                                                                        )
                                                                                    ],
                                                                                )
                                                                            );
                                                                        case MonitoringOption.Sensors:
                                                                            return Card(
                                                                                child: Column(
                                                                                    children: [
                                                                                        PurpleCardHeader(
                                                                                            title: entityProps[0]["value"],
                                                                                            iconData: Icons.toys,
                                                                                        ),
                                                                                        ListTile(
                                                                                            title: Text(
                                                                                                entityProps[3]["value"], // sensor type
                                                                                            ),
                                                                                            subtitle: Text(entityProps[1]["value"] + entityProps[2]["value"]), // sensor value + unit
                                                                                        )
                                                                                    ],
                                                                                ),
                                                                            );
                                                                        case MonitoringOption.Network:
                                                                            return Card(
                                                                                child: Column(
                                                                                    children: [
                                                                                        PurpleCardHeader(
                                                                                            title: entityProps[0]["value"],
                                                                                            iconData: Icons.settings_ethernet,
                                                                                        ),
                                                                                        ListView.builder(
                                                                                            scrollDirection: Axis.vertical,
                                                                                            physics: NeverScrollableScrollPhysics(),
                                                                                            shrinkWrap: true,
                                                                                            itemCount: entityProps.length,
                                                                                            itemBuilder: (BuildContext context, int index){
                                                                                                if (index == 0){
                                                                                                return Container();
                                                                                                } else if (entityProps[index]["short_desc"] == "Is up") {
                                                                                                    IconData isUp;
                                                                                                    if (entityProps[index]["value"]) {
                                                                                                        isUp = Icons.check;
                                                                                                    } else {
                                                                                                        isUp = Icons.clear;
                                                                                                    }
                                                                                                    return ListTile(
                                                                                                        title: Text(entityProps[index]["short_desc"]),
                                                                                                        subtitle: Row(
                                                                                                            children: [
                                                                                                                Icon(
                                                                                                                    isUp,
                                                                                                                    size: 18.0,
                                                                                                                ),
                                                                                                            ],
                                                                                                        ),
                                                                                                        onTap: () {
                                                                                                            _showHelpTextDialog(context, entityProps[index]);
                                                                                                        },
                                                                                                    );
                                                                                                } else {
                                                                                                    return ListTile(
                                                                                                        title: Text(entityProps[index]["short_desc"]),
                                                                                                        subtitle: Text(entityProps[index]["value"]),
                                                                                                        onTap: () {
                                                                                                            _showHelpTextDialog(context, entityProps[index]);
                                                                                                        },
                                                                                                    );
                                                                                                }
                                                                                            }
                                                                                        )
                                                                                    ],
                                                                                )
                                                                            );
                                                                        default:
                                                                            return Container();
                                                                    }
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
                            )
                        ],
                    ),
                ),
            )
        );
    }
}

_showHelpTextDialog(BuildContext context, entityProp) {
    if (entityProp["help_text"] != null) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                title: Row(
                    children: [
                        Icon(
                            Icons.help_outline,
                            color: Theme.of(context).accentColor
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Text(
                                entityProp["short_desc"],
                                style: TextStyle(color: Theme.of(context).accentColor),
                            ),
                        ),
                    ],
                ),
                content: Text(entityProp["help_text"]),
                actions: [
                    /*
                    FlatButton(
                        onPressed: () {
                            // Link to Glutter or Glances documentation with more detailed information?
                        },
                        child: Text(
                            "More information",
                        ),
                    ),
                    */
                    FlatButton(
                        onPressed: () {
                            Navigator.pop(context);
                        },
                        child: Text(
                            "OK",
                        ),
                    ),
                ],
            ),
        );
    }
}

class PurpleCardHeader extends StatelessWidget {
    PurpleCardHeader({this.title, this.iconData});

    final IconData iconData;
    final String title;

    @override
    Widget build(BuildContext context) {
        return Container(
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor, //Colors.deepPurple,
                borderRadius: new BorderRadius.only(
                    topLeft:  const  Radius.circular(4.0),
                    topRight: const  Radius.circular(4.0)
                ),
            ),
            child: ListTile(
                leading: Icon(iconData),
                title: Text(
                    title,
                    style: TextStyle(
                        fontSize: 18.0,
                    ),
                ),
            ),
        );
    }
}

String _getOptionAsString(MonitoringOption option) {
    // Removes the enum name from the enum's value and returns its value only. See example below.
    // input: MonitoringOption.Sensors
    // output: Sensors
    return option.toString().substring(option.toString().indexOf('.')+1);
}
