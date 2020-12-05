import 'package:flutter/material.dart';
import 'package:glutter/models/shared/profile.dart';
import 'package:glutter/services/monitoring/glances_service.dart';
import 'package:glutter/services/shared/preferences_service.dart';
import 'package:glutter/widgets/drawer.dart';
import 'package:glutter/widgets/errors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:glutter/utils/utils.dart';
import 'package:glutter/screens/monitoring/data_list_builder.dart';

class MonitoringScreen extends StatefulWidget {
  MonitoringScreen({Key key, this.title: "Monitoring"}) : super(key: key);

  static const String routeName = '/monitoring';
  final String title;

  @override
  _MonitoringState createState() => _MonitoringState();
}

class _MonitoringState extends State<MonitoringScreen> {
  GlancesService glancesService;

  Profile selectedProfile;

  MonitoringOption selectedOption;
  List<MonitoringOption> monitoringOptions;

  Future monitoringFuture;
  Future cpuFuture;
  Future memoryFuture;
  Future networksFuture;
  Future sensorsFuture;


  @override
  void initState() {
    super.initState();

    this.monitoringOptions = new List();
    for (var value in MonitoringOption.values) {
      this.monitoringOptions.add(value);
    }

    this.selectedOption = this.monitoringOptions[0];

    /*PreferencesService.getLastProfile().then((profile) => () {
      this.selectedProfile = profile;
    });*/
    _onRefresh();
  }

  void _onRefresh() {
    PreferencesService.getLastProfile()
      .then((profile) => () {
        this.selectedProfile = profile;
        this.glancesService = new GlancesService(this.selectedProfile);
        cpuFuture = this.glancesService.getCpu();
        memoryFuture = this.glancesService.getMemory();
        networksFuture = this.glancesService.getNetworks();
        sensorsFuture = this.glancesService.getSensors();
      });
    print("test");
  }

  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = [
      Tab(
        //icon: Icon(Icons.memory),
        text: "CPU",
      ),
      Tab(
        //icon: Icon(Icons.storage),
        text: "Memory",
      ),
      /*Tab(icon: Icon(Icons.directions_bike)),
      Tab(icon: Icon(Icons.directions_bike)),*/
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            tabs: tabs,
          ),
        ),
        body: TabBarView(
          children: [
            CpuTab(),
            _memoryTab(),
            /*_networkTab(networksFuture),
          _sensorsTab(sensorsFuture)*/
          ],
        ),
      ),
    );
  }

  RefreshController _cpuRefreshController = RefreshController(initialRefresh: false);

  void _onCpuRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 500));

    this.setState(() {
      PreferencesService.getLastProfile().then((profile) => () {
        this.selectedProfile = profile;
        this.glancesService = new GlancesService(this.selectedProfile);
        cpuFuture = this.glancesService.getCpu();
      });
    });

    // if failed,use refreshFailed()
    _cpuRefreshController.refreshCompleted();
  }
  Widget _cpuTab() {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      header: ClassicHeader(),
      controller: _cpuRefreshController,
      onRefresh: _onCpuRefresh,
      child: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: cpuFuture,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return Card(
                          child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                _progressIndicatorContainer(),
                              ]
                          )
                      );
                    case ConnectionState.done:
                      if (snapshot.data != null) {
                        return Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                ListTile(
                                    leading: Icon(Icons.memory),
                                    title: Text("CPU usage: " + snapshot.data.total.toString())
                                ),
                              ],
                            )
                        );
                      } else {
                        return Text("data is null");
                      }
                      return SizedBox();

                    default:
                      return internalErrorText();
                  }
                }
            ),
            Card(
              child: Column(
                children: [
                  Text("cpu tab")
                ]
              )
            )
          ],
        ),
      )
    );
  }

  RefreshController _memRefreshController = RefreshController(initialRefresh: false);
  void _onMemRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 500));

    this.setState(() {
      PreferencesService.getLastProfile().then((profile) => () {
        this.selectedProfile = profile;
        this.glancesService = new GlancesService(this.selectedProfile);
        memoryFuture = this.glancesService.getMemory();
      });
    });

    // if failed,use refreshFailed()
    _memRefreshController.refreshCompleted();
  }
  Widget _memoryTab() {
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: ClassicHeader(),
        controller: _memRefreshController,
        onRefresh: _onMemRefresh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                  child: Column(
                      children: [
                        Text("memory tab")
                      ]
                  )
              )
            ],
          ),
        )
    );
  }
}

class CpuTab extends StatefulWidget {
  @override
  _CpuTabState createState() => _CpuTabState();
}

class _CpuTabState extends State<CpuTab> {
  GlancesService glancesService;
  Profile selectedProfile;
  Future cpuFuture;

  @override
  void initState() {

    PreferencesService.getLastProfile()
        .then((profile) => () {
          this.selectedProfile = profile;
          this.glancesService = new GlancesService(this.selectedProfile);
          this.cpuFuture = this.glancesService.getCpu();
        });

    super.initState();
  }

  RefreshController _refreshController = RefreshController(initialRefresh: true);

  void _onRefresh() {
    this.cpuFuture = this.glancesService.getCpu();
    /*PreferencesService.getLastProfile()
        .then((profile) => () {
      this.selectedProfile = profile;
      this.glancesService = new GlancesService(this.selectedProfile);
      this.cpuFuture = this.glancesService.getCpu();
    });*/
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: ClassicHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          child: FutureBuilder<Profile>(
            future: PreferencesService.getLastProfile(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                this.selectedProfile = snapshot.data;
                this.glancesService = new GlancesService(this.selectedProfile);
                this.cpuFuture = this.glancesService.getCpu();
                if (this.selectedProfile != null) {
                  return cpuMainColumn();
                }
                return showNoProfileSelected(context);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }

          )
        )
    );
  }

  Widget cpuMainColumn() {
    return Column(
      children: [
        FutureBuilder(
            future: this.cpuFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Card(
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            _progressIndicatorContainer(),
                          ]
                      )
                  );
                case ConnectionState.done:
                  if (snapshot.data != null) {
                    return Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            ListTile(
                                leading: Icon(Icons.memory),
                                title: Text("CPU usage: " + snapshot.data.totalLoad.toString())
                            ),
                          ],
                        )
                    );
                  } else {
                    return Text("data is null");
                  }
                  return SizedBox();

                default:
                  return internalErrorText();
              }
            }
        ),
      ],
    );
  }
}




Widget _progressIndicatorContainer() {
  return Container(
      alignment: Alignment(0.0, 0.0),
      child: Padding(
        padding: EdgeInsets.all(25.0),
        child: new CircularProgressIndicator(),
      )
  );
}
