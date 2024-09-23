import 'package:cloud_firestore/cloud_firestore.dart';

class MonitoringModel {
  Timestamp? _time;
  String? _name;
  String? _action;
  String? _information;

  Timestamp? get time => _time;
  String? get name => _name;
  String? get action => _action;
  String? get information => _information;

  MonitoringModel.fromSnapshot(DocumentSnapshot snapshot) {
    _time = snapshot.get("time");
    _name = snapshot.get("name");
    _action = snapshot.get("action");
    _information = snapshot.get("information");
  }
}
