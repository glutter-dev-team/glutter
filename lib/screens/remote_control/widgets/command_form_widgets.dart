import 'package:flutter/material.dart';

class CommandForm extends StatelessWidget {
  CommandForm({this.commandCaptionController, this.commandMessageController});

  final TextEditingController commandCaptionController;
  final TextEditingController commandMessageController;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(child: CommandCaptionTextField(commandCaptionController)),
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
          Expanded(child: CommandMessageTextField(commandMessageController)),
        ],
      ),
    ]);
  }
}

class CommandCaptionTextField extends StatelessWidget {
  CommandCaptionTextField(this.commandCaptionController); // this.context,

  //final BuildContext context;
  final TextEditingController commandCaptionController;

  @override
  Widget build(BuildContext context) {
    return TextField(
        autocorrect: false,
        controller: commandCaptionController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Caption',
          hintText: 'e.g. Start glances webserver',
        ));
  }
}

class CommandMessageTextField extends StatelessWidget {
  CommandMessageTextField(this.commandMessageController);

  final TextEditingController commandMessageController;

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: commandMessageController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Command message',
          hintText: 'e.g. sudo glances -w',
        ));
  }
}
