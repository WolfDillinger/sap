import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String? _pol;
  String? _pod;
  String? _containerNo;
  String? _companyName;
  String? _states;
  String? _careName;
  String? _id;
  Timestamp? _etd;

  String get pol => _pol!;
  String get id => _id!;
  String get pod => _pod!;
  String get containerNo => _containerNo!;
  String get companyName => _companyName!;
  String get states => _states!;
  String get careName => _careName!;
  Timestamp get etd => _etd!;

  NotificationModel.fromSnapshot(DocumentSnapshot snapshot) {
    _pol = snapshot.get("pol");
    _id = snapshot.get("id");
    _pod = snapshot.get("pod");
    _containerNo = snapshot.get("containerNo");
    _states = snapshot.get("states");
    _companyName = snapshot.get("companyName");
    _careName = snapshot.get("careName");
    _etd = snapshot.get("etd");
  }
}
