import 'package:flutter/material.dart';

class ProfileCreateScreen extends StatefulWidget {
    ProfileCreateScreen({Key key, this.title: "Create new profile1"}) : super(key: key);

    static const String routeName = '/settings/profiles/create';
    final String title;

    @override
    _ProfileCreateState createState() => _ProfileCreateState();
}

class _ProfileCreateState extends State<ProfileCreateScreen> {

    TextEditingController _profileCaptionController = new TextEditingController();
    TextEditingController _serverAddressController = new TextEditingController();
    TextEditingController _serverPortController = new TextEditingController();
    TextEditingController _serverApiVersionController = new TextEditingController();

    @override
    void initState() {
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        // This method is rerun every time setState is called
        return GestureDetector(
            // dismiss focus (keyboard) if users taps anywhere in a "dead space" within the app
            // copied from https://flutterigniter.com/dismiss-keyboard-form-lose-focus/
            onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
            }
        },
        child: Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
            ),
            body: Builder(
                builder: (context) => Padding(
                    padding: EdgeInsets.fromLTRB(10.0,10.0,10.0,0),
                    child: Column(
                        children: <Widget> [
                            /*Row(
                                children: <Widget>[
                                    Container(
                                        child: TextField(
                                            controller: _profileCaptionController,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Caption / Name / Title',
                                                labelStyle: new TextStyle(fontSize: 14.0,),
                                                hintText: '2 or 3',
                                                hintStyle: new TextStyle(fontSize: 14.0,),
                                            )
                                        ),
                                    ),

                                ]
                            ),*/
                            //Text("test123"),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                    Expanded( // wrap your Column in Expanded
                                        child: Column(
                                            children: <Widget>[
                                                Container(
                                                    child: TextField(
                                                        controller: _profileCaptionController,
                                                        decoration: InputDecoration(
                                                            border: OutlineInputBorder(),
                                                            labelText: 'Caption / Name / Title',
                                                            //labelStyle: new TextStyle(fontSize: 14.0,),
                                                            hintText: 'e.g. My NAS @ Home',
                                                            //hintStyle: new TextStyle(fontSize: 14.0,),
                                                        )
                                                    )),
                                            ],
                                        ),
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.help_outline),
                                        tooltip: 'Increase volume by 10',
                                        onPressed: () {
                                        },
                                    ),
                                ],
                            ),
                        ]
                    )
                ),
            )
        ));
    }
}
