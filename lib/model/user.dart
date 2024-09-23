import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const ID = "uid";
  static const NAME = "name";
  static const EMAIL = "email";
  static const PHONE = "phone";
  static const ROLE = "role";
  static const TITLE = "title";

  String? _name;
  String? _email;
  String? _id;
  String? _phone;
  String? _role;
  String? _title;

//  getters
  String get title => _title!;
  String get name => _name!;
  String get role => _role!;
  String get email => _email!;
  String get id => _id!;
  String get phone => _phone!;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _name = snapshot.get(NAME);
    _email = snapshot.get(EMAIL);
    _id = snapshot.get(ID);
    _phone = snapshot.get(PHONE);
    _role = snapshot.get(ROLE);
    _title = snapshot.get(TITLE);
  }
}
