import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

/// Small helper function to open a given URL in the default web browser.
launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}


/// Convert a long integer (bytes) to a String with suffixes like KB, MB, GB, etc.
String convertBytes(int bytes, int decimals) {
  // copied from https://gist.github.com/zzpmaster/ec51afdbbfa5b2bf6ced13374ff891d9
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
}

/// Convert a long integer (bits) to a String with suffixes like Kb, Mb, Gb, etc.
String convertBits(int bits, int decimals) {
  if (bits <= 0) return "0 b";
  const suffixes = ["b", "Kb", "Mb", "Gb", "Tb", "Pb", "Eb", "Zb", "Yb"];
  var i = (log(bits) / log(1000)).floor();
  return ((bits / pow(1000, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
}

/// Compares the keys and values of a given map. Returns true if there is at least one key that is not equal to its value.
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
