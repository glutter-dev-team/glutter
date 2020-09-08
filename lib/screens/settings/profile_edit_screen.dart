import 'package:flutter/material.dart';
import 'package:glutter/screens/settings/profile_form_widget.dart';
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

    final TextEditingController _profileCaptionController = new TextEditingController();
    final TextEditingController _serverAddressController = new TextEditingController();
    final TextEditingController _glancesPortController = new TextEditingController();
    final TextEditingController _glancesApiVersionController = new TextEditingController();

    Future connectionTestResult;

    bool initialWrite = false;

    _connectionTest() async {
        String address = _serverAddressController.text;
        String port = _glancesPortController.text;
        String apiVersion = _glancesApiVersionController.text;

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

        if (!initialWrite) {
            _profileCaptionController.text = profile.caption;
            _serverAddressController.text = profile.serverAddress;
            _glancesPortController.text = profile.port;
            _glancesApiVersionController.text = profile.glancesApiVersion;
            initialWrite = true;
        }

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
            child: WillPopScope(
                onWillPop: _onWillPop,
                child: new Scaffold(
                    appBar: AppBar(
                        title: Text("Edit profile " + profile.caption),
                        actions: [
                            IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) => _showDeleteDialog(context, profile)
                                    );
                                },
                            )
                        ],
                    ),
                    body: Builder(
                        builder: (context) => Padding(
                            padding: EdgeInsets.fromLTRB(20.0,20.0,20.0,0),
                            child: Column(
                                children: <Widget> [
                                    ProfileForm(
                                        profileCaptionController: _profileCaptionController,
                                        serverAddressController: _serverAddressController,
                                        glancesPortController: _glancesPortController,
                                        glancesApiVersionController: _glancesApiVersionController,
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
                            ),
                        ),

                    ),
                    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                    floatingActionButton: FloatingActionButton.extended(
                        icon: Icon(Icons.save),
                        onPressed: () => _saveProfile(
                            profile,
                            _serverAddressController.text,
                            _glancesPortController.text,
                            _profileCaptionController.text,
                            _glancesApiVersionController.text,
                            context
                        ),
                        label: new Text('Save profile')
                    ),
                )
            )
        );
    }

    /// Overrides the "Back" buttons (in AppBar and back button of device). Before going back: check if user changed anything. If true: show confirmation alert. Else: go back without doing anything else.
    Future<bool> _onWillPop() async {
        final Profile profile = ModalRoute.of(context).settings.arguments;
        if (_changedValues(profile)) {
            return (await showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                    title: new Text('Are you sure?'),
                    content: new Text('Do you want to leave without saving? You are going to lose your changes!'),
                    actions: <Widget>[
                        new FlatButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: new Text('No'),
                        ),
                        new FlatButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: new Text('Yes'),
                        ),
                    ],
                ),
            )) ?? false;
        } else {
            Navigator.of(context).pop(false);
            return null;
        }
    }

    /// Checks if the user changed any values of the profile (compared to the most recent version of the profile in the database)
    bool _changedValues(Profile profile) {
        if (_profileCaptionController.text != profile.caption) {
            return true;
        } else if (_serverAddressController.text != profile.serverAddress) {
            return true;
        } else if (_glancesPortController.text != profile.port) {
            return true;
        } else if (_glancesApiVersionController.text != profile.glancesApiVersion) {
            return true;
        } else {
            return false;
        }
    }
}

/// Save current values of text input fields by updating the existing profile in the database.
_saveProfile(Profile profile, String serverAddress, String port, String caption, String apiVersion, BuildContext context) {
    profile.serverAddress = serverAddress;
    profile.port = port;
    profile.caption = caption;
    profile.glancesApiVersion = apiVersion;

    DatabaseService.db.updateProfile(profile);
    Navigator.pop(context);
}

_showDeleteDialog(BuildContext context, Profile profile) {
    return AlertDialog(
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
    );
}
