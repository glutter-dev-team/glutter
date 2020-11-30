import 'package:flutter/material.dart';
import 'package:glutter/models/shared/profile.dart';

Widget showNoDataReceived(String dataName, Profile currentProfile) {
  String title;
  if (dataName != "") {
    title = "No data received from server " + currentProfile.caption + " for " + dataName;
  } else {
    title = "No data received from server " + currentProfile.caption;
  }
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
              "Make sure you are connected to a network where you can reach your server address http://" +
                currentProfile.serverAddress + ":" + currentProfile.port.toString(),
            )
          )
        ],
      ),
    )
  );
}

Widget internalErrorText() {
  return Text("An internal error occurred. Please try again.");
}

