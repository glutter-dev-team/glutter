import 'package:flutter/material.dart';
import 'package:glutter/services/shared/database_service.dart';
import 'package:glutter/models/shared/profile.dart';
import 'package:glutter/services/monitoring/glances_service.dart';

class ProfileCreateScreen extends StatefulWidget {
    ProfileCreateScreen({Key key, this.title: "Create new profile"}) : super(key: key);

    static const String routeName = '/settings/profiles/create';
    final String title;

    @override
    _ProfileCreateState createState() => _ProfileCreateState();
}

class _ProfileCreateState extends State<ProfileCreateScreen> {

    TextEditingController _profileCaptionController = new TextEditingController();
    TextEditingController _serverAddressController = new TextEditingController();
    TextEditingController _serverPortController = new TextEditingController();
    TextEditingController _serverSshPortController = new TextEditingController();
    TextEditingController _serverSshUsernameController = new TextEditingController();
    TextEditingController _serverSshPasswordController = new TextEditingController();
    TextEditingController _serverApiVersionController = new TextEditingController();

    Future connectionTestResult;

    _connectionTest() async {
        var address = _serverAddressController.text;
        var port = _serverPortController.text;
        var sshPort = _serverSshPortController.text;
        var sshUsername = _serverSshUsernameController.text;
        var sshPassword = _serverSshPasswordController.text;
        var apiVersion = _serverApiVersionController.text;

        Profile testProfile = new Profile(address, int.parse(port), apiVersion, "test", int.parse(sshPort), sshUsername);
        testProfile.sshPassword = sshPassword;
        GlancesService glances = new GlancesService(testProfile);
        connectionTestResult = glances.connectionTest();
    }

