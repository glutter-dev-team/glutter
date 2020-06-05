import 'package:flutter/material.dart';
import 'package:glutter/screens/dashboard/dashboard_screen.dart';
import 'package:glutter/screens/remote_control/remote_control_screen.dart';
import 'package:glutter/screens/settings/about_screen.dart';
import 'package:glutter/screens/settings/profile_create_screen.dart';
import 'package:glutter/screens/settings/profile_edit_screen.dart';
import 'package:glutter/screens/settings/profile_list_screen.dart';
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
            title: 'Glutter',
            theme: new ThemeData(
                // TODO: ThemeData aus eigener Datei laden, wo auch einige Theme-Eigenschaften anpassbar sein sollen
                primarySwatch: Colors.deepPurple, // deepPurple = #512da8
                accentColor: Colors.deepPurpleAccent, // deepPurpleAccent = #7c4dff
                toggleableActiveColor: Colors.deepPurpleAccent,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                brightness: Brightness.dark, // das könnte später über den User-Preferences-Screen individuell anpassbar sein und in sqlite gespeichert werden
            ),
            home: DashboardScreen(),
            routes:  {
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

