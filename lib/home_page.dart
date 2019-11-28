import 'package:flutter/material.dart';
import 'package:my_ios_app/list_page.dart';
import 'package:my_ios_app/profile_page.dart';
import 'package:my_ios_app/strings.dart';
import 'api/api.dart';
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
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
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
                    : Container(),
                bottom: TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.map)),
                    Tab(icon: Icon(Icons.timeline)),
                    Tab(icon: Icon(Icons.settings)),
                  ],
                ),
                title: Text(Strings.appTitle),
              ),
              body: TabBarView(
                children: [
                  ListPage(
                      authStatus: authStatus,
                      onSignedOut: _onSignedOut,
                      api: widget.api),
                  Icon(Icons.timeline),
                  ProfilePage(auth: widget.auth)
                ],
              ),
            ),
          );
        } else
          return _buildWaitingScreen();
        break;
      default:
        return _buildWaitingScreen();
    }
  }
}
