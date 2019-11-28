import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:my_ios_app/home_page.dart';
import 'package:my_ios_app/styles.dart';
import 'package:my_ios_app/widgets/workers_list.dart';
import 'api/api.dart';
import 'api/worker.dart';

class ListPage extends StatefulWidget {
  ListPage({this.authStatus, this.api, this.onSignedOut});

  final AuthStatus authStatus;
  final Api api;
  final VoidCallback onSignedOut;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Worker> workers = [];
  StreamSubscription<ConnectivityResult> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription =
        Connectivity().onConnectivityChanged.listen(onConnectivityChange);
    if (widget.authStatus == AuthStatus.LOGGED_IN) {
      // If user logged in, get api call for list request
      _updateList();
    }
  }

  Future<void> _updateList() async {
    Data data;
    //Get data from
    try {
      data = await widget.api.getTransports();
    } catch (e) {
      print(e.toString());
      print(_scaffoldKey);
      _scaffoldKey.currentState.showSnackBar(_buildErrorSnackBar());
    }
    setState(() {
      workers = data.workers;
    });
  }

  void onConnectivityChange(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      _scaffoldKey.currentState.showSnackBar(_buildNoNetworkSnackBar());
    }
  }

  Widget _buildErrorSnackBar() {
    return new SnackBar(
      content: Text('Ooops... Something wrong'),
      action: SnackBarAction(
        label: 'Retry',
        onPressed: () {
          _updateList();
        },
      ),
    );
  }

  Widget _buildNoNetworkSnackBar() {
    return new SnackBar(
      content: Text('No internet connection'),
      backgroundColor: Colors.redAccent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        body: new Container(
          child: new Center(
              child: new RefreshIndicator(
                  onRefresh: _updateList,
                  child: new Padding(
                      padding: Styles.homeListPadding,
                      child: workers.length != 0
                          ? WorkersList(workers)
                          : CircularProgressIndicator()))),
        ));
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