    @override
    void initState() {
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        // This method is rerun every time setState is called
        return GestureDetector(
            // dismiss focus (keyboard) if users taps anywhere in a "dead space" within the app
            // copied from https://flutterigniter.com/dismiss-keyboard-form-lose-focus/
            onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                }
            },
            child: Scaffold(
                appBar: AppBar(
                    title: Text(widget.title),
                ),
                body: Builder(
                    builder: (context) => Padding(
                        padding: EdgeInsets.fromLTRB(20.0,20.0,20.0,0),
                        child: Column(
                            children: <Widget> [
                                /*Row(
                                    children: <Widget>[
                                        Container(
                                            child: TextField(
                                                controller: _profileCaptionController,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'Caption / Name / Title',
                                                    labelStyle: new TextStyle(fontSize: 14.0,),
                                                    hintText: '2 or 3',
                                                    hintStyle: new TextStyle(fontSize: 14.0,),
                                                )
                                            ),
                                        ),

                                    ]
                                ),*/
                                //Text("test123"),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                        Expanded(
                                            child: Column(
                                                children: <Widget>[
                                                    Container(
                                                        child: TextField(
                                                            controller: _profileCaptionController,
                                                            decoration: InputDecoration(
                                                                border: OutlineInputBorder(),
                                                                labelText: 'Caption / Name / Title',
                                                                hintText: 'e.g. My NAS @ Home',
                                                            )
                                                        )),
                                                ],
                                            ),
                                        ),
                                        /*
                                        IconButton(
                                            icon: Icon(Icons.help_outline),
                                            tooltip: 'Show help text',
                                            onPressed: () {
                                                // Popup (Modal/Dialog) Fenster mit Text anzeigen
                                            },
                                        ),
                                        */
                                    ],
                                ),
                                SizedBox(
                                    height: 15,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                        Expanded(
                                            child: TextField(
                                                controller: _serverAddressController,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'Server address',
                                                    hintText: 'e.g. example.com or 123.45.678.9',
                                                )
                                            ),
                                        ),
                                        /*
                                        IconButton(
                                            icon: Icon(Icons.help_outline),
                                            tooltip: 'Show help text',
                                            onPressed: () {
                                                // Popup (Modal/Dialog) Fenster mit Text anzeigen
                                            },
                                        ),
                                        */
                                    ],
                                ),
                                SizedBox(
                                    height: 15,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                        Expanded(
                                            child: Column(
                                                children: <Widget>[
                                                    Container(
                                                        child: TextField(
                                                            controller: _serverPortController,
                                                            decoration: InputDecoration(
                                                                border: OutlineInputBorder(),
                                                                labelText: 'Server port',
                                                                hintText: 'default: 61208',
                                                            )
                                                        )),
                                                ],
                                            ),
                                        ),
                                        /*
                                        IconButton(
                                            icon: Icon(Icons.help_outline),
                                            tooltip: 'Show help text',
                                            onPressed: () {
                                                // Popup (Modal/Dialog) Fenster mit Text anzeigen
                                            },
                                        ),
                                        */
                                    ],
                                ),
                                SizedBox(
                                    height: 15,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                        Expanded(
                                            child: Column(
                                                children: <Widget>[
                                                    Container(
                                                        child: TextField(
                                                            controller: _serverSshPortController,
                                                            decoration: InputDecoration(
                                                                border: OutlineInputBorder(),
                                                                labelText: 'Server SSH-Port',
                                                                hintText: 'default: 22',
                                                            )
                                                        )),
                                                ],
                                            ),
                                        ),
                                        /*
                                        IconButton(
                                            icon: Icon(Icons.help_outline),
                                            tooltip: 'Show help text',
                                            onPressed: () {
                                                // Popup (Modal/Dialog) Fenster mit Text anzeigen
                                            },
                                        ),
                                        */
                                    ],
                                ),
                                SizedBox(
                                    height: 15,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                        Expanded(
                                            child: Column(
                                                children: <Widget>[
                                                    Container(
                                                        child: TextField(
                                                            controller: _serverSshUsernameController,
                                                            decoration: InputDecoration(
                                                                border: OutlineInputBorder(),
                                                                labelText: 'Server SSH-Username',
                                                                hintText: 'username',
                                                            )
                                                        )),
                                                ],
                                            ),
                                        ),
                                        /*
                                        IconButton(
                                            icon: Icon(Icons.help_outline),
                                            tooltip: 'Show help text',
                                            onPressed: () {
                                                // Popup (Modal/Dialog) Fenster mit Text anzeigen
                                            },
                                        ),
                                        */
                                    ],
                                ),
                                SizedBox(
                                    height: 15,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                        Expanded(
                                            child: Column(
                                                children: <Widget>[
                                                    Container(
                                                        child: TextField(
                                                            controller: _serverSshPasswordController,
                                                            decoration: InputDecoration(
                                                                border: OutlineInputBorder(),
                                                                labelText: 'Server SSH-Password',
                                                                hintText: 'password',
                                                            )
                                                        )),
                                                ],
                                            ),
                                        ),
                                        /*
                                        IconButton(
                                            icon: Icon(Icons.help_outline),
                                            tooltip: 'Show help text',
                                            onPressed: () {
                                                // Popup (Modal/Dialog) Fenster mit Text anzeigen
                                            },
                                        ),
                                        */
                                    ],
                                ),
                                SizedBox(
                                    height: 15,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                        Expanded(
                                            child: TextField(
                                                controller: _serverApiVersionController,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'Glances API version',
                                                    hintText: '2 or 3',
                                                )
                                            ),
                                        ),
                                        /*
                                        IconButton(
                                            icon: Icon(Icons.help_outline),
                                            tooltip: 'Show help text',
                                            onPressed: () {
                                                // Popup (Modal/Dialog) Fenster mit Text anzeigen
                                            },
                                        ),
                                        */
                                    ],
                                ),
                                SizedBox(
                                    height: 25,
                                ),
                                FlatButton.icon(
                                    onPressed: () {
                                        setState(() {
                                            _connectionTest();
                                        });
                                    },
                                    icon: Icon(Icons.settings_ethernet),
                                    label:
                                        Text("Start connection test")
                                ),
                                FutureBuilder(
                                    future: connectionTestResult,
                                    builder: (BuildContext context, AsyncSnapshot snapshot){
                                        switch (snapshot.connectionState) {
                                            case ConnectionState.none:
                                                return Text("");
                                            case ConnectionState.active:
                                                return Text("Connection active");
                                            case ConnectionState.waiting:
                                                return Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                        Container(
                                                            width: 20,
                                                            child: new LinearProgressIndicator(
                                                                backgroundColor: Colors.grey,
                                                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                                                            ),
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets.only(left: 5.0),
                                                            child: Text("Connection test running..."),
                                                        )
                                                    ]
                                                );
                                            case ConnectionState.done:
                                                if (snapshot.data == true) {
                                                    return Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                            Icon(
                                                                Icons.check_circle,
                                                                color: Colors.green,),
                                                            Padding(
                                                                padding: EdgeInsets.only(left: 5.0),
                                                                child: Text("Connection test successful!"),
                                                            )
                                                        ]
                                                    );

                                                } else {
                                                    return Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                            Icon(
                                                                Icons.error,
                                                                color: Colors.red,),
                                                            Padding(
                                                                padding: EdgeInsets.only(left: 5.0),
                                                                child: Text("Connection test failed!"),
                                                            )
                                                        ]
                                                    );
                                                }
                                                return Text("no result");
                                            default:
                                                return Text("default");
                                        }
                                    }
                                ),
                            ]
                        )
                    ),

                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                floatingActionButton: FloatingActionButton.extended(
                    icon: Icon(Icons.add_circle),
                    onPressed: () => _createProfile(
                        _serverAddressController.text,
                        _serverPortController.text,
                        _serverSshPortController.text,
                        _profileCaptionController.text,
                        _serverApiVersionController.text,
                        _serverSshUsernameController.text,
                        _serverSshPasswordController.text,
                        context
                    ),
                    label: new Text('Create profile')
                ),
            )
        );
    }
}

_createProfile(String serverAddress, String port, String sshPort, String caption, String apiVersion, String sshUsername, String sshPassword, BuildContext context) {
    Profile newProfile = new Profile(serverAddress, int.parse(port), apiVersion, caption, int.parse(sshPort), sshUsername);
    newProfile.sshPassword = sshPassword;
    DatabaseService.db.insertProfile(newProfile);
    Navigator.pop(context);
}
