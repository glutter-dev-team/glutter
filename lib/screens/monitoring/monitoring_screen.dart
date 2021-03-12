import 'package:flutter/material.dart';
import 'package:glutter/widgets/drawer.dart';
import 'package:glutter/screens/monitoring/tabs/memory_tab.dart';
import 'package:glutter/screens/monitoring/tabs/network_tab.dart';
import 'package:glutter/screens/monitoring/tabs/sensors_tab.dart';
import 'package:glutter/screens/monitoring/tabs/cpu_tab.dart';

class MonitoringScreen extends StatefulWidget {
  MonitoringScreen({Key key, this.title: "Monitoring"}) : super(key: key);

  static const String routeName = '/monitoring';
  final String title;

  @override
  _MonitoringState createState() => _MonitoringState();
}

class _MonitoringState extends State<MonitoringScreen> {
  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.memory),
            SizedBox(width: 2.0),
            Text("CPU")
          ],
        ),
      ),
      Tab(
        child:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storage),
            SizedBox(width: 4.0),
            Text("Memory")
          ],
        ),
      ),
      Tab(
        child:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings_ethernet),
            SizedBox(width: 4.0),
            Text("Networks")
          ],
        ),
      ),
      Tab(
        child:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.toys),
            SizedBox(width: 4.0),
            Text("Sensors")
          ],
        ),
      ),
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            isScrollable: true,
            tabs: tabs,
          ),
        ),
        body: TabBarView(
          children: [
            CpuTab(),
            MemoryTab(),
            NetworksTab(),
            SensorsTab(),
          ],
        ),
      ),
    );
  }
}


class PurpleCardHeader extends StatelessWidget {
  PurpleCardHeader({this.title, this.iconData});

  final IconData iconData;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: new BorderRadius.only(topLeft: const Radius.circular(4.0), topRight: const Radius.circular(4.0)),
      ),
      child: ListTile(
        leading: Icon(iconData),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}


showHelpTextDialog(BuildContext context, entityProp) {
  if (entityProp["help_text"] != null) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.help_outline,
              color: Theme.of(context).accentColor
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text(
                entityProp["label"],
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ),
          ],
        ),
        content: Text(entityProp["help_text"]),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "OK",
            ),
          ),
        ],
      ),
    );
  }
}
