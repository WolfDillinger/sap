import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/clearance.dart';

class ClearanceServices {
  String collection = "clearance";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<ClearanceModel> getClearanceById(String id) async =>
      await _firestore.collection(collection).doc(id).get().then(
        (result) {
          return ClearanceModel.fromSnapshot(result);
        },
      );

  Future<bool> checkEmail(String id) async => await _firestore
          .collection(collection)
          .where('email', isEqualTo: id)
          .get()
          .then(
        (value) {
          List<ClearanceModel> clearances = [];
          for (DocumentSnapshot clearance in value.docs) {
            clearances.add(ClearanceModel.fromSnapshot(clearance));
          }
          if (clearances.length > 0) {
            return false;
          } else
            return true;
        },
      );

  Future<List<ClearanceModel>> search(String info, String kind) async =>
      await _firestore.collection(collection).get().then((result) {
        List<ClearanceModel> search = [];
        List<ClearanceModel> clearances = [];

        for (DocumentSnapshot clearance in result.docs) {
          clearances.add(ClearanceModel.fromSnapshot(clearance));
        }
        switch (kind) {
          case 'Name':
            {
              clearances.forEach((element) {
                if (element.name.toUpperCase().contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'Email':
            {
              clearances.forEach((element) {
                if (element.email.toUpperCase().contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'Address':
            {
              clearances.forEach((element) {
                if (element.address
                    .toUpperCase()
                    .contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'Phone':
            {
              clearances.forEach((element) {
                if (element.phone.toUpperCase().contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'Fax':
            {
              clearances.forEach((element) {
                if (element.fax.toUpperCase().contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'Tel':
            {
              clearances.forEach((element) {
                if (element.tel.toUpperCase().contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'Code':
            {
              clearances.forEach((element) {
                if (element.code.toUpperCase().contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'Pic':
            {
              clearances.forEach((element) {
                if (element.pic.toUpperCase().contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
        }

        return search;
      });

  Future<void> addNewClearance(
    String by,
    String name,
    String address,
    String fax,
    String tel,
    String phone,
    String email,
    String code,
    String pic,
    String uuid,
  ) async {
    await _firestore.collection(collection).doc(uuid).set({
      'by': by,
      "name": name,
      "phone": phone,
      "address": address,
      "code": code,
      "email": email,
      "id": uuid,
      "fax": fax,
      "pic": pic,
      "tel": tel,
    });
  }

  Future<void> editClearance(
    String by,
    String name,
    String address,
    String fax,
    String tel,
    String phone,
    String email,
    String code,
    String pic,
    String uuid,
  ) async {
    await _firestore.collection(collection).doc(uuid).update({
      'by': by,
      "name": name,
      "phone": phone,
      "address": address,
      "code": code,
      "email": email,
      "id": uuid,
      "fax": fax,
      "pic": pic,
      "tel": tel,
    });
  }
}
