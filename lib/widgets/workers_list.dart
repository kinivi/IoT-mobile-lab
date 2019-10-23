import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api/api.dart';

Widget workersList(Api api) {
  return FutureBuilder<Data>(
      future: api.getTransports(),
      builder: (context, snapshot) {
        print(snapshot.error);
        print(snapshot.hasError);
        if (snapshot.hasError || snapshot.error != null) {
            return ErrorWidget('Error');
        } else 
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return ErrorWidget('Error');
          }
          return snapshot.data != null
              ? Text('${snapshot.data.toJson()}')
              : new Container();
        } else
          return CircularProgressIndicator();
      });
}
