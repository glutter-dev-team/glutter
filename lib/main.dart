import 'package:flutter/material.dart';
import 'Monitoring/Services/glances_service.dart';
import 'Monitoring/Entities/profile.dart';
import 'dart:async';

void main() {
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Glutter',
            theme: ThemeData(
                primarySwatch: Colors.deepPurple,
                brightness: Brightness.dark, // das könnte später über den User-Preferences-Screen individuell anpassbar sein und in sqlite gespeichert werden
                visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: MyHomePage(title: 'Glutter Dashboard'),
        );
    }
}

class MyHomePage extends StatefulWidget {
    MyHomePage({Key key, this.title}) : super(key: key);

    final String title;

    @override
    _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

    TextEditingController _serverAddressController = new TextEditingController();
    TextEditingController _serverPortController = new TextEditingController();
    TextEditingController _serverApiVersionController = new TextEditingController();

    Profile defaultProfile;
    GlancesService glances;
    Profile tempProfile;

    Future memoryFuture;
    List<Map> memoryList = new List();

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

    void memoryListBuilder(AsyncSnapshot snapshot) {
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
    }

    @override
    Widget build(BuildContext context) {
        // This method is rerun every time setState is called
        return Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
            ),
            body:Builder(
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
                                                    _showToast(context, "Generated address: "+tempProfile.getFullServerAddress());
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
                                                        return new CircularProgressIndicator(); //Text("Active and maybe waiting");
                                                    case ConnectionState.done:
                                                        memoryListBuilder(snapshot);
                                                        return ListView.builder(
                                                            scrollDirection: Axis.vertical,
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

            /* floatingActionButton: FloatingActionButton(
                //onPressed: _incrementCounter,
                tooltip: 'Increment',
                child: Icon(Icons.add),
                ), // This trailing comma makes auto-formatting nicer for build methods.
            */

        );
    }

    void _showToast(BuildContext context, String message) {
        final scaffold = Scaffold.of(context);
        scaffold.showSnackBar(
            SnackBar(
                content: Text(message),
                action: SnackBarAction(
                    label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
            ),
        );
    }
}
