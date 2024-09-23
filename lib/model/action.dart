import 'package:cloud_firestore/cloud_firestore.dart';

class ActionModel {
  String? _actionType;
  String? _date;
  String? _id;
  String? _nextActionType;
  String? _nextDate;
  String? _note;
  String? _uid;
  String? _by;
  String? _clientName;
  bool? _click;

  bool get click => _click!;
  String get by => _by!;
  String get clientName => _clientName!;
  String get actionType => _actionType!;
  String get date => _date!;
  String get id => _id!;
  String get nextActionType => _nextActionType!;
  String get nextDate => _nextDate!;
  String get note => _note!;
  String get uid => _uid!;

  ActionModel.fromSnapshot(DocumentSnapshot snapshot) {
    _clientName = snapshot.get("clientName");
    _click = snapshot.get("click");
    _by = snapshot.get("by");
    _actionType = snapshot.get("actionType");
    _date = snapshot.get("date");
    _nextActionType = snapshot.get("nextActionType");
    _nextDate = snapshot.get("nextDate");
    _note = snapshot.get("note");
    _uid = snapshot.get("uid");
    _id = snapshot.get("id");
  }
  ActionModel.fromJson(Map<String, dynamic> snapshot) {
    print(snapshot["by"]);
    _click = snapshot["click"];
    _by = snapshot["by"];
    _actionType = snapshot["actionType"];
    _date = snapshot["date"];
    _nextActionType = snapshot["nextActionType"];
    _nextDate = snapshot["nextDate"];
    _note = snapshot["note"];
    _uid = snapshot["uid"];
    _id = snapshot["id"];
  }
}
