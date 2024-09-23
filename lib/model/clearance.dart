import 'package:cloud_firestore/cloud_firestore.dart';

class ClearanceModel {
  String? _pic;
  String? _tel;
  String? _fax;
  String? _name;
  String? _id;
  String? _address;
  String? _email;
  String? _phone;
  String? _code;

  String get tel => _tel!;
  String get fax => _fax!;
  String get email => _email!;
  String get address => _address!;
  String get phone => _phone!;
  String get name => _name!;
  String get id => _id!;
  String get code => _code!;
  String get pic => _pic!;

  ClearanceModel.fromSnapshot(DocumentSnapshot snapshot) {
    _tel = snapshot.get("tel");
    _fax = snapshot.get("fax");
    _pic = snapshot.get("pic");
    _code = snapshot.get("code");
    _email = snapshot.get("email");
    _address = snapshot.get("address");
    _phone = snapshot.get("phone");
    _name = snapshot.get("name");
    _id = snapshot.get("id");
  }
}
