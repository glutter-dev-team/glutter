import 'package:flutter/material.dart';
import 'package:glutter/models/monitoring/sensor.dart';
import 'package:glutter/models/shared/profile.dart';
import 'package:glutter/screens/monitoring/monitoring_data_list_builder.dart';
import 'package:glutter/screens/monitoring/monitoring_screen.dart';
import 'package:glutter/services/monitoring/glances_service.dart';
import 'package:glutter/services/shared/preferences_service.dart';
import 'package:glutter/widgets/async.dart';
import 'package:glutter/widgets/errors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SensorsTab extends StatefulWidget {
  @override
  _SensorsTabState createState() => _SensorsTabState();
}

class _SensorsTabState extends State<SensorsTab> {
  GlancesService glancesService;
  Profile selectedProfile;
  Future sensorsFuture;

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() {
    this.setState(() {
      this.sensorsFuture = this.glancesService.getSensors();
    });
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
              this.sensorsFuture = this.glancesService.getSensors();

              if (this.selectedProfile != null) {
                return _memoryMainColumn();
              }
              return showNoProfileSelected(context);
            } else {
              return progressIndicatorContainer();
            }
          }
        )
      )
    );
  }

  Widget _memoryMainColumn() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: FutureBuilder(
            future: this.sensorsFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return progressIndicatorContainer();
                case ConnectionState.done:
                  if (snapshot.data != null && snapshot.data.length > 0) {
                    List<List> dataList = DataListBuilder.sensorsList(snapshot);
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dataList.length,
                      itemBuilder: (BuildContext context, int entity) {
                        var entityProps = dataList[entity];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Card(
                            child: Column(
                              children: [
                                PurpleCardHeader(
                                  title: entityProps[0]["value"],
                                  iconData: Icons.toys,
                                ),
                                ListTile(
                                  title: Text(
                                    entityProps[3]["value"], // sensor type
                                  ),
                                  subtitle: Text(entityProps[1]["value"] + entityProps[2]["value"]), // sensor value + unit
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    );
                  } else {
                    return showNoDataReceived(this.selectedProfile, "Sensors");
                  }
                  return SizedBox();

                default:
                  return internalErrorText();
              }
            }
          ),
        ),
      ],
    );
  }
}