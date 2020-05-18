import 'package:glutter/screens/monitoring/monitoring_screen.dart';
import 'package:glutter/screens/remote_control/remote_control_screen.dart';
import 'package:glutter/screens/settings/about_screen.dart';
import 'package:glutter/screens/settings/profile_create_screen.dart';
import 'package:glutter/screens/settings/profile_detail_screen.dart';
import 'package:glutter/screens/settings/profile_list_screen.dart';
import 'package:glutter/screens/settings/settings_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';

class Routes {
    static const String dashboard = DashboardScreen.routeName;
    static const String monitoring = MonitoringScreen.routeName;
    static const String remoteControl = RemoteControlScreen.routeName;

    static const String settings = SettingsScreen.routeName;
    static const String profileList = ProfileListScreen.routeName;
    static const String profileCreate = ProfileCreateScreen.routeName;
    static const String profileDetail = ProfileDetailScreen.routeName;
    static const String about = AboutScreen.routeName;
}