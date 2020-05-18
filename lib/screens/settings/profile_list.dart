import 'package:flutter/material.dart';
import 'package:glutter/screens/settings/profile_create.dart';
import 'package:glutter/widgets/drawer.dart';
import '../../utils/routes.dart';

class ProfileListScreen extends StatefulWidget {
    ProfileListScreen({Key key, this.title: "Glutter Profiles"}) : super(key: key);

    static const String routeName = '/settings/profiles';
    final String title;

    @override
    _ProfileListState createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileListScreen> {

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
            body: Builder(
                builder: (context) => Padding(
                    padding: EdgeInsets.fromLTRB(10.0,10.0,10.0,0),
                    child: Column(
                        children: <Widget> [
                            Row(
                                children: <Widget>[
                                /*
                                ListView.builder(
                                    scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: memoryList.length,
                                        itemBuilder: (BuildContext context, int index){
                                            return ListTile(
                                                title: Text(memoryList[index]["short_desc"].toString()),
                                                subtitle: Text(memoryList[index]["value"].toString()), //snapshot.data.total.toString()
                                            );
                                        }
                                    ),
                                    Text("profile list page"),
                                    */
                                ]
                            ),
                        ]
                    )
                ),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () => {
                    /*Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileCreateScreen()),
                    )*/
                    Navigator.pushNamed(
                        context,
                        '/settings/profiles/create',
                        /*arguments: <String, String>{

                        },*/
                    )
                },
                tooltip: 'Create new profile',
                child: Icon(Icons.add),
            ),
        );
    }
}
