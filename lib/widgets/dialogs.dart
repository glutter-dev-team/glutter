import 'package:flutter/material.dart';
import 'package:glutter/models/shared/profile.dart';
import 'package:glutter/services/shared/database_service.dart';

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

class ConfirmDeleteProfileDialog extends StatelessWidget {

    ConfirmDeleteProfileDialog(this.context, this.profile);

    final BuildContext context;
    final Profile profile;

    @override
    Widget build(context) {
        return AlertDialog(
            title: Text("Delete profile?"),
            content: Text("Do you really want to delete this profile called '" +
                profile.caption + "'?"),
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
}

