import 'package:flutter/material.dart';
import 'Monitoring/Services/glances_service.dart';
import 'Monitoring/Entities/profile.dart';

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
                primarySwatch: Colors.deepOrange,
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

    //final GlancesService glancesService = GlancesService();

    TextEditingController _serverAddressController = new TextEditingController();
    TextEditingController _serverPortController = new TextEditingController();
    TextEditingController _serverApiVersionController = new TextEditingController();

    Profile defaultProfile;
    GlancesService glances;
    Profile tempProfile;

    @override
    void initState() {
        this.defaultProfile = new Profile("192.168.1.220", "61208", "default profile", "3");
        this.glances = new GlancesService(defaultProfile);

        // print('Async done');
        //});
        super.initState();
        //_setServerController.text = this.glancesService.serverAddress;
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
                    padding: EdgeInsets.all(10.0),
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
                                                this.tempProfile = new Profile(_serverAddressController.text,_serverPortController.text,"temporary profile",_serverApiVersionController.text);
                                                this.glances = new GlancesService(tempProfile);
                                                _showToast(context, "Generated address: "+tempProfile.getFullServerAddress());
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
                                    FutureBuilder(
                                        future: this.glances.getCpu(),
                                        builder: (BuildContext context, AsyncSnapshot snapshot){
                                            if(snapshot.data == null){
                                                return Container(
                                                    child: Center(
                                                        child: Text("Loading..."),
                                                    )
                                                );
                                            } else{
                                                return ListView.builder(
                                                    itemCount: snapshot.data.length,
                                                    itemBuilder: (BuildContext context, int index){
                                                        return ListTile(
                                                            title: Text("CPU Total"),
                                                            subtitle: Text(snapshot.data[index].totalLoad),
                                                        );
                                                    }
                                                );
                                            }
                                        }
                                    )
                                ],
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
