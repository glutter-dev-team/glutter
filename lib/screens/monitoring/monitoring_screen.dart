import 'package:flutter/material.dart';
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

    TextEditingController _serverAddressController = new TextEditingController();
    TextEditingController _serverPortController = new TextEditingController();
    TextEditingController _serverApiVersionController = new TextEditingController();

    Profile defaultProfile;
    GlancesService glances;
    Profile tempProfile;

    Future memoryFuture;

    @override
    void initState() {
        // hier wird ein Default-Profil festgelegt, das beim Laden der App angewandt wird (solange, bis ein funktionierendes System für das Speichern der eigenen Profile haben, mit DB)
        this._serverAddressController.text = "pi0w1";
        this._serverPortController.text = "61208";
        this._serverApiVersionController.text = "3";

        this.defaultProfile = new Profile(this._serverAddressController.text, this._serverPortController.text , "default profile", this._serverApiVersionController.text);
        this.glances = new GlancesService(this.defaultProfile);

        super.initState();

        memoryFuture = this.glances.getMemory();
        //print(memoryFuture);
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
                                    Container(
                                        width: 110.0,
                                        child: TextField(
                                            controller: _serverAddressController,
                                            decoration: InputDecoration(
                                                //border: OutlineInputBorder(),
                                                labelText: 'Server address',
                                                labelStyle: new TextStyle(fontSize: 14.0,),
                                                hintText: 'IP or domain',
                                                hintStyle: new TextStyle(fontSize: 14.0,),
                                            )
                                        )
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left:10.0),
                                        child: Container(
                                            width: 75.0,
                                            child: TextField(
                                                controller: _serverPortController,
                                                decoration: InputDecoration(
                                                    //border: OutlineInputBorder(),
                                                    labelText: 'Port',
                                                    labelStyle: new TextStyle(fontSize: 14.0,),
                                                    hintText: 'Def.: 61208',
                                                    hintStyle: new TextStyle(fontSize: 14.0,),
                                                )
                                            )
                                        ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left:10.0),
                                        child: Container(
                                            width: 75.0,
                                            child: TextField(
                                                controller: _serverApiVersionController,
                                                decoration: InputDecoration(
                                                    //border: OutlineInputBorder(),
                                                    labelText: 'Glances Version',
                                                    labelStyle: new TextStyle(fontSize: 14.0,),
                                                    hintText: '2 or 3',
                                                    hintStyle: new TextStyle(fontSize: 14.0,),
                                                )
                                            )
                                        ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left:1.0),
                                        child: RaisedButton(
                                            onPressed: () {
                                                // bei jedem Klick auf den "Set"-Button wird das Profil abhängig von den eingebenen Werten aktualisiert und es werden die aktuellsten Daten geladen
                                                setState(() {
                                                    this.tempProfile = new Profile(_serverAddressController.text,_serverPortController.text,"temporary profile",_serverApiVersionController.text);
                                                    this.glances = new GlancesService(tempProfile);
                                                    showToast(context, "Generated address: "+tempProfile.getFullServerAddress());
                                                    memoryFuture = this.glances.getMemory();
                                                });

                                            },
                                            child: Text(
                                                "Set",
                                            ),
                                        )
                                    )
                                ],
                            ),
                            Row(
                                children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(top:10.0),
                                        child: Text("Memory",
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
                                            future: memoryFuture,
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
                                                        List<Map> memoryList = memoryListBuilder(snapshot);
                                                        return ListView.builder(
                                                            scrollDirection: Axis.vertical,
                                                            physics: NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount: memoryList.length,
                                                            itemBuilder: (BuildContext context, int index){
                                                                return ListTile(
                                                                    title: Text(memoryList[index]["short_desc"].toString()),
                                                                    subtitle: Text(memoryList[index]["value"].toString()), //snapshot.data.total.toString()
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
