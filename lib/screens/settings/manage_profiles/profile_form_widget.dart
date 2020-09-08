import 'package:flutter/material.dart';

// Dieses Widget soll das komplette Profile-Formular abbilden (für create und update screens). Wird aktuell noch nicht (wieder) benutzt, weil es merge conflicts gab.
class ProfileForm extends StatelessWidget {
    ProfileForm({
        this.profileCaptionController,
        this.serverAddressController,
        this.glancesPortController,
        this.glancesApiVersionController,
    });

    final TextEditingController profileCaptionController;
    final TextEditingController serverAddressController;
    final TextEditingController glancesPortController;
    final TextEditingController glancesApiVersionController;

    @override
    Widget build(BuildContext context) {
        return Column(
            children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                        Expanded(
                            child: Column(
                                children: <Widget>[
                                    Container(
                                        child: TextField(
                                            controller: profileCaptionController,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Profile name',
                                                hintText: 'e.g. My NAS @ Home',
                                            )
                                        )
                                    ),
                                ],
                            ),
                        ),
                        /*
                    IconButton(
                        icon: Icon(Icons.help_outline),
                        tooltip: 'Show help text',
                        onPressed: () {
                            // Popup (Modal/Dialog) Fenster mit Text anzeigen
                        },
                    ),
                    */
                    ],
                ),
                SizedBox(
                    height: 15,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                        Expanded(
                            child: TextField(
                                controller: serverAddressController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Server address',
                                    hintText: 'e.g. example.com or 123.45.678.9',
                                )
                            ),
                        ),
                        /*
                    IconButton(
                        icon: Icon(Icons.help_outline),
                        tooltip: 'Show help text',
                        onPressed: () {
                            // Popup (Modal/Dialog) Fenster mit Text anzeigen
                        },
                    ),
                    */
                    ],
                ),
                SizedBox(
                    height: 15,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                        Expanded(
                            child: Column(
                                children: <Widget>[
                                    Container(
                                        child: TextField(
                                            controller: glancesPortController,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Glances port',
                                                hintText: 'default: 61208',
                                            )
                                        )),
                                ],
                            ),
                        ),
                        /*
                    IconButton(
                        icon: Icon(Icons.help_outline),
                        tooltip: 'Show help text',
                        onPressed: () {
                            // Popup (Modal/Dialog) Fenster mit Text anzeigen
                        },
                    ),
                    */
                    ],
                ),
                SizedBox(
                    height: 15,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                        Expanded(
                            child: TextField(
                                controller: glancesApiVersionController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Glances API version',
                                    hintText: '2 or 3',
                                )
                            ),
                        ),
                        /*
                    IconButton(
                        icon: Icon(Icons.help_outline),
                        tooltip: 'Show help text',
                        onPressed: () {
                            // Popup (Modal/Dialog) Fenster mit Text anzeigen
                        },
                    ),
                    */
                    ],
                ),
            ]
        );
    }
}