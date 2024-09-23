import 'package:cloud_firestore/cloud_firestore.dart';

class MonitoringServices {
  String collection = "monitoring";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addMonitoring(
    String name,
    String information,
    String action,
    DateTime time,
    String uuid,
  ) async {
    await _firestore.collection(collection).doc(uuid).set({
      'name': name,
      'action': action,
      'time': time,
      'id': uuid,
      'information': information,
    });
  }
}
