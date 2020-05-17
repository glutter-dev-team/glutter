import 'package:flutter/material.dart';
import 'package:glutter/screens/dashboard/dashboard_screen.dart';
import 'package:glutter/screens/remote_control/remote_control_screen.dart';
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
            theme: ThemeData(
                primarySwatch: Colors.deepPurple,
                brightness: Brightness.dark, // das könnte später über den User-Preferences-Screen individuell anpassbar sein und in sqlite gespeichert werden
                visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: DashboardScreen(),
            routes:  {
                Routes.dashboard: (context) => DashboardScreen(),
                Routes.monitoring: (context) => MonitoringScreen(),
                Routes.remoteControl: (context) => RemoteControlScreen(),
                Routes.settings: (context) => SettingsScreen(),
            },
        );
    }
}

