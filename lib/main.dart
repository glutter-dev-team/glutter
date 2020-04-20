import 'package:flutter/material.dart';
import 'glances_service.dart';

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
        home: MyHomePage(title: 'Glutter Home Page'),
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

  final GlancesService glancesService = GlancesService();

  TextEditingController _setServerController = new TextEditingController();

  @override
  void initState() {
    this.glancesService.getServerStatus("sensors").then((value){

      print('Async done');
    });
    super.initState();
    _setServerController.text = this.glancesService.serverAddress;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget> [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 20.0,0.0,20.0),
                    child:
                    SizedBox(width: 250,
                      child:
                      TextFormField(
                        autofocus: false,
                        controller: _setServerController,
                        decoration: InputDecoration(
                          labelText: "Glances API address:",
                        ),
                      ),
                    ),
                  ),
                  FlatButton(
                    color: Colors.deepOrange.shade600,
                    textColor: Colors.white,
                    onPressed: () {
                      glancesService.serverAddress = _setServerController.text;
                      print(glancesService.serverAddress);
                    },
                    child: Text(
                      "Set",
                    ),
                  )
                ]
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                  children: <Widget> [
                    Row(
                        children: <Widget> [
                          Text("Glances data: "),

                        ]
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child:
                            Text(
                              "address: " + glancesService.serverAddress + ", \n"
                                  + "status code: " + glancesService.statusCodeStr + ", \n"
                                  + "resp: " + glancesService.glcsResponse,

                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            )
                        )
                      ],
                    ),
                  ]
              ),
            ),

            FlatButton(
              color: Colors.deepOrange.shade600,
              textColor: Colors.white,
              onPressed: () {
                setState(() {
                  glancesService.getServerStatus("sensors");
                });
              },
              child: Text(
                "Get info",
              ),
            )
          ],
        ),
      ),

      /* floatingActionButton: FloatingActionButton(
        //onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      */

    );
  }
}
