import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/part.dart';

class PartServices {
  String collection = "part";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PartModel>> getParts() =>
      _firestore.collection(collection).get().then(
        (result) {
          List<PartModel> parts = [];
          for (DocumentSnapshot part in result.docs) {
            parts.add(PartModel.fromSnapshot(part));
          }
          return parts;
        },
      );
}
