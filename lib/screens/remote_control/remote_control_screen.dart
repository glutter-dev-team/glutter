import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:glutter/models/remote_control/command.dart';
import 'package:glutter/models/shared/profile.dart';
import 'package:glutter/screens/remote_control/command_create_screen.dart';
import 'package:glutter/screens/remote_control/widgets/command_result.dart';
import 'package:glutter/services/remote_control/remote_service.dart';
import 'package:glutter/services/shared/database_service.dart';
import 'package:glutter/services/shared/preferences_service.dart';
import 'package:glutter/widgets/drawer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RemoteControlScreen extends StatefulWidget {
  RemoteControlScreen({Key key, this.title: "Remote Control"}) : super(key: key);

  static const String routeName = '/remote-control';
  final String title;

  @override
  _RemoteControlState createState() => _RemoteControlState();
}

class _RemoteControlState extends State<RemoteControlScreen> {
  Future commandsFuture;
  int _lastProfileId;

  @override
  void initState() {
    PreferencesService.getLastProfileId().then((value) {
      this.commandsFuture = DatabaseService.db.getCommandsByProfileId(value);
      this._onRefresh();
      this._lastProfileId = value;
    });

    super.initState();
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async{
    await Future.delayed(Duration(milliseconds: 500));

    this.setState(() {
      PreferencesService.getLastProfileId().then((value) {
        this.commandsFuture = DatabaseService.db.getCommandsByProfileId(value);
        this._lastProfileId = value;
      });
    });

    _refreshController.refreshCompleted();
  }

  _onPress(BuildContext context, Command cmd) async {
    Profile server = await DatabaseService.db.getProfileById(this._lastProfileId);
    var service = new RemoteService(server);
    String answer = await service.execute(cmd);
    return await showDialog(
        context: context,
        builder: (context) => CommandResultDialog(cmd, answer)
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: AppDrawer(),
      body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: ClassicHeader(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  FutureBuilder(
                    future: commandsFuture,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.active:
                        case ConnectionState.waiting:
                          return Container(
                              child: new CircularProgressIndicator(),
                              alignment: Alignment(0.0, 0.0)
                          );
                        case ConnectionState.done:
                          if (snapshot.data != null) {
                            return new Column (
                                mainAxisSize: MainAxisSize.max,
                                children: List.generate(snapshot.data.length, (i) {
                                  return Slidable(
                                      actionPane: SlidableDrawerActionPane(),
                                      actionExtentRatio: 0.25,
                                      actions: <Widget>[
                                        IconSlideAction(
                                          caption: 'Delete',
                                          color: Colors.red,
                                          icon: Icons.delete_forever,
                                          onTap: () => _onDelete(snapshot.data[i]),
                                        ),
                                      ],
                                      secondaryActions: [
                                        IconSlideAction(
                                          caption: 'Execute',
                                          color: Colors.blue,
                                          icon: Icons.auto_fix_high,
                                          onTap: () => _onPress(context, snapshot.data[i]),
                                        ),
                                      ],
                                      child: Card(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            ListTile(
                                                leading: Icon(Icons.comment),
                                                title: Text(snapshot.data[i].caption)
                                            ),
                                            Text(
                                              snapshot.data[i].commandMessage,
                                              style: TextStyle(
                                                fontFamily: "RobotoMono",
                                              ),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(0, 20, 0, 0)
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                            )
                                          ],
                                        ),
                                      )
                                  );
                                })
                            );
                          }
                          return Container();
                        default:
                          return Text("No commands available for this server");
                      }
                    },
                  )
                ]
            ),
          )
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CommandCreateScreen()),
            ).then((value) {
              _onRefresh();
            })
          }
      ),
    );
  }

  void _onDelete(Command cmd) {
    DatabaseService.db.deleteCommandById(cmd.id);
    _onRefresh();
  }
}
