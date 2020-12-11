import 'package:flutter/material.dart';
import 'package:glutter/screens/settings/manage_profiles/profile_create_screen.dart';
import 'package:glutter/screens/settings/manage_profiles/profile_edit_screen.dart';
import 'package:glutter/services/shared/database_service.dart';
import 'package:glutter/widgets/errors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProfileListScreen extends StatefulWidget {
  ProfileListScreen({Key key, this.title: "Profiles"}) : super(key: key);

  static const String routeName = '/settings/profiles';
  final String title;

  @override
  _ProfileListState createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileListScreen> {
  Future profilesFuture;

  @override
  void initState() {
    profilesFuture = DatabaseService.db.getProfiles();
    super.initState();
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 500));

    this.setState(() {
      this.profilesFuture = DatabaseService.db.getProfiles();
    });

    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: ClassicHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: Builder(
          builder: (context) => Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 75.0),
                  children: <Widget>[
                    FutureBuilder(
                      future: profilesFuture,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.active:
                          case ConnectionState.waiting:
                            return Center(
                              child: Container(
                                child: new CircularProgressIndicator(),
                                alignment: Alignment(0.0, 0.0),
                              ),
                            );
                          case ConnectionState.done:
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Text(snapshot.data[index].caption),
                                  subtitle: Text(snapshot.data[index].serverAddress),
                                  trailing: Icon(Icons.edit),
                                  onTap: () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfileEditScreen(),
                                        settings: RouteSettings(
                                          arguments: snapshot.data[index],
                                        ),
                                      ),
                                    ).then((value) {
                                      this._onRefresh();
                                    }),
                                  });
                              });
                          default:
                            return internalErrorText();
                        }
                      }
                    ),
                  ],
              )),
            ])
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileCreateScreen()),
          ).then((value) {
            setState(() {
              this._onRefresh();
            });
          })
        },
        tooltip: 'Create new profile',
        child: Icon(Icons.add),
      ),
    );
  }
}
