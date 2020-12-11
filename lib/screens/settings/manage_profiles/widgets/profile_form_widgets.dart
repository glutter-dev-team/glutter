import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glutter/models/shared/profile.dart';
import 'package:glutter/services/monitoring/glances_service.dart';

class ProfileForm extends StatelessWidget {
  ProfileForm(
      {this.profileCaptionController,
      this.serverAddressController,
      this.glancesPortController,
      this.glancesApiVersionController,
      this.sshUsernameController,
      this.sshPortController,
      this.sshPasswordController});

  final TextEditingController profileCaptionController;
  final TextEditingController serverAddressController;
  final TextEditingController glancesPortController;
  final TextEditingController glancesApiVersionController;
  final TextEditingController sshUsernameController;
  final TextEditingController sshPortController;
  final TextEditingController sshPasswordController;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(child: ProfileCaptionTextField(profileCaptionController)),
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
          Expanded(child: ServerAddressTextField(serverAddressController)),
        ],
      ),
      SizedBox(
        height: 35,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(child: GlancesPortTextField(glancesPortController)),
        ],
      ),
      SizedBox(
        height: 15,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(child: GlancesApiVersionTextField(glancesApiVersionController)),
        ],
      ),
      SizedBox(
        height: 35,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(child: SshPortTextField(sshPortController)),
        ],
      ),
      SizedBox(
        height: 15,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(child: SshUsernameTextField(sshUsernameController)),
        ],
      ),
      SizedBox(
        height: 15,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(child: SshPasswordTextField(sshPasswordController)),
        ],
      ),
    ]);
  }
}

class ProfileCaptionTextField extends StatelessWidget {
  ProfileCaptionTextField(this.profileCaptionController); // this.context,

  //final BuildContext context;
  final TextEditingController profileCaptionController;

  @override
  Widget build(BuildContext context) {
    return TextField(
        autocorrect: false,
        controller: profileCaptionController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Caption / Name / Title',
          hintText: 'e.g. My NAS @ Home',
        )
    );
  }
}

class ServerAddressTextField extends StatelessWidget {
  ServerAddressTextField(this.serverAddressController);

  final TextEditingController serverAddressController;

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: serverAddressController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Server address',
          hintText: 'e.g. example.com or 123.45.678.9',
        // TODO: InputFormatter mit RegEx, die Leerzeichen ausschliesst
        )
    );
  }
}

class GlancesPortTextField extends StatelessWidget {
  GlancesPortTextField(this.glancesPortController);

  final TextEditingController glancesPortController;

  @override
  Widget build(BuildContext context) {
    return TextField(
        autocorrect: false,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
        controller: glancesPortController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Glances port',
          hintText: 'default: 61208',
        )
    );
  }
}

class SshPortTextField extends StatelessWidget {
  SshPortTextField(this.sshPortController);

  final TextEditingController sshPortController;

  @override
  Widget build(BuildContext context) {
    return TextField(
        autocorrect: false,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
        controller: sshPortController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'SSH port',
          hintText: 'default: 22',
        )
    );
  }
}

class SshUsernameTextField extends StatelessWidget {
  SshUsernameTextField(this.sshUsernameController);

  final TextEditingController sshUsernameController;

  @override
  Widget build(BuildContext context) {
    return TextField(
        autocorrect: false,
        controller: sshUsernameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'SSH username',
          hintText: 'username',
        )
      // TODO: InputFormatter mit RegEx, die Leerzeichen ausschliesst
    );
  }
}

class SshPasswordTextField extends StatelessWidget {
  SshPasswordTextField(this.sshPasswordController);

  final TextEditingController sshPasswordController;

  @override
  Widget build(BuildContext context) {
    return TextField(
        autocorrect: false,
        obscureText: true,
        obscuringCharacter: "*",
        controller: sshPasswordController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'SSH password',
          hintText: 'password',
        )
    );
  }
}

class GlancesApiVersionTextField extends StatelessWidget {
  GlancesApiVersionTextField(this.glancesApiVersionController);

  final TextEditingController glancesApiVersionController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: TextField(
              controller: glancesApiVersionController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
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
    );
  }
}

class ConnectionTest extends StatefulWidget {
  ConnectionTest(
      this.profileCaption, this.serverAddress, this.glancesPort, this.glancesApiVersion, this.sshUsername, this.sshPort, this.sshPassword);

  final String profileCaption;
  final String serverAddress;
  final String glancesPort;
  final String glancesApiVersion;
  final String sshUsername;
  final String sshPort;
  final String sshPassword;

  @override
  _ConnectionTestState createState() =>
      _ConnectionTestState(profileCaption, serverAddress, glancesPort, glancesApiVersion, sshUsername, sshPort, sshPassword);
}

class _ConnectionTestState extends State<ConnectionTest> {
  _ConnectionTestState(
      this.profileCaption, this.serverAddress, this.glancesPort, this.glancesApiVersion, this.sshUsername, this.sshPort, this.sshPassword);

  final String profileCaption;
  final String serverAddress;
  final String glancesPort;
  final String glancesApiVersion;
  final String sshUsername;
  final String sshPort;
  final String sshPassword;

  Future connectionTestResult;

  _connectionTest() async {
    Profile testProfile = new Profile(serverAddress, int.parse(glancesPort), glancesApiVersion, "test", int.parse(sshPort), sshUsername);
    testProfile.sshPassword = sshPassword;
    GlancesService glances = new GlancesService(testProfile);
    connectionTestResult = glances.connectionTest();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlatButton.icon(
            onPressed: () {
              setState(() {
                _connectionTest();
              });
            },
            icon: Icon(Icons.settings_ethernet),
            label: Text("Start connection test")),
        FutureBuilder(
            future: connectionTestResult,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text("");
                case ConnectionState.active:
                  return Text("Connection active");
                case ConnectionState.waiting:
                  return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
                  ]);
                case ConnectionState.done:
                  if (snapshot.data == true) {
                    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Text("Connection test successful!"),
                      )
                    ]);
                  } else {
                    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                      Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Text("Connection test failed!"),
                      )
                    ]);
                  }
                  return Text("no result");
                default:
                  return Text("default");
              }
            }),
      ],
    );
  }
}
