import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/invoice.dart';

class InvoiceServices {
  String collection = "invoice";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<InvoiceModel>> getInoices(String id) async => await _firestore
          .collection(collection)
          .where('uid', isEqualTo: id)
          .get()
          .then(
        (value) {
          List<InvoiceModel> invoices = [];
          for (DocumentSnapshot invoice in value.docs) {
            invoices.add(InvoiceModel.fromSnapshot(invoice));
          }

          return invoices;
        },
      );

  Future<bool> checkMbl(String id) async => await _firestore
          .collection(collection)
          .where('mbl', isEqualTo: id)
          .get()
          .then(
        (value) {
          List<InvoiceModel> invoices = [];
          for (DocumentSnapshot invoice in value.docs) {
            invoices.add(InvoiceModel.fromSnapshot(invoice));
          }
          if (invoices.length > 0) {
            return false;
          } else
            return true;
        },
      );

  Future<List<InvoiceModel>> getAgentInvoice(String id) async =>
      await _firestore
          .collection(collection)
          .where('mbl', isEqualTo: id)
          .get()
          .then(
        (value) {
          List<InvoiceModel> invoices = [];
          for (DocumentSnapshot invoice in value.docs) {
            invoices.add(InvoiceModel.fromSnapshot(invoice));
          }

          return invoices;
        },
      );

  Future<void> addInvoice(
    String name,
    String mbl,
    dynamic hbl,
    agentData,
    sabData,
    shipData,
    String fileNumber,
    String uid,
    String uuid,
  ) async {
    await _firestore.collection(collection).doc(uuid).set({
      'name': name,
      'mbl': mbl,
      'hbl': hbl,
      'fileNumber': fileNumber,
      'ship': shipData,
      'sab': sabData,
      'agent': agentData,
      'id': uuid,
      'uid': uid,
    });
  }
}
