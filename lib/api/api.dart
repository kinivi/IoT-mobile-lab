import 'dart:async';
import 'dart:io';
import 'package:my_ios_app/api/worker.dart';
import 'dart:convert';
import '../config/google_api_config.dart';
import 'package:http/http.dart' as http;

abstract class Api {
  Future<Data> getTransports();
  Future<int> postTransport(Worker worker);
}

class SQLApi implements Api {
  Transport transportFromJson(String str) =>
      Transport.fromJson(json.decode(str));

  String transportToJson(Transport data) => json.encode(data.toJson());

  Future<Data> getTransports() async {
    final response = await http.get(api_url);
    return transportFromJson(response.body).data;
  }
  
  Future<int> postTransport(Worker worker) async {
    final json = worker.toJson();
    final response = await http.post(api_url, headers: {'Content-type' : 'application/json', },  body: jsonEncode(json));
    print(response.toString());
    return response.statusCode;
  }
}

class Transport {
  String status;
  Data data;

  Transport({
    this.status,
    this.data,
  });

  factory Transport.fromJson(Map<String, dynamic> json) => Transport(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  List<Worker> workers;

  Data({
    this.workers,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        workers:
            List<Worker>.from(json["workers"].map((x) => Worker.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "workers": List<dynamic>.from(workers.map((x) => x.toJson())),
      };
}
