import 'dart:async';

import 'package:flutter/material.dart';
import 'package:glutter/models/shared/profile.dart';
import 'package:glutter/services/monitoring/glances_service.dart';
import 'package:glutter/services/shared/preferences_service.dart';
import 'package:glutter/widgets/drawer.dart';
import 'package:glutter/widgets/errors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'data_list_builder.dart';

class MonitoringScreen extends StatefulWidget {
  MonitoringScreen({Key key, this.title: "Monitoring"}) : super(key: key);

  static const String routeName = '/monitoring';
  final String title;

  @override
  _MonitoringState createState() => _MonitoringState();
}

class _MonitoringState extends State<MonitoringScreen> {
  GlancesService glancesService;

  Profile selectedProfile;

  MonitoringOption selectedOption;
  List<MonitoringOption> monitoringOptions;

  Future monitoringFuture;

  @override
  void initState() {
    super.initState();

    this.monitoringOptions = new List();
    for (var value in MonitoringOption.values) {
      this.monitoringOptions.add(value);
    }

    this.selectedOption = this.monitoringOptions[0];

    PreferencesService.getLastProfile().then((profile) => () {
      this.selectedProfile = profile;
      _refreshMonitoringData(this.selectedOption);
    });
  }

  _refreshMonitoringData(MonitoringOption choice) {
    this.glancesService = new GlancesService(this.selectedProfile);

    switch (choice) {
      case MonitoringOption.CPU:
        monitoringFuture = glancesService.getCpu();
        break;
      case MonitoringOption.Memory:
        monitoringFuture = glancesService.getMemory();
        break;
      case MonitoringOption.Network:
        monitoringFuture = glancesService.getNetworks();
        break;
      case MonitoringOption.Sensors:
        monitoringFuture = glancesService.getSensors();
        break;
    }
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 500));

    this.setState(() {
      PreferencesService.getLastProfile().then((profile) => () {
        this.selectedProfile = profile;
        _refreshMonitoringData(this.selectedOption);
      });
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
        body: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            header: ClassicHeader(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: Builder(
                builder: (context) => Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                    child: Column(children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text("Data category: "),
                          DropdownButton<MonitoringOption>(
                            items: this
                                .monitoringOptions
                                .map((value) {
                              return DropdownMenuItem<MonitoringOption>(value: value, child: Text(getMonitoringOptionAsString(value)));
                            })
                                .cast<DropdownMenuItem<MonitoringOption>>()
                                .toList(),
                            onChanged: (selectedOption) {
                              setState(() {
                                this.selectedOption = selectedOption;
                                _refreshMonitoringData(this.selectedOption);
                              });
                            },
                            value: selectedOption,
                          ),
                        ],
                      ),
                      Expanded(
                          child: ListView(shrinkWrap: true, children: <Widget>[
                            FutureBuilder(
                                future: PreferencesService.getLastProfile(),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    this.selectedProfile = snapshot.data;
                                    _refreshMonitoringData(this.selectedOption);

                                    if (this.selectedProfile != null) {
                                      return _createMonitoring();
                                    }

                                    return showNoProfileSelected(context);
                                  } else {
                                    return Center(child: CircularProgressIndicator());
                                  }
                                })
                          ]))
                    ])))));
  }

  Widget _createMonitoring() {
    return SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            FutureBuilder(
                future: this.monitoringFuture,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                      if (snapshot.data != null) {
                        List<List> dataList = buildList(this.selectedOption, snapshot);
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: dataList.length,
                            itemBuilder: (BuildContext context, int entity) {
                              var entityProps = dataList[entity];
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
                                              itemBuilder: (BuildContext context, int index) {
                                                return ListTile(
                                                  title: Text(entityProps[index]["short_desc"]),
                                                  subtitle: Text(entityProps[index]["value"]),
                                                  onTap: () {
                                                    _showHelpTextDialog(context, entityProps[index]);
                                                  },
                                                );
                                              })
                                        ],
                                      ));
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
                                              physics: AlwaysScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: entityProps.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                return ListTile(
                                                  title: Text(entityProps[index]["short_desc"]),
                                                  subtitle: Text(entityProps[index]["value"]),
                                                  onTap: () {
                                                    _showHelpTextDialog(context, entityProps[index]);
                                                  },
                                                );
                                              })
                                        ],
                                      ));
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
                                              itemBuilder: (BuildContext context, int index) {
                                                if (index == 0) {
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
                                              })
                                        ],
                                      ));
                                default:
                                  return Container();
                              }
                            });
                      }
                      return showNoDataReceived(getMonitoringOptionAsString(this.selectedOption), this.selectedProfile);

                    default:
                      return Text("default");
                  }
                }),
          ],
        ));
  }
}

_showHelpTextDialog(BuildContext context, entityProp) {
  if (entityProp["help_text"] != null) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.help_outline, color: Theme.of(context).accentColor),
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
        borderRadius: new BorderRadius.only(topLeft: const Radius.circular(4.0), topRight: const Radius.circular(4.0)),
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
