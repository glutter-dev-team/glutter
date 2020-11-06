import 'package:flutter/material.dart';
import 'package:glutter/screens/dashboard/dashboard_screen.dart';
import 'package:glutter/screens/remote_control/remote_control_screen.dart';
import 'package:glutter/screens/settings/about_screen.dart';
import 'package:glutter/screens/settings/manage_profiles/profile_create_screen.dart';
import 'package:glutter/screens/settings/manage_profiles/profile_edit_screen.dart';
import 'package:glutter/screens/settings/manage_profiles/profile_list_screen.dart';
import 'package:glutter/screens/settings/settings_screen.dart';

import 'screens/monitoring/monitoring_screen.dart';
import 'utils/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'glutter',
      theme: new ThemeData(
        primarySwatch: Colors.deepPurple, // deepPurple = #512da8
        accentColor: Colors.deepPurpleAccent, // deepPurpleAccent = #7c4dff
        toggleableActiveColor: Colors.deepPurpleAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
      ),
      home: DashboardScreen(),
      routes: {
        Routes.dashboard: (context) => DashboardScreen(),
        Routes.monitoring: (context) => MonitoringScreen(),
        Routes.remoteControl: (context) => RemoteControlScreen(),
        Routes.settings: (context) => SettingsScreen(),
        Routes.profileList: (context) => ProfileListScreen(),
        Routes.profileCreate: (context) => ProfileCreateScreen(),
        Routes.profileDetail: (context) => ProfileEditScreen(),
        Routes.about: (context) => AboutScreen(),
      },
    );
  }
}
