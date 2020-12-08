import 'package:flutter/material.dart';

/// Small reusable widget that adds Padding to a CircularProgressIndicator.
Widget progressIndicatorContainer() {
    return Container(
        alignment: Alignment(0.0, 0.0),
        child: Padding(
            padding: EdgeInsets.all(25.0),
            child: new CircularProgressIndicator(),
        )
    );
}
