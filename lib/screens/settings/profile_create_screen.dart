import 'package:flutter/material.dart';
import 'package:glutter/services/monitoring/database_service.dart';
import 'package:glutter/models/monitoring/profile.dart';
import 'dart:io';

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
    TextEditingController _serverApiVersionController = new TextEditingController();

    _connectionTest() {

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
                                        _connectionTest();
                                    },
                                    icon: Icon(Icons.settings_ethernet),
                                    label:
                                        Text("Start connection test")
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
                        _profileCaptionController.text,
                        _serverApiVersionController.text,
                        context
                    ),
                    label: new Text('Create profile')
                ),
            )
        );
    }
}

_createProfile(String serverAddress, String port, String caption, String apiVersion, BuildContext context) {
    Profile newProfile = new Profile(serverAddress, port, caption, apiVersion);
    DatabaseService.db.insertProfile(newProfile);
    Navigator.pop(context);
}
