import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:glutter/models/monitoring/profile.dart';
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
    }


    @override
    Widget build(BuildContext context) {
        // This method is rerun every time setState is called
        return Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
            ),
            drawer: AppDrawer(),
            body:
                FutureBuilder(
                    future: profilesFuture,
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                        switch (snapshot.connectionState) {
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
                                return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                        Center(
                                            child: Padding(
                                                padding: EdgeInsets.all(15.0),
                                                child: DropdownButton<Profile>(
                                                    style: TextStyle(color: Theme.of(context).accentColor, fontSize: 16.0),
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
                                                        DatabaseService.db.insertSettings(new Settings(selectedServer.id, false));
                                                        this.settingsFuture = DatabaseService.db.getSettings();
                                                        });
                                                    },
                                                    value: selectedServer,
                                                ),
                                            )

                                        ),

                                    FutureBuilder(
                                        future: cpuFuture,
                                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                                            switch (snapshot.connectionState) {
                                                case ConnectionState.active:
                                                    return Text("active");
                                                case ConnectionState.waiting:
                                                    return Center(
                                                        child: Container(
                                                            child: new CircularProgressIndicator(),
                                                            alignment: Alignment(
                                                                0.0, 0.0),
                                                        ),
                                                    );
                                                case ConnectionState.done:
                                                     return new Center(
                                                        child: CircularPercentIndicator(
                                                            radius: 210.0,
                                                            animation: true,
                                                            lineWidth: 40.0,
                                                            percent: (snapshot.data.totalLoad / 100),
                                                            header: new Text("CPU-Usage", textScaleFactor: 2,),
                                                            center: new Text(snapshot.data.totalLoad.toString() + "%"),
                                                            progressColor: Theme.of(context).accentColor,
                                                            backgroundColor: Theme.of(context).primaryColor,
                                                        )
                                                );
                                                default:
                                                    return Text("default");
                                            }
                                        }
                                    ),

                                    FutureBuilder(
                                        future: memFuture,
                                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                                            switch (snapshot.connectionState) {
                                                case ConnectionState.active:
                                                    return Text("active");
                                                case ConnectionState.waiting:
                                                    return Center(
                                                        child: Container(
                                                            child: new CircularProgressIndicator(),
                                                            alignment: Alignment(
                                                                0.0, 0.0),
                                                        ),
                                                    );
                                                case ConnectionState.done:
                                                    return new Center(
                                                        child: CircularPercentIndicator(
                                                            radius: 210.0,
                                                            animation: true,
                                                            lineWidth: 40.0,
                                                            percent: (snapshot.data.usagePercent / 100),
                                                            header: new Text("Memory-Usage", textScaleFactor: 2,),
                                                            center: new Text(snapshot.data.usagePercent.toString() + "%"),
                                                            progressColor: Theme.of(context).accentColor,
                                                            backgroundColor: Theme.of(context).primaryColor
                                                        )
                                                    );
                                                default:
                                                    return Text("default");
                                            }
                                        }
                                    ),
                                        FutureBuilder(
                                            future: settingsFuture,
                                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                                                switch (snapshot.connectionState) {
                                                    case ConnectionState.active:
                                                        return Text("active");
                                                    case ConnectionState.waiting:
                                                        return Center(
                                                            child: Container(
                                                                child: new CircularProgressIndicator(),
                                                                alignment: Alignment(
                                                                    0.0, 0.0),
                                                            ),
                                                        );
                                                    case ConnectionState.done:
                                                        return Text(snapshot.data.defaultProfileId.toString());
                                                    default:
                                                        return Text("default");
                                                }
                                            }
                                        )
                                ],
                                );
                            default:
                                return Text("default");
                        }
                    },
            )
        );
    }
}
