import 'package:flutter/material.dart';
import 'package:glutter/models/monitoring/memory.dart';
import 'package:glutter/models/shared/profile.dart';
import 'package:glutter/screens/monitoring/monitoring_data_list_builder.dart';
import 'package:glutter/screens/monitoring/monitoring_screen.dart';
import 'package:glutter/services/monitoring/glances_service.dart';
import 'package:glutter/services/shared/preferences_service.dart';
import 'package:glutter/widgets/async.dart';
import 'package:glutter/widgets/errors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MemoryTab extends StatefulWidget {
  @override
  _MemoryTabState createState() => _MemoryTabState();
}

class _MemoryTabState extends State<MemoryTab> {
  GlancesService glancesService;
  Profile selectedProfile;
  Future memFuture;

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() {
    this.setState(() {
      this.memFuture = this.glancesService.getMemory();
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
              this.memFuture = this.glancesService.getMemory();

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
        FutureBuilder(
          future: this.memFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.waiting:
                return progressIndicatorContainer();
              case ConnectionState.done:
                if (snapshot.data != null) {
                  Memory memory = snapshot.data;
                  List<List> dataList = DataListBuilder.memoryList(snapshot);
                  return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dataList.length,
                      itemBuilder: (BuildContext context, int entity) {
                        var entityProps = dataList[entity];
                        return Card(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: entityProps.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  (index == 0) ? SizedBox(height: 7.5,) : SizedBox(),
                                  ListTile(
                                    title: Text(
                                      entityProps[index]["label"]
                                    ),
                                    trailing: Text(
                                      entityProps[index]["value"]
                                    ),
                                    onTap: () {
                                      showHelpTextDialog(
                                        context,
                                        entityProps[index]);
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
                          )
                        );
                      }
                    )
                  );
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
