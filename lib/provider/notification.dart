import 'package:flutter/widgets.dart';

import '../services/notification.dart';
import '../model/notification.dart';

class NotificationProvider with ChangeNotifier {
  NotificationServices _notificationServices = NotificationServices();
  List<NotificationModel> notifications = [];
  NotificationProvider() {
    load();
    notifyListeners();
  }
  Future load() async {
    notifications = await _notificationServices.getNotifications();
  }
}
