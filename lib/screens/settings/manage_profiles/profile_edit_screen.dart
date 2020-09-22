import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glutter/services/shared/database_service.dart';
import 'package:glutter/models/shared/profile.dart';
import 'package:glutter/services/monitoring/glances_service.dart';
import 'package:glutter/widgets/dialogs.dart';

class ProfileEditScreen extends StatefulWidget {
    ProfileEditScreen({Key key,}) : super(key: key);

    static const String routeName = '/settings/profiles/edit/{id}';

    @override
    _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEditScreen> {

    TextEditingController _profileCaptionController = new TextEditingController();
    TextEditingController _serverAddressController = new TextEditingController();
    TextEditingController _serverSshPortController = new TextEditingController();
    TextEditingController _serverPortController = new TextEditingController();
    TextEditingController _serverSshUsernameController = new TextEditingController();
    TextEditingController _serverSshPasswordController = new TextEditingController();
    TextEditingController _serverApiVersionController = new TextEditingController();

    Future connectionTestResult;
    bool initialWrite = false;

    _connectionTest() async {
        var address = _serverAddressController.text;
        var port = _serverPortController.text;
        var sshPort = _serverSshPortController.text;
        var sshUsername = _serverSshUsernameController.text;
        var sshPassword = _serverSshPasswordController.text;
        var apiVersion = _serverApiVersionController.text;

        Profile testProfile = new Profile(address, int.parse(port), apiVersion, "test", int.parse(sshPort), sshUsername, );
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
        final Profile profile = ModalRoute.of(context).settings.arguments;

        if(!initialWrite) {
            _profileCaptionController.text = profile.caption;
            _serverAddressController.text = profile.serverAddress;
            _serverPortController.text = profile.port.toString();
            _serverSshPortController.text = profile.sshPort.toString();
            _serverSshUsernameController.text = profile.sshUsername;
            _serverSshPasswordController.text = "*Password hidden*";
            _serverApiVersionController.text = profile.glancesApiVersion;

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
                                        builder: (_) => ConfirmDeleteProfileDialog(context, profile),
                                    );
                                },
                            )
                        ],
                    ),
                    body: SingleChildScrollView(
                        child: Builder(
                            builder: (context) => Padding(
                                padding: EdgeInsets.fromLTRB(20.0,20.0,20.0,0),
                                child: Column(
                                    children: <Widget> [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                                Expanded(
                                                    child: TextField(
                                                        autocorrect: false,
                                                        controller: _profileCaptionController,
                                                        decoration: InputDecoration(
                                                            border: OutlineInputBorder(),
                                                            labelText: 'Caption / Name / Title',
                                                            hintText: 'e.g. My NAS @ Home',
                                                        )
                                                    ),
                                                ),
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
                                                        /*inputFormatters: <TextInputFormatter>[
                                                            // hier muss eine RegEx hin, die Leerzeichen ausschließt
                                                            // https://api.flutter.dev/flutter/services/FilteringTextInputFormatter-class.html
                                                        ],*/
                                                        decoration: InputDecoration(
                                                            border: OutlineInputBorder(),
                                                            labelText: 'Server address',
                                                            hintText: 'e.g. example.com or 123.45.678.9',
                                                        )
                                                    ),
                                                ),
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
                                                                    autocorrect: false,
                                                                    keyboardType: TextInputType.number,
                                                                    inputFormatters: <TextInputFormatter>[
                                                                        FilteringTextInputFormatter.digitsOnly
                                                                    ],
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
                                                                    autocorrect: false,
                                                                    keyboardType: TextInputType.number,
                                                                    inputFormatters: <TextInputFormatter>[
                                                                        FilteringTextInputFormatter.digitsOnly
                                                                    ],
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
                                                                    autocorrect: false,
                                                                    controller: _serverSshUsernameController,
                                                                    /*inputFormatters: <TextInputFormatter>[
                                                                        // hier muss eine RegEx hin, die Leerzeichen ausschließt
                                                                        // https://api.flutter.dev/flutter/services/FilteringTextInputFormatter-class.html
                                                                    ],*/
                                                                    decoration: InputDecoration(
                                                                        border: OutlineInputBorder(),
                                                                        labelText: 'Server SSH-Username',
                                                                        hintText: 'username',
                                                                    )
                                                                )),
                                                        ],
                                                    ),
                                                ),
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
                                                                    autocorrect: false,
                                                                    obscureText: true,
                                                                    obscuringCharacter: "*",
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
                                                        keyboardType: TextInputType.number,
                                                        inputFormatters: <TextInputFormatter>[
                                                            FilteringTextInputFormatter.digitsOnly
                                                            // hier muss eine RegEx hin, die nur 2 oder 3 zulässt (besser wäre allerdings eine andere Input-Methode, also kein TextField)
                                                        ],
                                                        autocorrect: false,
                                                        decoration: InputDecoration(
                                                            border: OutlineInputBorder(),
                                                            labelText: 'Glances API version',
                                                            hintText: '2 or 3',
                                                        )
                                                    ),
                                                ),
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
                    ),
                    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                    floatingActionButton: FloatingActionButton.extended(
                        icon: Icon(Icons.save),
                        onPressed: () => _saveProfile(
                            profile,
                            _serverAddressController.text,
                            int.parse(_serverPortController.text),
                            int.parse(_serverSshPortController.text),
                            _profileCaptionController.text,
                            _serverApiVersionController.text,
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
                builder: (context) => ConfirmLeaveDialog()
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
        } else if (_serverPortController.text != profile.port.toString()) {
            return true;
        } else if (_serverApiVersionController.text != profile.glancesApiVersion) {
            return true;
        } else {
            return false;
        }
    }
}

_saveProfile(Profile profile, String serverAddress, int port, int sshPort, String caption, String apiVersion, BuildContext context) {
    /// Save current values of text input fields by updating the existing profile in the database.
    _saveProfile(Profile profile, String serverAddress, int port,
        String caption, String apiVersion, BuildContext context) {
        profile.serverAddress = serverAddress;
        profile.port = port;
        profile.sshPort = sshPort;
        profile.caption = caption;
        profile.glancesApiVersion = apiVersion;

        DatabaseService.db.updateProfile(profile);
        Navigator.pop(context);
    }
}
