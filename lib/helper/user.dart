import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user.dart';

class UserServices {
  String collection = "users";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserById(String id) async =>
      await _firestore.collection(collection).doc(id).get().then(
        (dataSnapshot) {
          return UserModel.fromSnapshot(dataSnapshot);
        },
      );
}
