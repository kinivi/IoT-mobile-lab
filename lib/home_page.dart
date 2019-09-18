import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'authentication.dart';
import 'login_signup_page.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth});

  final BaseAuth auth;

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

        print("//");
        print(authStatus);
        print("" == _userId);
        print("//");

        if (_userId == "" || _userId == null) {
          authStatus = AuthStatus.NOT_LOGGED_IN;
        } else
          authStatus = AuthStatus.LOGGED_IN;

        print("//-//");
        print(authStatus);
        print(_userId);
        print(_userName);
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
    print(authStatus);

    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        print(authStatus);
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
            ),
            body: new ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
              _showBoy(),
              new Text("uID: " + _userId),
              new Padding(padding: new EdgeInsets.fromLTRB(0, 20, 0, 20),),
              new MaterialButton(
                elevation: 5.0,
                minWidth: 100.0,
                height: 50.0,
                color: Colors.blue,
                textColor: Colors.white,

                child: new Text("Sign Out"),
                onPressed: _onSignedOut,
              )
            ]),
          );
        } else
          return _buildWaitingScreen();
        break;
      default:
        return _buildWaitingScreen();
    }
  }

  Widget _showBoy() {
    return new Hero(
      tag: 'boy',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 30.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 100.0,
          child: Image.asset('assets/fboy.png'),
        ),
      ),
    );
  }
}
