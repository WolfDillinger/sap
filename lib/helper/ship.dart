import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import '../model/port.dart';

class ShipServices {
  Future<List<PortModel>> portsInfo() async {
    final langFile =
        await rootBundle.rootBundle.loadString('assets/ports.json');

    Map<String, dynamic> list = jsonDecode(langFile);

    List<PortModel> ports = [];
    for (Map<String, dynamic> port in list.values.toList()) {
      ports.add(PortModel.fromJson(port));
    }
    return ports;
  }
}
