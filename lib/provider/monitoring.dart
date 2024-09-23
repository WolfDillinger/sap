import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../services/monitoring.dart';

class MonitoringProvider with ChangeNotifier {
  MonitoringServices _monitoringServices = MonitoringServices();
  MonitoringProvider() {
    notifyListeners();
  }

  addMonitoring(
      String name, String information, String action, DateTime time) async {
    var uuid = Uuid().v4();
    await _monitoringServices.addMonitoring(
        name, information, action, time, uuid);
  }
}
