import 'package:flutter/material.dart';
import 'package:glutter/screens/settings/profile_form_widget.dart';
import 'package:glutter/services/monitoring/database_service.dart';
import 'package:glutter/models/monitoring/profile.dart';
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
    TextEditingController _glancesPortController = new TextEditingController();
    TextEditingController _glancesApiVersionController = new TextEditingController();

    Future connectionTestResult;

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
                        )
                    ),

                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                floatingActionButton: FloatingActionButton.extended(
                    icon: Icon(Icons.add_circle),
                    onPressed: () => _createProfile(
                        _serverAddressController.text,
                        _glancesPortController.text,
                        _profileCaptionController.text,
                        _glancesApiVersionController.text,
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
