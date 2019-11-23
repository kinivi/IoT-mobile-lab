import 'package:flutter/material.dart';
import 'package:my_ios_app/api/api.dart';
import 'package:my_ios_app/strings.dart';
import 'authentication.dart';
import 'home_page.dart';

void main() => runApp(new MyApp());
Auth auth = new FireAuth();
Api api = new SQLApi();

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: Strings.appTitle,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomePage(auth: auth, api: api)
    );
  }
}