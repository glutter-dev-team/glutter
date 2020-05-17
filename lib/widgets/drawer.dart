import 'package:flutter/material.dart';
import '../utils/routes.dart';
import '../utils/launch_url.dart';

class AppDrawer extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Drawer(
            child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                    _createHeader(),
                    _createDrawerItem(
                        icon: Icons.dashboard,
                        text: 'Dashboard',
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, Routes.dashboard)),
                    _createDrawerItem(
                        icon: Icons.computer,
                        text: 'Monitoring',
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, Routes.monitoring)),
                    _createDrawerItem(
                        icon: Icons.settings_remote,
                        text: 'Remote Control',
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, Routes.remoteControl)),
                    /*
                    Divider(),

                    _createDrawerItem(icon: Icons.collections_bookmark, text: 'Steps'),
                    _createDrawerItem(icon: Icons.face, text: 'Authors'),
                    _createDrawerItem(
                        icon: Icons.account_box, text: 'Flutter Documentation'),
                    _createDrawerItem(icon: Icons.stars, text: 'Useful Links'),
                    */
                    Divider(),
                    _createDrawerItem(
                        icon: Icons.settings,
                        text: 'Settings',
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, Routes.settings)),
                    _createDrawerItem(
                        icon: Icons.bug_report,
                        text: 'Report an issue',
                        onTap: () =>
                            launchURL("https://github.com/HeLau1337/glutter/issues/new/choose")
                    ),
                    ListTile(
                        title: Text('v0.0.1'),
                        onTap: () {},
                    ),
                ],
            ),
        );
    }

    Widget _createHeader() {
        return DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/temporary_app_icon.png'))),
            child: Stack(children: <Widget>[
                Positioned(
                    bottom: 12.0,
                    left: 16.0,
                    child: Text("Glutter",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500))),
            ]));
    }

    Widget _createDrawerItem(
        {IconData icon, String text, GestureTapCallback onTap}) {
        return ListTile(
            title: Row(
                children: <Widget>[
                    Icon(icon),
                    Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(text),
                    )
                ],
            ),
            onTap: onTap,
        );
    }
}