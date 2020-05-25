import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {

    static const String routeName = '/settings/about';

    @override
    Widget build(BuildContext context) {
        // This method is rerun every time setState is called
        return Scaffold(
            appBar: AppBar(
                title: Text("About Glutter"),
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
                                        ),*/
                                    Text("about page"),
                                ]
                            ),
                        ]
                    )
                ),
            ));
    }
}
