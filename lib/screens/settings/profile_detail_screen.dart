import 'package:flutter/material.dart';
import 'package:glutter/widgets/drawer.dart';

class ProfileDetailScreen extends StatelessWidget {

    static const String routeName = '/settings/profiles/edit';

    @override
    Widget build(BuildContext context) {
        // This method is rerun every time setState is called
        return Scaffold(
            appBar: AppBar(
                title: Text("Show details of profile x"),
            ),
            body: Builder(
                builder: (context) => Padding(
                    padding: EdgeInsets.fromLTRB(10.0,10.0,10.0,0),
                    child: Column(children: <Widget> [
                        Row(children: <Widget>[
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
                                ),*/
                                Text("profile detail page"),

                        ]),
                    ])
                ),
            ));
    }
}
