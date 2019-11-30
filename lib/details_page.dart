import 'package:flutter/material.dart';
import 'package:my_ios_app/api/worker.dart';
import 'package:my_ios_app/strings.dart';
import 'package:my_ios_app/styles.dart';

class DetailsPage extends StatelessWidget {
  Worker worker; 
  DetailsPage({Key key, this.worker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.detailsPageTitle),
      ),
      body: new Container(
              child: new Center(
                  child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => new DetailsPage(),
                  ),
                ),
                    child: new Column(
                  children: <Widget>[
                    Image.network(worker.imageLink),
                    Padding(
                      padding: Styles.cardPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          // Vechile Name
                          Padding(
                            padding: Styles.cardHeadPadding,
                            child: Text(
                              worker.transportName,
                              style: Styles.primaryCardText,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text("TransportID: " +
                              worker.transportId.toString()),
                          Text("MineID: " + worker.mineId.toString()),
                        ],
                      ),
                    )
                  ],
                )),
            ],
          )))
    );
  }
}