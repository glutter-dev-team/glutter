import 'package:flutter/material.dart';
import 'package:glutter/widgets/drawer.dart';
import 'package:glutter/models/remote_control/command.dart';
import 'package:glutter/services/remote_control/remote_service.dart';
import 'package:glutter/services/shared/database_service.dart';
import 'package:glutter/models/shared/profile.dart';

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
                ),
            floatingActionButton: FloatingActionButton(
                onPressed: () async {
                    Command cmd = new Command("glances -w");

                    List<Profile> servers = await DatabaseService.db.getProfiles();
                    Profile server = await DatabaseService.db.getProfileById(servers.first.id);

                    RemoteService service = new RemoteService(server);
                    var res = await service.execute(cmd);
                    print(res);
                },
            ),
        );
    }
}
