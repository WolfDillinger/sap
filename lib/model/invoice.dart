import 'package:cloud_firestore/cloud_firestore.dart';

class InvoiceModel {
  String? _id;
  String? _uid;
  String? _fileNumber;
  String? _mbl;
  String? _name;
  dynamic _hbl;
  dynamic _sab;
  dynamic _agent;
  dynamic _ship;

  dynamic get sab => _sab;
  dynamic get agent => _agent;
  dynamic get ship => _ship;
  String? get mbl => _mbl;
  dynamic get hbl => _hbl;
  String? get fileNumber => _fileNumber;
  String? get id => _id;
  String? get uid => _uid;
  String? get name => _name;

  InvoiceModel.fromSnapshot(DocumentSnapshot snapshot) {
    _sab = snapshot.get("sab");
    _agent = snapshot.get("agent");
    _ship = snapshot.get("ship");
    _mbl = snapshot.get("mbl");
    _hbl = snapshot.get("hbl");
    _fileNumber = snapshot.get("fileNumber");
    _id = snapshot.get("id");
    _uid = snapshot.get("uid");
    _name = snapshot.get("name");
  }
}
