import 'package:flutter/material.dart';
import 'package:glutter/models/shared/profile.dart';
import 'package:glutter/screens/monitoring/monitoring_data_list_builder.dart';
import 'package:glutter/screens/monitoring/monitoring_screen.dart';
import 'package:glutter/services/monitoring/glances_service.dart';
import 'package:glutter/services/shared/preferences_service.dart';
import 'package:glutter/widgets/async.dart';
import 'package:glutter/widgets/errors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NetworksTab extends StatefulWidget {
  @override
  _NetworksTabState createState() => _NetworksTabState();
}

class _NetworksTabState extends State<NetworksTab> {
  GlancesService glancesService;
  Profile selectedProfile;
  Future networksFuture;

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() {
    this.setState(() {
      this.networksFuture = this.glancesService.getNetworks();
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
              this.networksFuture = this.glancesService.getNetworks();

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
            future: this.networksFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return progressIndicatorContainer();
                case ConnectionState.done:
                  if (snapshot.data != null && snapshot.data.length > 0) {
                    List<List> dataList = networksListBuilder(snapshot);
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
                                  iconData: Icons.settings_ethernet,
                                ),
                                ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: entityProps.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    if (index == 0) {
                                      return SizedBox(
                                        height: 7.5,
                                      );
                                    } else if (entityProps[index]["short_desc"] == "Is up") {
                                      IconData isUp;
                                      if (entityProps[index]["value"]) {
                                        isUp = Icons.check;
                                      } else {
                                        isUp = Icons.clear;
                                      }
                                      return Column(
                                        children: [
                                          ListTile(
                                            title: Text(entityProps[index]["short_desc"]),
                                            trailing: Icon(
                                              isUp,
                                              size: 18.0,
                                            ),
                                            onTap: () {
                                              showHelpTextDialog(context, entityProps[index]);
                                            },
                                          ),
                                          (index != entityProps.length - 1)
                                            ? Divider(
                                                color: Colors.grey.shade900,
                                                thickness: 1.0,
                                              )
                                            : SizedBox(
                                                height: 7.5,
                                              ),
                                        ],
                                      );
                                    } else {
                                      return Column(
                                        children: [
                                          ListTile(
                                            title: Text(entityProps[index]["short_desc"]),
                                            trailing: Text(entityProps[index]["value"]),
                                            onTap: () {
                                              showHelpTextDialog(context, entityProps[index]);
                                            },
                                          ),
                                          (index != entityProps.length - 1)
                                            ? Divider(
                                                color: Colors.grey.shade900,
                                                thickness: 1.0,
                                              )
                                            : SizedBox(
                                                height: 7.5,
                                              ),
                                        ],
                                      );
                                    }
                                  }
                                )
                              ],
                            )
                          )
                        );
                      }
                    );
                  } else {
                    return showNoDataReceived(this.selectedProfile, "Networks");
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