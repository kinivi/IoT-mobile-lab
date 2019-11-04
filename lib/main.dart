import 'package:flutter/material.dart';
import 'package:my_ios_app/api/api.dart';
import 'authentication.dart';
import 'home_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Login Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomePage(auth: new FireAuth(), api: new SQLApi())
    );
  }
}