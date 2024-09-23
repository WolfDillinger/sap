import 'package:cloud_firestore/cloud_firestore.dart';

class AgentModel {
  String? _agentName;
  String? _agentEmail;
  String? _agentTel;
  String? _agentPhone;
  String? _agentAddress;
  String? _agentFax;
  String? _id;
  String? _country;
  String? _agentOperationEmail;
  String? _agentOperationPicName;
  String? _agentFinancialEmail;
  String? _agentFinancialPicName;
  String? _agentCode;
  String? _name;

//  getters
  String get name => _name!;
  String get agentTel => _agentTel!;
  String get agentCode => _agentCode!;
  String get agentFinancialEmail => _agentFinancialEmail!;
  String get agentFinancialPicName => _agentFinancialPicName!;
  String get agentFax => _agentFax!;
  String get agentOperationEmail => _agentOperationEmail!;
  String get agentOperationPicName => _agentOperationPicName!;
  String get agentName => _agentName!;
  String get agentEmail => _agentEmail!;
  String get agentAddress => _agentAddress!;
  String get country => _country!;
  String get id => _id!;
  String get agentPhone => _agentPhone!;

  AgentModel.fromSnapshot(DocumentSnapshot snapshot) {
    _name = snapshot.get("name");
    _agentCode = snapshot.get("agentCode");
    _agentTel = snapshot.get("agentTel");
    _agentFinancialEmail = snapshot.get("agentFinancialEmail");
    _agentFinancialPicName = snapshot.get("agentFinancialPicName");
    _agentOperationEmail = snapshot.get("agentOperationEmail");
    _agentOperationPicName = snapshot.get("agentOperationPicName");
    _id = snapshot.get("id");
    _agentPhone = snapshot.get("agentPhone");
    _agentName = snapshot.get("agentName");
    _agentEmail = snapshot.get("agentEmail");
    _agentAddress = snapshot.get("agentAddress");
    _agentFax = snapshot.get("agentFax");
  }
}
