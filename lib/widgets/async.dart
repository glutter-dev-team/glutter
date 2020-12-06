import 'package:flutter/material.dart';

Widget progressIndicatorContainer() {
    return Container(
        alignment: Alignment(0.0, 0.0),
        child: Padding(
            padding: EdgeInsets.all(25.0),
            child: new CircularProgressIndicator(),
        )
    );
}
