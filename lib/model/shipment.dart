import 'package:cloud_firestore/cloud_firestore.dart';

class ShipmentModel {
  dynamic _mbl;
  dynamic _hbl;
  dynamic _vol;
  dynamic _container;
  dynamic _size;
  String? _pol;
  String? _id;
  String? _pod;
  String? _agentName;
  String? _agentCode;
  String? _uid;
  dynamic _loading;
  dynamic _arrival;
  String? _shipingLine;
  String? _comment;
  String? _file;
  String? _name;

  String get id => _id!;
  String get name => _name!;
  String get file => _file!;
  String get comment => _comment!;
  String get agentCode => _agentCode!;
  dynamic get mbl => _mbl!;
  String get shipingLine => _shipingLine!;
  String get agentName => _agentName!;
  dynamic get hbl => _hbl!;
  dynamic get vol => _vol!;
  dynamic get container => _container!;
  dynamic get size => _size!;
  String get pol => _pol!;
  String get uid => _uid!;
  String get pod => _pod!;
  dynamic get arrival => _arrival!;
  dynamic get loading => _loading!;

  ShipmentModel.fromSnapshot(DocumentSnapshot snapshot) {
    _name = snapshot.get("name");
    _file = snapshot.get("file");
    _comment = snapshot.get("comment");
    _agentCode = snapshot.get("agentCode");
    _shipingLine = snapshot.get("shipingLine");
    _mbl = snapshot.get("mbl");
    _id = snapshot.get("id");
    _hbl = snapshot.get("hbl");
    _agentName = snapshot.get("agentName");
    _vol = snapshot.get("vol");
    _size = snapshot.get("size");
    _container = snapshot.get("container");
    _pol = snapshot.get("pol");
    _uid = snapshot.get("uid");
    _pod = snapshot.get("pod");
    _arrival = snapshot.get("arrival");
    _loading = snapshot.get("loading");
  }
}
