import 'package:cloud_firestore/cloud_firestore.dart';

class ClientModel {
  String? _nameEn;
  String? _nameAr;
  String? _phone;
  String? _email;
  String? _location;
  String? _taxId;
  String? _pic;
  String? _fax;
  String? _clearanceName;
  String? _clearanceCode;
  String? _id;
  String? _tel;
  bool? _vip;

  bool? get vip => _vip;
  String? get tel => _tel;
  String? get pic => _pic;
  String? get fax => _fax;
  String? get id => _id;
  String? get clearanceName => _clearanceName;
  String? get clearanceCode => _clearanceCode;
  String? get nameEn => _nameEn;
  String? get nameAr => _nameAr;
  String? get phone => _phone;
  String? get location => _location;
  String? get email => _email;
  String? get taxId => _taxId;

  void setVip(bool newVip) => _vip = newVip;

  ClientModel.fromSnapshot(DocumentSnapshot snapshot) {
    _tel = snapshot.get("tel");
    _fax = snapshot.get("fax");
    _vip = snapshot.get("vip");
    _pic = snapshot.get("pic");
    _id = snapshot.get("id");
    _clearanceName = snapshot.get("clearanceName");
    _clearanceCode = snapshot.get("clearanceCode");
    _nameEn = snapshot.get("nameEn");
    _nameAr = snapshot.get("nameAr");
    _phone = snapshot.get("phone");
    _location = snapshot.get("location");
    _email = snapshot.get("email");
    _taxId = snapshot.get("taxId");
  }
}
