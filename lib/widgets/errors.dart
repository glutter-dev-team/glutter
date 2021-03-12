import 'package:flutter/material.dart';
import 'package:glutter/models/shared/profile.dart';
import 'package:glutter/screens/settings/manage_profiles/profile_create_screen.dart';
import 'package:glutter/services/shared/database_service.dart';
import 'package:glutter/services/shared/preferences_service.dart';

Widget showNoDataReceived(Profile currentProfile, [String dataName=""]) {
  String title;
  if (dataName != "") {
    title = "No data received from server " + currentProfile.caption + " for " + dataName;
  } else {
    title = "No data received from server " + currentProfile.caption;
  }
  return Container(
    child: Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.dangerous,
                color: Colors.redAccent,
              ),
              SizedBox(width: 10.0,),
              Text(
                title,
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0,),
          Text(
            "Make sure you are connected to a network where you can reach your server address http://" +
              currentProfile.serverAddress + ":" + currentProfile.port.toString(),
          )
        ],
      ),
    )
  );
}

/// Show a text for unexpected error cases.
Widget internalErrorText() {
  return Text("An internal error occurred. Please try again.");
}

/// Ask the user to select (or create and select) a glutter profile in order to receive the requested information.
Widget showNoProfileSelected(BuildContext context) {
  String title = "No Profile selected";
  return Container(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              Icons.dangerous,
              color: Colors.redAccent,
            ),
            SizedBox(height: 10.0,),
            Text(
              title,
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 10.0,),
            Padding(
                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                child: Text(
                  "Make sure you created a server-profile and selected one in the sidebar", textAlign: TextAlign.center)
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 0.0),
              child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileCreateScreen())
              ).then((value) {
                DatabaseService.db.getProfiles().then((value) {
                  PreferencesService.setLastProfileId(value[0].id);
                });
              }),
              child: Text("Create your first profile!")
              )
            )
          ],
        ),
      )
  );
}

