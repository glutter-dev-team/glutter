import 'package:flutter/material.dart';
import 'package:glutter/models/monitoring/cpu.dart';
import 'package:glutter/models/monitoring/memory.dart';
import 'package:glutter/models/monitoring/pluginsList.dart';
import 'package:glutter/models/monitoring/sensor.dart';
import 'package:glutter/models/monitoring/system.dart';
import 'package:glutter/models/shared/profile.dart';
import 'package:glutter/services/monitoring/glances_service.dart';
import 'package:glutter/services/shared/preferences_service.dart';
import 'package:glutter/widgets/drawer.dart';
import 'package:glutter/widgets/errors.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key key, this.title: "Dashboard"}) : super(key: key);

  static const String routeName = '/dashboard';
  final String title;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardScreen> {
  Profile selectedProfile;
  GlancesService glancesService;
  Future<PluginsList> pluginsListFuture;
  PluginsList pluginsList;
  Future<CPU> cpuFuture;
  Future<Memory> memFuture;
  Future<List<Sensor>> sensFuture;
  Future<System> systemFuture;

  @override
  void initState() {
    super.initState();

    PreferencesService.getLastProfile().then((profile) => () {
        this.selectedProfile = profile;
        _refreshDashboardData();
      });
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 500));

    this.setState(() {
      PreferencesService.getLastProfile().then((profile) => () {
          this.selectedProfile = profile;
          _refreshDashboardData();
        });
    });

    _refreshController.refreshCompleted();
  }

  void _refreshDashboardData() {
    this.glancesService = new GlancesService(this.selectedProfile);
    this.cpuFuture = glancesService.getCpu();
    this.memFuture = glancesService.getMemory();
    this.sensFuture = glancesService.getSensors();
    this.pluginsListFuture = glancesService.getPluginsList();
    this.systemFuture = glancesService.getSystem();
  }

  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
          child: FutureBuilder<Profile>(
            future: PreferencesService.getLastProfile(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                this.selectedProfile = snapshot.data;
                _refreshDashboardData();
                if (this.selectedProfile != null) {
                  return _createMainDashboardColumn();
                }
                return showNoProfileSelected(context);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }
          )
        )
      )
    );
  }

  Widget _createMainDashboardColumn() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        FutureBuilder(
          future: systemFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Column(
                    children: [
                      Card(
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                                title: Text(
                                    'Server ' + this.selectedProfile.caption,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    )
                                ),
                                subtitle: Text(
                                    'Address: ' + this.selectedProfile.serverAddress
                                ),
                                trailing: Container(
                                    width: 50,
                                    child: new CircularProgressIndicator(),
                                    alignment: Alignment(1.0, 0.0)
                                    )
                                )
                              ]
                          )
                      )
                    ],
                  );
              case ConnectionState.done:
                bool serverIsOnline = (snapshot.data != null) ? true : false;
                String status = serverIsOnline ? "online" : "unreachable";
                String hrName = "";
                String hostname = "";
                if (snapshot.data != null) {
                  System system = snapshot.data;
                  hrName = system.hrName;
                  hostname = system.hostname;
                }
                return Column(
                  children: [
                    Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                                title: Text(
                                    'Server ' + this.selectedProfile.caption,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    )
                                ),
                                subtitle: Table(
                                  columnWidths: {
                                    0: FlexColumnWidth(3),
                                    1: FlexColumnWidth(7),
                                  },
                                  children: [
                                    TableRow(children: [
                                      Text('Address:'),
                                      Text(this.selectedProfile.serverAddress),
                                    ]),
                                    TableRow(children: [
                                      Text("Host:"),
                                      Text(hostname),
                                    ]),
                                    TableRow(children: [
                                      Text("OS:"),
                                      Text(hrName),
                                    ]),
                                  ],
                                ),
                                trailing: Container(
                                    width: 150,
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            status,
                                            style: TextStyle(
                                                color: serverIsOnline ? Colors.green : Colors.grey,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 15.0
                                            ),
                                          ),
                                          SizedBox(width: 7.5),
                                          Container(
                                            width: 30,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: serverIsOnline ? Colors.green : null
                                            ),
                                            child: Container(
                                                alignment: Alignment.center,
                                                child: serverIsOnline ? Icon(Icons.check) : Icon(Icons.help_outline)
                                            ),
                                          ),
                                        ]
                                    )
                                )
                            ),
                          ]
                      )
                    ),
                    !serverIsOnline ? Card(
                      child: showNoDataReceived(this.selectedProfile)
                    ) : SizedBox()
                  ],
                );
                return SizedBox();
              default:
                return SizedBox();
            }
          }
        ),
        FutureBuilder(
          future: cpuFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      const ListTile(
                          leading: Icon(Icons.memory),
                          title: Text("CPU Usage")
                      ),
                      _progressIndicatorContainer(),
                    ]
                  )
                );
              case ConnectionState.done:
                if (snapshot.data != null) {
                  return Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        const ListTile(
                            leading: Icon(Icons.memory),
                            title: Text("CPU Usage")
                        ),
                        Container(
                          child: CircularPercentIndicator(
                            radius: 150.0,
                            animation: true,
                            lineWidth: 15.0,
                            percent: (snapshot.data.totalLoad / 100),
                            center: new Text(snapshot.data.totalLoad.toString() + "%"),
                            progressColor: Theme.of(context).accentColor,
                            backgroundColor: Theme.of(context).primaryColor,
                          )
                        )
                      ],
                    )
                  );
                }
                return SizedBox();
              default:
                return internalErrorText();
            }
          }
        ),
        FutureBuilder(
          future: memFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(Icons.storage),
                        title: Text("Memory Usage"),
                      ),
                      _progressIndicatorContainer()
                    ]
                  )
                );
              case ConnectionState.done:
                if (snapshot.data != null) {
                  return Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        const ListTile(
                          leading: Icon(Icons.storage),
                          title: Text("Memory Usage"),
                        ),
                        Center(
                          child: CircularPercentIndicator(
                            radius: 150.0,
                            animation: true,
                            lineWidth: 15.0,
                            percent: (snapshot.data.usagePercent / 100),
                            center: new Text(snapshot.data.usagePercent.toString() + "%"),
                            progressColor: Theme.of(context).accentColor,
                            backgroundColor: Theme.of(context).primaryColor,
                          )
                        )
                      ],
                    ),
                  );
                }
                return SizedBox();
              default:
                return internalErrorText();
            }
          }
        ),
        FutureBuilder(
          future: sensFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Card(
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          const ListTile(
                            leading: Icon(Icons.toys),
                            title: Text("Sensors"),
                          ),
                          _progressIndicatorContainer()
                        ]
                    )
                );
              case ConnectionState.done:
                if (snapshot.data != null) {
                  if (snapshot.data.length > 0) {
                    return Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          const ListTile(
                            leading: Icon(Icons.toys),
                            title: Text("Sensors"),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: List.generate(snapshot.data.length, (i) {
                              return Center(
                                child: CircularPercentIndicator(
                                  radius: 150.0,
                                  animation: true,
                                  lineWidth: 15.0,
                                  header: new Text(snapshot.data[i].label),
                                  percent: (snapshot.data[i].value / 100),
                                  center: new Text(snapshot.data[i].value.toString() + " " + snapshot.data[i].unit.toString()),
                                  progressColor: Theme.of(context).accentColor,
                                  backgroundColor: Theme.of(context).primaryColor,
                                )
                              );
                            })
                          )
                        ],
                      ),
                    );
                  }
                }
                return SizedBox();
              default:
                return internalErrorText();
            }
          }
        )
      ],
    );
  }
}

Widget _progressIndicatorContainer() {
  return Container(
      alignment: Alignment(0.0, 0.0),
      child: Padding(
        padding: EdgeInsets.all(25.0),
        child: new CircularProgressIndicator(),
      )
  );
}
