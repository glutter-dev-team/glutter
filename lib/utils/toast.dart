import 'package:flutter/material.dart';

void showToast(BuildContext context, String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
        SnackBar(
            content: Text(message),
            action: SnackBarAction(
                label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
        ),
    );
}