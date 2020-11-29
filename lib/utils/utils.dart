import 'dart:math';

import 'package:url_launcher/url_launcher.dart';

launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

// copied from https://gist.github.com/zzpmaster/ec51afdbbfa5b2bf6ced13374ff891d9
String convertBytes(int bytes, int decimals) {
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
}

bool valuesHaveChanged(Map values) {
  bool changed = false;
  values.forEach((key, value) {
    if (key != value) {
      changed = true;
    }
  });
  return changed;
}

/// Removes the enum name from the enum's value and returns its value only. See example below.
/// input: MonitoringOption.Sensors
/// output: Sensors
String getEnumOptionAsString(option) {
  return option.toString().substring(option.toString().indexOf('.') + 1);
}
