import 'package:flutter/material.dart';
import 'package:glutter/models/shared/profile.dart';
import 'package:glutter/screens/settings/manage_profiles/widgets/profile_form_widgets.dart';
import 'package:glutter/services/shared/database_service.dart';
import 'package:glutter/utils/utils.dart';
import 'package:glutter/widgets/dialogs.dart';

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
        child: WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body: SingleChildScrollView(
                child: Builder(
                  builder: (context) => Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                      child: Column(children: <Widget>[
                        ProfileForm(
                          profileCaptionController: _profileCaptionController,
                          serverAddressController: _serverAddressController,
                          glancesPortController: _serverPortController,
                          glancesApiVersionController: _serverApiVersionController,
                          sshUsernameController: _serverSshUsernameController,
                          sshPortController: _serverSshPortController,
                          sshPasswordController: _serverSshPasswordController,
                        ),
                        SizedBox(height: 25),
                        ConnectionTest(
                          _profileCaptionController.text,
                          _serverAddressController.text,
                          _serverPortController.text,
                          _serverApiVersionController.text,
                          _serverSshUsernameController.text,
                          _serverSshPortController.text,
                          _serverSshPasswordController.text,
                        ),
                        SizedBox(height: 90),
                      ])),
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
                      context),
                  label: new Text('Create profile')),
            )));
  }

  Future<bool> _onWillPop() async {
    // Die Funktion valuesHaveChanged vergleicht die Keys mit den Values in der folgenden Map.
    // Daher muss hier auf dem ProfileCreateScreen eine Map mit leeren Strings auf einer Seite erstellt
    // werden (weil das Formular anfangs leer war), damit der Vergleich funktioniert.
    Map values = {
      _profileCaptionController.text: "",
      _serverAddressController.text: "",
      _serverPortController.text: "",
      _serverApiVersionController.text: "",
      _serverSshUsernameController.text: "",
      _serverSshPortController.text: "",
    };
    if (valuesHaveChanged(values)) {
      return (await showDialog(context: context, builder: (context) => ConfirmLeaveDialog())) ?? false;
    } else {
      Navigator.of(context).pop(false);
      return null;
    }
  }
}

_createProfile(String serverAddress, String port, String sshPort, String caption, String apiVersion, String sshUsername, String sshPassword,
    BuildContext context) {
  Profile newProfile = new Profile(serverAddress, int.parse(port), apiVersion, caption, int.parse(sshPort), sshUsername);
  newProfile.sshPassword = sshPassword;
  DatabaseService.db.insertProfile(newProfile);
  Navigator.pop(context);
}
