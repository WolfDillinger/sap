import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/client.dart';

class ClientServices {
  String collection = "clients";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<ClientModel> getClient(String id) async =>
      await _firestore.collection(collection).doc(id).get().then((value) {
        return ClientModel.fromSnapshot(value);
      });

  Future<void> updateView(String id) async =>
      await _firestore.collection("action").doc(id).update({
        'click': true,
      });

  Future<bool> checkEmail(String id) async => await _firestore
          .collection(collection)
          .where('email', isEqualTo: id)
          .get()
          .then(
        (value) {
          List<ClientModel> clients = [];
          for (DocumentSnapshot client in value.docs) {
            clients.add(ClientModel.fromSnapshot(client));
          }
          if (clients.length > 0) {
            return false;
          } else
            return true;
        },
      );

  Future<void> updateVip(String? id, bool vip) async =>
      await _firestore.collection(collection).doc(id).update({
        'vip': vip,
      });

  Future<void> updateClient(
    String en,
    String ar,
    String email,
    String phone,
    String tel,
    String fax,
    String name,
    String code,
    String location,
    String pic,
    String taxId,
    String id,
  ) async =>
      await _firestore.collection(collection).doc(id).update({
        "tel": tel,
        "fax": fax,
        "pic": pic,
        "clearanceName": name,
        "clearanceCode": code,
        "nameEn": en,
        "nameAr": ar,
        "phone": phone,
        "location": location,
        "email": email,
        "taxId": taxId,
      });

  Future<void> deleteClient(String id) async =>
      await _firestore.collection(collection).doc(id).delete();

  Future<List<ClientModel>> search(String info, String kind) async =>
      await _firestore.collection(collection).get().then((result) {
        List<ClientModel> search = [];
        List<ClientModel> clients = [];
        for (DocumentSnapshot client in result.docs) {
          clients.add(ClientModel.fromSnapshot(client));
        }

        switch (kind) {
          case 'clearanceName':
            {
              clients.forEach((element) {
                if (element.clearanceName!
                    .toUpperCase()
                    .contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'clearanceCode':
            {
              clients.forEach((element) {
                if (element.clearanceCode!
                    .toUpperCase()
                    .contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'fax':
            {
              clients.forEach((element) {
                if (element.fax!.toUpperCase().contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'pic':
            {
              clients.forEach((element) {
                if (element.pic!.toUpperCase().contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'nameEn':
            {
              clients.forEach((element) {
                if (element.nameEn!
                    .toUpperCase()
                    .contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'nameAr':
            {
              clients.forEach((element) {
                if (element.nameAr!
                    .toUpperCase()
                    .contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'phone':
            {
              clients.forEach((element) {
                if (element.phone!.toUpperCase().contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'location':
            {
              clients.forEach((element) {
                if (element.location!
                    .toUpperCase()
                    .contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'email':
            {
              clients.forEach((element) {
                if (element.email!.toUpperCase().contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'tax':
            {
              clients.forEach((element) {
                if (element.taxId!.toUpperCase().contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
        }

        return search;
      });

  Future<void> addNewClient(
    String by,
    String en,
    String ar,
    String phone,
    String location,
    String taxId,
    String email,
    String pic,
    String name,
    String code,
    String fax,
    String uuid,
    String tel,
  ) async {
    await _firestore.collection(collection).doc(uuid).set({
      'name': by,
      "nameEn": en,
      "nameAr": ar,
      "phone": phone,
      "location": location,
      "taxId": taxId,
      "email": email,
      "id": uuid,
      "clearanceCode": code,
      "clearanceName": name,
      "fax": fax,
      "pic": pic,
      "tel": tel,
      "vip": false,
    });
  }
}
