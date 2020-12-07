import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glutter/models/remote_control/command.dart';

class ConfirmLeaveDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Text('Are you sure?'),
      content: new Text('Do you want to leave without saving? You are going to lose your changes!'),
      actions: <Widget>[
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: new Text("Cancel"),
        ),
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: new Text('Discard'),
        ),
      ],
    );
  }
}


class CommandResultDialog extends StatelessWidget {
  CommandResultDialog(this.cmd, this.answer);

  final Command cmd;
  final String answer;

  @override
  Widget build(BuildContext context) {
    TextEditingController tecCmd = new TextEditingController();
    TextEditingController tecAnswer = new TextEditingController();
    tecCmd.text = cmd.commandMessage;
    tecAnswer.text = answer;
    return new AlertDialog(
      title: new Text("\"" + cmd.caption + "\" - Result:"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "Command: ",
              style: TextStyle(
                  fontWeight: FontWeight.bold
              )
          ),
          TextField(
            controller: tecCmd,
            readOnly: true,
            style: TextStyle(
                fontFamily: "RobotoMono"
            ),
            autofocus: false,
            decoration: InputDecoration.collapsed(
              border: InputBorder.none,
            ),
          ),
          SizedBox(height: 15.0,),
          Divider(),
          SizedBox(height: 15.0,),
          Text(
              "Result:",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold
              )
          ),
          SizedBox(height: 5.0,),
          TextField(
            controller: tecAnswer,
            readOnly: true,
            maxLines: null,
            style: TextStyle(
              fontSize: 12.0,
              fontFamily: "RobotoMono",
            ),
            decoration: InputDecoration.collapsed(
              border: InputBorder.none,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: new Text('OK'),
        ),
      ],
    );
  }
}
