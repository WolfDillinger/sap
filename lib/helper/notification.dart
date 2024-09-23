import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/notification.dart';

class NotificationServices {
  String collection = "notification";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<NotificationModel>> getNotifications() =>
      _firestore.collection(collection).get().then(
        (result) {
          List<NotificationModel> notifications = [];
          for (DocumentSnapshot notification in result.docs) {
            notifications.add(NotificationModel.fromSnapshot(notification));
          }
          return notifications;
        },
      );
}
