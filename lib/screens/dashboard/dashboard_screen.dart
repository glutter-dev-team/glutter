import 'package:flutter/material.dart';
import 'package:glutter/widgets/drawer.dart';

class DashboardScreen extends StatefulWidget {
    DashboardScreen({Key key, this.title: "Glutter Dashboard"}) : super(key: key);

    static const String routeName = '/dashboard';
    final String title;

    @override
    _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardScreen> {

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
                Text("dashboard page")
        );
    }
}
