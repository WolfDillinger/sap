import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/shipment.dart';

class ShipmentServices {
  String collection = "shipment";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> checkMbl(String id) async => await _firestore
          .collection(collection)
          .where('mbl', isEqualTo: id)
          .get()
          .then(
        (value) {
          List<ShipmentModel> shipemnts = [];
          for (DocumentSnapshot shipemnt in value.docs) {
            shipemnts.add(ShipmentModel.fromSnapshot(shipemnt));
          }
          if (shipemnts.length > 0) {
            return false;
          } else
            return true;
        },
      );

  Future<List<ShipmentModel>> getShipments(String id) async => await _firestore
          .collection(collection)
          .where('uid', isEqualTo: id)
          .get()
          .then(
        (value) {
          List<ShipmentModel> shipemnts = [];
          for (DocumentSnapshot shipemnt in value.docs) {
            shipemnts.add(ShipmentModel.fromSnapshot(shipemnt));
          }

          return shipemnts;
        },
      );
  Future<void> updateHbl(dynamic hbl, String url, String id) async =>
      await _firestore.collection(collection).doc(id).update({
        'hbl': {
          'number': hbl,
          'file': url,
        },
      });
  Future<void> deleteShipment(String id) async =>
      await _firestore.collection(collection).doc(id).delete();
  Future<void> updatePol(String pol, String id) async =>
      await _firestore.collection(collection).doc(id).update({
        'pol': pol,
      });
  Future<void> updateMbl(String mbl, String id) async =>
      await _firestore.collection(collection).doc(id).update({
        'mbl': mbl,
      });
  Future<void> updateAgentCode(String code, String id) async =>
      await _firestore.collection(collection).doc(id).update({
        'agentCode': code,
      });
  Future<void> updateAgentName(String name, String id) async =>
      await _firestore.collection(collection).doc(id).update({
        'agentName': name,
      });
  Future<void> updatePod(String pod, String id) async =>
      await _firestore.collection(collection).doc(id).update({
        'pod': pod,
      });
  Future<void> updateSealine(String shipingLine, String id) async =>
      await _firestore.collection(collection).doc(id).update({
        'shipingLine': shipingLine,
      });
  Future<void> updateComment(String comment, String id) async =>
      await _firestore.collection(collection).doc(id).update({
        'comment': comment,
      });

  Future<List<ShipmentModel>> getShipmentsAgent(String id) async =>
      await _firestore
          .collection(collection)
          .where('agentCode', isEqualTo: id)
          .get()
          .then(
        (value) {
          List<ShipmentModel> shipemnts = [];
          for (DocumentSnapshot shipemnt in value.docs) {
            shipemnts.add(ShipmentModel.fromSnapshot(shipemnt));
          }

          return shipemnts;
        },
      );
  Future<List<ShipmentModel>> search(String info, String kind) async =>
      await _firestore.collection(collection).get().then((result) {
        List<ShipmentModel> search = [];
        List<ShipmentModel> shipments = [];
        for (DocumentSnapshot shipment in result.docs) {
          shipments.add(ShipmentModel.fromSnapshot(shipment));
        }

        switch (kind) {
          case 'MBL':
            {
              shipments.forEach((element) {
                if (element.mbl.toUpperCase().contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'HBL':
            {
              shipments.forEach((element) {
                element.hbl['number'].forEach((item) {
                  if (item.toUpperCase().contains(info.toUpperCase())) {
                    search.add(element);
                  }
                });
              });
              break;
            }
          case 'Container Number':
            {
              shipments.forEach((element) {
                element.container.forEach((item) {
                  if (item.toUpperCase().contains(info.toUpperCase())) {
                    search.add(element);
                  }
                });
              });
              break;
            }
          case 'Volume':
            {
              shipments.forEach((element) {
                element.vol.forEach((item) {
                  if (item.toUpperCase().contains(info.toUpperCase())) {
                    search.add(element);
                  }
                });
              });
              break;
            }
          case 'POL':
            {
              shipments.forEach((element) {
                if (element.pol.toUpperCase().contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'POD':
            {
              shipments.forEach((element) {
                if (element.pod.toUpperCase().contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'Shiping Line':
            {
              shipments.forEach((element) {
                if (element.shipingLine
                    .toUpperCase()
                    .contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'Agent Name':
            {
              shipments.forEach((element) {
                if (element.agentName
                    .toUpperCase()
                    .contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
        }

        return search;
      });

  Future<void> addShipment(
    String name,
    dynamic hblInfo,
    dynamic sizeInfo,
    dynamic volInfo,
    dynamic conInfo,
    dynamic pol,
    dynamic pod,
    dynamic mbl,
    dynamic agentName,
    dynamic agentCode,
    dynamic mblUrl,
    dynamic hblUrl,
    String loading,
    String arrival,
    String comment,
    String sealine,
    String uid,
    String uuid,
  ) async {
    await _firestore.collection(collection).doc(uuid).set({
      'name': name,
      'loading': loading,
      'arrival': arrival,
      'comment': comment,
      'pol': pol,
      'pod': pod,
      'mbl': mbl,
      'file': mblUrl,
      'hbl': {
        'number': hblInfo,
        'file': hblUrl,
      },
      'size': sizeInfo,
      'container': conInfo,
      'vol': volInfo,
      'shipingLine': sealine,
      'agentName': agentName,
      'agentCode': agentCode,
      'id': uuid,
      'uid': uid,
    });
  }
}
