import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:glutter/screens/settings/about_screen.dart';
import 'package:glutter/screens/settings/profile_list_screen.dart';
import 'package:glutter/widgets/drawer.dart';

class SettingsScreen extends StatefulWidget {
    SettingsScreen({Key key, this.title: "Glutter Settings"}) : super(key: key);

    static const String routeName = '/settings';
    final String title;

    @override
    _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {

    bool _themeBrightnessLight = true;

    @override
    void initState() {
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        // This method is rerun every time setState is called
        return Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
            ),
            drawer: AppDrawer(),
            body: Builder(
                builder: (context) => Padding(
                    padding: EdgeInsets.fromLTRB(10.0,10.0,10.0,10.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget> [
                            Row(
                                children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,10.0),
                                        child: Text(
                                            "Profiles",
                                            style: TextStyle(color: Theme.of(context).accentColor),
                                        ),
                                    )
                                ]
                            ),
                            Row(
                                children: <Widget>[
                                    Expanded(
                                        child: SizedBox(
                                            //height: 75,
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
                                        )
                                    )
                                ]
                            ),
                            SizedBox(
                                height: 20,
                            ),
                            Row(
                                children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,10.0),
                                        child:
                                        Text(
                                            "Theme",
                                            style: TextStyle(color: Theme.of(context).accentColor),
                                        ),
                                    )
                                ]
                            ),
                            Row(
                                children: <Widget>[
                                    Expanded(
                                        child: SizedBox(
                                            //height: 60,
                                            child:  SwitchListTile(
                                                value: _themeBrightnessLight,
                                                title: Text("Dark mode"),
                                                onChanged: (value) {
                                                    setState(() {
                                                        if (value == true) {
                                                            // TODO: Theme Brightness tatsächlich ändern und speichern
                                                            _themeBrightnessLight = true;
                                                        } else if (value == false) {
                                                            // TODO: Theme Brightness tatsächlich ändern und speichern
                                                            _themeBrightnessLight = false;
                                                        }
                                                    });
                                                },
                                            ),
                                        )
                                    ),
                                ]
                            ),
                            Expanded(
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: ListView(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        children: <Widget>[
                                            Divider(),
                                            ListTile(
                                                leading: Icon(Icons.info_outline),
                                                title: Text("About"),
                                                //subtitle: Text("A profile specifies a server that you want to monitor and control."),
                                                onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => AboutScreen()),
                                                    );
                                                },
                                            ),
                                        ]
                                    )
                                )
                            ),
                        ]
                    )
                )
            )
        );
    }
}
