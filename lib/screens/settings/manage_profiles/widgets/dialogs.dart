import 'package:flutter/material.dart';
import 'package:glutter/models/shared/profile.dart';
import 'package:glutter/services/shared/database_service.dart';

/// Alert dialog that asks for confirmation before deleting a glutter profile.
class ConfirmDeleteProfileDialog extends StatelessWidget {
  ConfirmDeleteProfileDialog(this.context, this.profile);

  final BuildContext context;
  final Profile profile;

  @override
  Widget build(context) {
    return AlertDialog(
      title: Text("Delete profile?"),
      content: Text("Do you really want to delete this profile called '" + profile.caption + "'?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
          ),
        ),
        TextButton(
          onPressed: () {
            DatabaseService.db.deleteProfileById(profile.id);

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
