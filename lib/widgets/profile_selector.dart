import 'package:flutter/material.dart';
import 'package:glutter/models/shared/profile.dart';
import 'package:glutter/services/shared/database_service.dart';
import 'package:glutter/services/shared/preferences_service.dart';

class ProfileSelector extends StatefulWidget {
  @override
  _ProfileSelectorState createState() => _ProfileSelectorState();
}

class _ProfileSelectorState extends State<ProfileSelector> {
  Future profilesFuture;
  Profile selectedProfile;
  int lastProfileId;

  @override
  void initState() {
    super.initState();

    profilesFuture = DatabaseService.db.getProfiles();

    PreferencesService.getLastProfile().then((profile) => this.setState(() {
          this.selectedProfile = profile;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: profilesFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(child: Container(child: new CircularProgressIndicator(), alignment: Alignment(0.0, 0.0)));
              case ConnectionState.done:
                return new Container(
                    width: 200,
                    height: 60,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Profile>(
                      isExpanded: true,
                      items: snapshot.data
                          .map((Profile item) {
                            return DropdownMenuItem<Profile>(value: item, child: Text(item.caption + " (" + item.serverAddress + ")"));
                          })
                          .cast<DropdownMenuItem<Profile>>()
                          .toList(),
                      onChanged: (Profile newSelectedProfile) {
                        setState(() {
                          selectedProfile = newSelectedProfile;
                          PreferencesService.setLastProfileId(newSelectedProfile.id);
                        });
                      },
                      value: selectedProfile,
                    )
                )
            );
              default:
                return SizedBox();
            }
          }),
    );
  }
}
