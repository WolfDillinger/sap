import 'package:cloud_firestore/cloud_firestore.dart';

class PartModel {
  String? _address;
  String? _phone;
  String? _companyName;
  String? _taxId;
  String? _agentName;
  String? _id;
  String? _email;

  String get id => _id!;
  String get taxId => _taxId!;
  String get agentName => _agentName!;
  String get companyName => _companyName!;
  String get address => _address!;
  String get phone => _phone!;
  String get email => _email!;

  PartModel.fromSnapshot(DocumentSnapshot snapshot) {
    _email = snapshot.get("email");
    _id = snapshot.get("id");
    _taxId = snapshot.get("taxId");
    _agentName = snapshot.get("agentName");
    _address = snapshot.get("address");
    _companyName = snapshot.get("companyName");
    _phone = snapshot.get("phone");
  }
}
