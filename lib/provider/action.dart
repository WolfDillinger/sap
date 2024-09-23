import 'package:flutter/cupertino.dart';
import 'package:sap/services/action.dart';
import 'package:sap/model/action.dart';
import 'package:uuid/uuid.dart';

class ActionProvider with ChangeNotifier {
  ActionServices _actionServices = ActionServices();
  List<ActionModel> actions = [];
  List<ActionModel> userActions = [];
  bool check = false;
  ActionProvider() {
    notifyListeners();
  }

  dynamic getActionForUser(String id) async {
    actions = await _actionServices.getAction(id);
  }

  getAction(String id) async {
    userActions = await _actionServices.getNumber(id);
  }

  dynamic addAction(
    String clientName,
    String by,
    String selectedDate,
    String selectedDate2,
    String actionType,
    String nextAction,
    String id,
    String note,
  ) async {
    var uuid = Uuid().v4();
    await _actionServices.addAction(clientName, by, selectedDate, selectedDate2,
        actionType, nextAction, id, note, uuid);
  }
}
