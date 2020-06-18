import 'package:flutter/material.dart';
import 'package:glutter/widgets/drawer.dart';

class RemoteControlScreen extends StatefulWidget {
    RemoteControlScreen({Key key, this.title: "Remote Control"}) : super(key: key);

    static const String routeName = '/remote-control';
    final String title;

    @override
    _RemoteControlState createState() => _RemoteControlState();
}

class _RemoteControlState extends State<RemoteControlScreen> {

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
                Center(child:
                    Text("Coming soon™")
                )
        );
    }
}
