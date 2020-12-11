import 'package:flutter/material.dart';
import 'package:glutter/models/remote_control/command.dart';
import 'package:glutter/screens/remote_control/widgets/command_form_widgets.dart';
import 'package:glutter/services/shared/database_service.dart';
import 'package:glutter/services/shared/preferences_service.dart';
import 'package:glutter/utils/utils.dart';
import 'package:glutter/widgets/dialogs.dart';

class CommandCreateScreen extends StatefulWidget {
  CommandCreateScreen({Key key, this.title: "Create new Command"}) : super(key: key);

  static const String routeName = '/remote-control/create';
  final String title;

  @override
  _CommandCreateState createState() => _CommandCreateState();
}

class _CommandCreateState extends State<CommandCreateScreen> {

  TextEditingController _commandCaptionController = new TextEditingController();
  TextEditingController _commandMessageController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                      padding: EdgeInsets.fromLTRB(20.0,20.0,20.0,0),
                      child: Column(
                          children: <Widget> [
                            CommandForm(
                              commandCaptionController: this._commandCaptionController,
                              commandMessageController: this._commandMessageController
                            ),
                            SizedBox(height: 25),
                          ]
                      )
                  ),
                ),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              floatingActionButton: FloatingActionButton.extended(
                  icon: Icon(Icons.add_circle),
                  onPressed: () => _getProfileIdAndCreateCommand(this._commandCaptionController.text, this._commandMessageController.text, context),
                  label: new Text('Create Command')
              ),
            )
        )
    );
  }

  Future<bool> _onWillPop() async {
    Map values = {
      _commandCaptionController.text: "",
      _commandMessageController.text: "",
    };
    if (valuesHaveChanged(values)) {
      return (await showDialog(
          context: context,
          builder: (context) => ConfirmLeaveDialog()
      )) ?? false;
    } else {
      Navigator.of(context).pop(false);
      return null;
    }
  }
}

_getProfileIdAndCreateCommand(String commandCaption, String commandMessage, BuildContext context) {
  PreferencesService.getLastProfileId().then((value) => _createCommand(commandCaption, commandMessage, value, context));
}

_createCommand(String commandCaption, String commandMessage, int profileId, BuildContext context) {
  Command command = new Command(commandMessage, commandCaption, profileId);
  DatabaseService.db.insertCommand(command);
  Navigator.pop(context);
}
