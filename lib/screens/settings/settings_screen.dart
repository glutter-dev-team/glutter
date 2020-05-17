import 'package:flutter/material.dart';
import 'package:glutter/widgets/drawer.dart';

class SettingsScreen extends StatefulWidget {
    SettingsScreen({Key key, this.title: "Glutter Settings"}) : super(key: key);

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
        // This method is rerun every time setState is called
        return Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
            ),
            drawer: AppDrawer(),
            body:
            Text("Settings page")
        );
    }
}
