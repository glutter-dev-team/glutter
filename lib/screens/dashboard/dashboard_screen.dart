import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:glutter/models/monitoring/profile.dart';
import 'package:glutter/models/monitoring/sensor.dart';
import 'package:glutter/services/monitoring/database_service.dart';
import 'package:glutter/services/monitoring/glances_service.dart';
import 'package:glutter/models/settings/settings.dart';
import 'package:glutter/models/monitoring/cpu.dart';
import 'package:glutter/models/monitoring/memory.dart';
import 'package:glutter/widgets/drawer.dart';

class DashboardScreen extends StatefulWidget {
    DashboardScreen({Key key, this.title: "Glutter Dashboard"}) : super(key: key);

    static const String routeName = '/dashboard';
    final String title;

    @override
    _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardScreen> {
    Future profilesFuture;
    Profile selectedServer;
    GlancesService service;
    Future<CPU> cpuFuture;
    Future<Memory> memFuture;
    Future<List<Sensor>> sensFuture;
    Future<Settings> settingsFuture;

    @override
    void initState() {
        profilesFuture = DatabaseService.db.getProfiles();

        profilesFuture.then((value) => this.setState(() {selectedServer = value[0]; DatabaseService.db.insertSettings(new Settings(value[0].id, false));}));
        this.service = new GlancesService(this.selectedServer);
        this.cpuFuture = service.getCpu();
        this.memFuture = service.getMemory();
        this.settingsFuture = DatabaseService.db.getSettings();
        super.initState();

        setState(() {
            profilesFuture.then((value) => this.setState(() {
                selectedServer = value[0]; DatabaseService.db.insertSettings(new Settings(value[0].id, false));
                this.service = new GlancesService(selectedServer);
                this.cpuFuture = service.getCpu();
                this.memFuture = service.getMemory();
                this.sensFuture = service.getSensors();
            }));
        });
    }

    RefreshController _refreshController =
    RefreshController(initialRefresh: false);

    void _onRefresh() async{
        // monitor network fetch
        await Future.delayed(Duration(milliseconds: 500));

        this.setState(() {
            this.selectedServer = selectedServer;
            this.service = new GlancesService(selectedServer);
            this.cpuFuture = service.getCpu();
            this.memFuture = service.getMemory();
            this.sensFuture = service.getSensors();
            DatabaseService.db.insertSettings(new Settings(selectedServer.id, false));
            this.settingsFuture = DatabaseService.db.getSettings();
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
                child: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                        Card(
                            color: Theme.of(context).accentColor,
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                    const ListTile(
                                        leading: Icon(Icons.devices),
                                        title: Text("Server")
                                    ),
                                    FutureBuilder(
                                        future: profilesFuture,
                                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                                            switch (snapshot.connectionState) {
                                                case ConnectionState.active:
                                                case ConnectionState.waiting:
                                                    return Center(
                                                        child: Container(
                                                            child: new CircularProgressIndicator(),
                                                            alignment: Alignment(
                                                                0.0, 0.0
                                                            )
                                                        )
                                                    );
                                                case ConnectionState.done:
                                                    return new Container(
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
                                                                this.cpuFuture = service.getCpu();
                                                                this.memFuture = service.getMemory();
                                                                this.sensFuture = service.getSensors();
                                                                DatabaseService.db.insertSettings(new Settings(selectedServer.id, false));
                                                                this.settingsFuture = DatabaseService.db.getSettings();
                                                            });
                                                        },
                                                        value: selectedServer,
                                                        )
                                                    );
                                                default:
                                                    return Text("default");
                                            }
                                        }
                                    )
                                ],
                            ),
                        ),
                        Card(
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                    const ListTile(
                                        leading: Icon(Icons.memory),
                                        title: Text("CPU-Usage")
                                    ),
                                    FutureBuilder(
                                        future: cpuFuture,
                                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                                            switch (snapshot.connectionState) {
                                                case ConnectionState.active:
                                                case ConnectionState.waiting:
                                                    return Center(
                                                        child: Container(
                                                            child: new CircularProgressIndicator(),
                                                            alignment: Alignment(
                                                                0.0, 0.0
                                                            )
                                                            )
                                                        );
                                                case ConnectionState.done:
                                                    return new Container(
                                                        child: CircularPercentIndicator(
                                                            radius: 150.0,
                                                            animation: true,
                                                            lineWidth: 15.0,
                                                            percent: (snapshot.data.totalLoad / 100),
                                                            center: new Text(snapshot.data.totalLoad.toString() + "%"),
                                                            progressColor: Theme.of(context).accentColor,
                                                            backgroundColor: Theme.of(context).primaryColor,
                                                        )
                                                    );
                                                default:
                                                    return Text("default");
                                            }
                                        }
                                    )
                                ],
                            ),
                        ),
                        Card(
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                    const ListTile(
                                        leading: Icon(Icons.storage),
                                        title: Text("Memory-Usage"),
                                    ),
                                    FutureBuilder(
                                        future: memFuture,
                                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                                            switch (snapshot.connectionState) {
                                                case ConnectionState.active:
                                                case ConnectionState.waiting:
                                                    return Container(
                                                        child: Container(
                                                            child: new CircularProgressIndicator(),
                                                            alignment: Alignment(
                                                                0.0, 0.0
                                                            )
                                                        )
                                                    );
                                                case ConnectionState.done:
                                                    return new Center(
                                                        child: CircularPercentIndicator(
                                                            radius: 150.0,
                                                            animation: true,
                                                            lineWidth: 15.0,
                                                            percent: (snapshot.data.usagePercent / 100),
                                                            center: new Text(snapshot.data.usagePercent.toString() + "%"),
                                                            progressColor: Theme.of(context).accentColor,
                                                            backgroundColor: Theme.of(context).primaryColor,
                                                        )
                                                    );
                                                default:
                                                    return Text("default");
                                            }
                                        }
                                    )
                                ],
                            ),
                        ),
                        Card(
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                    const ListTile(
                                        leading: Icon(Icons.toys),
                                        title: Text("Sensors"),
                                    ),
                                    FutureBuilder(
                                        future: sensFuture,
                                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                                            switch (snapshot.connectionState) {
                                                case ConnectionState.active:
                                                case ConnectionState.waiting:
                                                    return Container(
                                                        child: Container(
                                                            child: new CircularProgressIndicator(),
                                                            alignment: Alignment(
                                                                0.0, 0.0
                                                            )
                                                        )
                                                    );
                                                case ConnectionState.done:
                                                    if (snapshot.data != null)
                                                    {
                                                        return new Column(
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
                                                        );
                                                    }
                                                    else {
                                                        return new Text("No Sensor Data");
                                                    }
                                                    return null;
                                                default:
                                                    return Text("default");
                                            }
                                        }
                                    )
                                ],
                            ),
                        )
                    ],
                )
            )
        )
        );
    }
}
