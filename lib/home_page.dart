import 'package:flutter/material.dart';
import 'package:my_ios_app/styles.dart';
import 'package:my_ios_app/widgets/workers_list.dart';
import 'api/api.dart';
import 'api/worker.dart';
import 'authentication.dart';
import 'login_signup_page.dart';
import './api/api.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.api});

  final Auth auth;
  final Api api;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class _HomePageState extends State<HomePage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  String _userName = "";

  List<Worker> workers = [];

  Future<void> _updateList() async {
    //Get data from
    Data data = await widget.api.getTransports();

    setState(() {
      workers = data.workers;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user.uid;
        } else {}
        if (_userId == "" || _userId == null) {
          authStatus = AuthStatus.NOT_LOGGED_IN;
        } else
          authStatus = AuthStatus.LOGGED_IN;
        // If user logged in, get api call for list request
        _updateList();
      });
    });
  }

  void _onLoggedIn() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
        _userName = user.displayName.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void _onSignedOut() {
    widget.auth.signOut();
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginSignUpPage(
          auth: widget.auth,
          onSignedIn: _onLoggedIn,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return new Scaffold(
              appBar: new AppBar(
                  title: new Text("Flutter login demo"),
                  actions: authStatus == AuthStatus.LOGGED_IN
                      ? <Widget>[
                          // action button
                          IconButton(
                            icon: Icon(Icons.exit_to_app),
                            onPressed: () {
                              _onSignedOut();
                            },
                          )
                        ]
                      : Container()),
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
        } else
          return _buildWaitingScreen();
        break;
      default:
        return _buildWaitingScreen();
    }
  }
}
