import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/action.dart';

class ActionServices {
  String collection = "action";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ActionModel>> getAction(String id) async => await _firestore
          .collection(collection)
          .where('uid', isEqualTo: id)
          .get()
          .then(
        (value) {
          List<ActionModel> actions = [];
          for (DocumentSnapshot action in value.docs) {
            actions.add(ActionModel.fromSnapshot(action));
          }

          return actions;
        },
      );

  getNumber(String name) async => await _firestore
          .collection(collection)
          .where('by', isEqualTo: name)
          .where('click', isEqualTo: false)
          .get()
          .then(
        (value) {
          List<ActionModel> actions = [];
          for (DocumentSnapshot action in value.docs) {
            actions.add(ActionModel.fromSnapshot(action));
          }

          return actions;
        },
      );

  Future<void> addAction(
    String clientName,
    String by,
    String selectedDate,
    String selectedDate2,
    String actionType,
    String nextAction,
    String id,
    String note,
    String uuid,
  ) async {
    await _firestore.collection(collection).doc(uuid).set({
      'clientName': clientName,
      'by': by,
      'actionType': actionType,
      'date': selectedDate,
      'nextActionType': nextAction,
      'note': note,
      'id': uuid,
      'uid': id,
      'nextDate': selectedDate2,
      'click': false,
    });
  }
}
