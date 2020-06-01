import 'package:flutter/material.dart';
import 'package:glutter/services/monitoring/database_service.dart';
import 'package:glutter/models/monitoring/profile.dart';
import 'package:glutter/services/monitoring/glances_service.dart';

class ProfileEditScreen extends StatefulWidget {
    ProfileEditScreen({Key key,}) : super(key: key);

    static const String routeName = '/settings/profiles/edit/{id}';

    @override
    _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEditScreen> {

    TextEditingController _profileCaptionController = new TextEditingController();
    TextEditingController _serverAddressController = new TextEditingController();
    TextEditingController _serverPortController = new TextEditingController();
    TextEditingController _serverApiVersionController = new TextEditingController();

    Future connectionTestResult;

    _connectionTest() async {
        var address = _serverAddressController.text;
        var port = _serverPortController.text;
        var apiVersion = _serverApiVersionController.text;

        Profile testProfile = new Profile(address, port, "test", apiVersion);
        GlancesService glances = new GlancesService(testProfile);
        connectionTestResult = glances.connectionTest();
    }

    @override
    void initState() {
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        final Profile profile = ModalRoute.of(context).settings.arguments;
        _profileCaptionController.text = profile.caption;
        _serverAddressController.text = profile.serverAddress;
        _serverPortController.text = profile.port;
        _serverApiVersionController.text = profile.glancesApiVersion;

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
                    title: Text("Edit profile " + profile.caption),
                    actions: [
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {

                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                        title: Text("Delete profile?"),
                                        content: Text("Do you really want to delete this profile called '" + profile.caption + "'?"),
                                        actions: [
                                            FlatButton(
                                                onPressed: () {
                                                    Navigator.pop(context);
                                                },
                                                child: Text(
                                                    "Cancel",
                                                ),
                                            ),
                                            FlatButton(
                                                onPressed: () {
                                                    DatabaseService.db.deleteProfileById(profile.id);

                                                    //Navigator.popUntil(context, ModalRoute.withName('/settings/profiles'));
                                                    var count = 0;
                                                    Navigator.popUntil(context, (route) {
                                                        return count++ == 2;
                                                    });
                                                },
                                                child: Text(
                                                    "Delete",
                                                    style: TextStyle(color: Colors.red),
                                                ),
                                            ),
                                        ],
                                    ),
                                );

                               /* DatabaseService.db.deleteProfileById(profile.id);
                                Navigator.pop(context);*/
                            },
                        )
                    ],
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
                    icon: Icon(Icons.save),
                    onPressed: () => _saveProfile(
                        profile,
                        _serverAddressController.text,
                        _serverPortController.text,
                        _profileCaptionController.text,
                        _serverApiVersionController.text,
                        context
                    ),
                    label: new Text('Save profile')
                ),
            )
        );
    }
}

_saveProfile(Profile profile, String serverAddress, String port, String caption, String apiVersion, BuildContext context) {
    profile.serverAddress = serverAddress;
    profile.port = port;
    profile.caption = caption;
    profile.glancesApiVersion = apiVersion;

    DatabaseService.db.updateProfile(profile);
    Navigator.pop(context);
}
