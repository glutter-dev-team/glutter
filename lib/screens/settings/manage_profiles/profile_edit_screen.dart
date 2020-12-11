import 'package:flutter/material.dart';
import 'package:glutter/models/shared/profile.dart';
import 'package:glutter/screens/settings/manage_profiles/widgets/dialogs.dart';
import 'package:glutter/screens/settings/manage_profiles/widgets/profile_form_widgets.dart';
import 'package:glutter/services/shared/database_service.dart';
import 'package:glutter/utils/utils.dart';
import 'package:glutter/widgets/dialogs.dart';

class ProfileEditScreen extends StatefulWidget {
  ProfileEditScreen({
    Key key,
  }) : super(key: key);

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

  bool initialWrite = false;

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
      _serverPortController.text = profile.port.toString();
      _serverSshPortController.text = profile.sshPort.toString();
      _serverSshUsernameController.text = profile.sshUsername;
      _serverSshPasswordController.text = "*Password hidden*";
      _serverApiVersionController.text = profile.glancesApiVersion;

      initialWrite = true;
    }

    return GestureDetector(
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
                        SizedBox(
                          height: 25,
                        ),
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
                      ])
                  ),
                ),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              floatingActionButton: FloatingActionButton.extended(
                  icon: Icon(Icons.save),
                  onPressed: () => _saveProfile(
                      context,
                      profile,
                      _profileCaptionController.text,
                      _serverAddressController.text,
                      int.parse(_serverPortController.text),
                      _serverApiVersionController.text,
                      int.parse(_serverSshPortController.text),
                      _serverSshUsernameController.text,
                      _serverSshPasswordController.text),
                  label: new Text('Save profile')),
            )
        )
    );
  }

  /// Overrides the "Back" buttons (in AppBar and back button of device). Before going back: check if user changed anything. If true: show confirmation alert. Else: go back without doing anything else.
  Future<bool> _onWillPop() async {
    final Profile profile = ModalRoute.of(context).settings.arguments;

    Map values = {
      profile.caption: _profileCaptionController.text,
      profile.serverAddress: _serverAddressController.text,
      profile.port.toString(): _serverPortController.text,
      profile.glancesApiVersion: _serverApiVersionController.text,
      profile.sshUsername: _serverSshUsernameController.text,
      profile.sshPort.toString(): _serverSshPortController.text,
    };

    if (valuesHaveChanged(values)) {
      return (await showDialog(context: context, builder: (context) => ConfirmLeaveDialog())) ?? false;
    } else {
      Navigator.of(context).pop(false);
      return null;
    }
  }
}

_saveProfile(
    BuildContext context,
    Profile profile,
    String profileCaption,
    String serverAddress,
    int glancesPort,
    String glancesApiVersion,
    int sshPort,
    String sshUsername,
    String sshPassword) {
  profile.caption = profileCaption;
  profile.serverAddress = serverAddress;
  profile.port = glancesPort;
  profile.glancesApiVersion = glancesApiVersion;
  profile.sshUsername = sshUsername;
  profile.sshPort = sshPort;
  profile.sshPassword = sshPassword;

  DatabaseService.db.updateProfile(profile);
  Navigator.pop(context);
}
