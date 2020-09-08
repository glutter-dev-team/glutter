import 'package:flutter/material.dart';
import 'package:glutter/screens/settings/manage_profiles/profile_create_screen.dart';
import 'package:glutter/screens/settings/manage_profiles/profile_edit_screen.dart';
import 'package:glutter/services/shared/database_service.dart';
import 'package:glutter/utils/toast.dart';

class ProfileListScreen extends StatefulWidget {
    ProfileListScreen({Key key, this.title: "Profiles"}) : super(key: key);

    static const String routeName = '/settings/profiles';
    final String title;

    @override
    _ProfileListState createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileListScreen> {

    Future profilesFuture;

    @override
    void initState() {
        profilesFuture = DatabaseService.db.getProfiles();
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        // This method is rerun every time setState is called
        return Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
                actions: <Widget>[
                    // overflow menu
                    /*PopupMenuButton(
                        onSelected: _select,
                        itemBuilder: (BuildContext context) {
                            return choices.skip(2).map((Choice choice) {
                                return PopupMenuItem(
                                    //value: choice,
                                    child: Text(choice.title),
                                );
                            }).toList();
                        },
                    ),*/
                ],
            ),
            body: Builder(
                builder: (context) => Padding(
                    padding: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget> [
                            Expanded(
                                child: ListView(
                                    padding: EdgeInsets.fromLTRB(0.0,0.0,0.0,75.0),
                                    children: <Widget>[
                                        FutureBuilder(
                                            future: profilesFuture,
                                            builder: (BuildContext context, AsyncSnapshot snapshot){
                                                switch (snapshot.connectionState) {
                                                    //case ConnectionState.none:
                                                    //    return Text("none");
                                                    case ConnectionState.active:
                                                        return Text("active");
                                                    case ConnectionState.waiting:
                                                        return Center( //Text("Active and maybe waiting");
                                                            child: Container(
                                                                child: new CircularProgressIndicator(),
                                                                alignment: Alignment(0.0, 0.0),
                                                            ),
                                                        );
                                                    case ConnectionState.done:
                                                        return ListView.builder(
                                                            scrollDirection: Axis.vertical,
                                                            physics: NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount: snapshot.data.length,
                                                            itemBuilder: (BuildContext context, int index){
                                                                return ListTile(
                                                                    title: Text(snapshot.data[index].caption),
                                                                    subtitle: Text(snapshot.data[index].serverAddress), //snapshot.data.total.toString()
                                                                    trailing: Icon(Icons.edit),
                                                                    onTap: () => {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => ProfileEditScreen(),
                                                                                settings: RouteSettings(
                                                                                    arguments: snapshot.data[index],
                                                                                ),
                                                                            ),
                                                                        ).then((value) {
                                                                            setState(() {
                                                                                profilesFuture = DatabaseService.db.getProfiles();
                                                                            });
                                                                        }),
                                                                    }
                                                                );
                                                            }
                                                        );
                                                    default:
                                                        return Text("default");
                                                }
                                            }
                                        ),
                                    ],
                                )
                            ),
                        ]
                    )
                ),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileCreateScreen()),
                    ).then((value) {
                        setState(() {
                            profilesFuture = DatabaseService.db.getProfiles();
                        });
                    })
                },
                tooltip: 'Create new profile',
                child: Icon(Icons.add),
            ),
        );
    }
}