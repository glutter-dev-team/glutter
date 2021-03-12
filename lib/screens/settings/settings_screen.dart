import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:glutter/main.dart';
import 'package:glutter/screens/settings/manage_profiles/profile_list_screen.dart';
import 'package:glutter/utils/utils.dart';
import 'package:glutter/widgets/drawer.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key, this.title: "Settings"}) : super(key: key);

  static const String routeName = '/settings';
  final String title;

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: AppDrawer(),
        body: Builder(
            builder: (context) => Padding(
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Row(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                      child: Text(
                        "Profiles",
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                    )
                  ]),
                  Row(children: <Widget>[
                    Expanded(
                        child: SizedBox(
                      child: ListTile(
                        title: Text("Manage profiles"),
                        subtitle: Text("A profile specifies a server that you want to monitor and control."),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfileListScreen()),
                          );
                        },
                      ),
                    ))
                  ]),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: ListView(shrinkWrap: true, padding: EdgeInsets.zero, children: <Widget>[
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.info_outline),
                              title: Text("About"),
                              onTap: () {
                                showAboutDialog(
                                    context: context,
                                    applicationIcon: Container(
                                      height: 75.0,
                                      child: Image(image: AssetImage('assets/images/glutter_app_icon_dark_xxxhdpi.png')),
                                    ),
                                    applicationVersion: GlutterApp.version,
                                    applicationLegalese: 'Copyright © 2020 Hendrik Laudemann, Moritz Jökel. All rights reserved.',
                                    children: [
                                      SizedBox(height: 20),
                                      RichText(
                                          text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                            text: 'glutter is an app for easy-to-use remote control of your linux servers, built with ',
                                            children: <TextSpan>[
                                              TextSpan(text: 'Gl', style: TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: 'ances and Fl'),
                                              TextSpan(text: 'utter.', style: TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: '\n\n Visit us on '),
                                            ]),
                                        TextSpan(
                                          style: TextStyle(color: Theme.of(context).accentColor),
                                          text: 'Github',
                                          recognizer: new TapGestureRecognizer()
                                            ..onTap = () {
                                              launchURL('https://github.com/glutter-dev-team/glutter');
                                            },
                                        ),
                                        TextSpan(text: ' to learn more.'),
                                      ]))
                                    ]
                                );
                              },
                            ),
                          ])
                      )
                  ),
                ])
            )
        )
    );
  }
}
