import 'package:cloud_firestore/cloud_firestore.dart';

class VipModel {
  int? _shipmentsNo;
  int? _shipmentsOut;
  int? _shipmentsIn;
  int? _shipmentsPart;
  String? _companyName;
  String? _phone;
  String? _agentName;
  String? _taxId;
  String? _email;

  String get phone => _phone!;
  String get email => _email!;
  String get taxId => _taxId!;
  int get shipmentsNo => _shipmentsNo!;
  int get shipmentsOut => _shipmentsOut!;
  int get shipmentsIn => _shipmentsIn!;
  int get shipmentsPart => _shipmentsPart!;
  String get companyName => _companyName!;
  String get agentName => _agentName!;

  VipModel.fromSnapshot(DocumentSnapshot snapshot) {
    _email = snapshot.get("email");
    _shipmentsPart = snapshot.get("shipmentsPart");
    _shipmentsIn = snapshot.get("shipmentsIn");
    _shipmentsOut = snapshot.get("shipmentsOut");
    _shipmentsNo = snapshot.get("_shipmentsNo");
    _companyName = snapshot.get("companyName");
    _phone = snapshot.get("phone");
    _taxId = snapshot.get("taxId");
    _agentName = snapshot.get("agentName");
  }
}
