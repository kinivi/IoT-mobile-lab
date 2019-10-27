import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_ios_app/api/worker.dart';
import 'package:my_ios_app/styles.dart';

class WorkersList extends StatelessWidget {
  List<Worker> workers;

  WorkersList(this.workers);

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
                  child: new Column(
                children: <Widget>[
                  Image.network(workers[index].imageLink),
                  Padding(
                    padding: Styles.cardPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          // Vechile Name
                          Padding(
                            padding: Styles.cardHeadPadding,
                            child: Text(
                              workers[index].transportName,
                              style: Styles.primaryCardText,
                              textAlign: TextAlign.center,
                            
                            ),
                          ),
                          Text("TransportID: " + workers[index].transportId.toString()),
                          Text("MineID: " + workers[index].mineId.toString()),
                        ],
                      ),
                    
                  )
                ],
              ))
            ],
          )));
        });
  }
}
