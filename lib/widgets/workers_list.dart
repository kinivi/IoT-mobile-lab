import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_ios_app/api/worker.dart';
import '../api/api.dart';

class WorkersList extends StatelessWidget {
  Api api;

  WorkersList(this.api);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: workers == null ? 0 : workers.length,
        itemBuilder: (BuildContext context, int index) {
          return new Container(
              child: new Center(
                  child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Card(
                  child: new Container(
                child: new Text(workers[index].transportName),
                padding: const EdgeInsets.all(20),
              ))
            ],
          )));
        });
  }
}
