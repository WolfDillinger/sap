import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import '../services/ship.dart';
import '../model/port.dart';
import '../model/sealine.dart';

class ShipProvider with ChangeNotifier {
  List<PortModel>? ports = [];
  List<SealineModel>? sealines = [];
  ShipServices _shipServices = ShipServices();
  TextEditingController pol = TextEditingController();

  ShipProvider() {
    getSealine();
    getPortsInfo();
    notifyListeners();
  }

  Future<void> getPortsInfo() async {
    ports = await _shipServices.portsInfo();
  }

  Future<void> getSealine() async {
    final langFile =
        await rootBundle.rootBundle.loadString('assets/sealine.json');

    Map<String, dynamic> list = jsonDecode(langFile);

    for (Map<String, dynamic> sealine in list["data"]) {
      sealines!.add(SealineModel.fromJson(sealine));
    }
  }
}
