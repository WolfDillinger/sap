import 'package:flutter/cupertino.dart';
import 'package:sap/model/shipment.dart';
import 'package:uuid/uuid.dart';
import '../services/shipment.dart';

enum SearchByShipment {
  MBL,
  HBL,
  PHONE,
  CONTAINERNYMBER,
  VOLUME,
  POL,
  POD,
  SHIPINGLINE,
  AGENTNAME,
}

class ShipmentProvider with ChangeNotifier {
  ShipmentServices _shipmentServices = ShipmentServices();
  List<ShipmentModel> shipments = [];
  List<ShipmentModel> shipmentsAgent = [];
  List<ShipmentModel> searchShipment = [];
  SearchByShipment search = SearchByShipment.MBL;
  String filterBy = "Name";
  bool check = false;

  ShipmentProvider() {
    notifyListeners();
  }

  dynamic getShipment(String id) async {
    shipments = await _shipmentServices.getShipments(id);
  }

  Future<void> delete(String id) async {
    await _shipmentServices.deleteShipment(id);
  }

  Future<void> updatePol(String pol, String id) async {
    await _shipmentServices.updatePol(pol, id);
  }

  Future<void> updateHbl(dynamic hbl, String url, String id) async {
    await _shipmentServices.updateHbl(hbl, url, id);
  }

  Future<void> updateAgentCode(String code, String id) async {
    await _shipmentServices.updateAgentCode(code, id);
  }

  Future<void> updateAgentName(String name, String id) async {
    await _shipmentServices.updateAgentName(name, id);
  }

  Future<void> updatePod(String pod, String id) async {
    await _shipmentServices.updatePod(pod, id);
  }

  Future<void> updateMbl(String mbl, String id) async {
    await _shipmentServices.updateMbl(mbl, id);
  }

  dynamic checkMbl(String mbl) async {
    check = await _shipmentServices.checkMbl(mbl);
  }

  Future<void> updateSealine(String shipingLine, String id) async {
    await _shipmentServices.updateSealine(shipingLine, id);
  }

  Future<void> updateComment(String comment, String id) async {
    await _shipmentServices.updateComment(comment, id);
  }

  dynamic addShipment(
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
  ) async {
    var uuid = Uuid().v4();

    await _shipmentServices.addShipment(
      name,
      hblInfo,
      sizeInfo,
      volInfo,
      conInfo,
      pol,
      pod,
      mbl,
      agentName,
      agentCode,
      mblUrl,
      hblUrl,
      loading,
      arrival,
      comment,
      sealine,
      uid,
      uuid,
    );
  }

  dynamic getShipmentAgent(String id) async {
    shipmentsAgent = await _shipmentServices.getShipmentsAgent(id);
  }

  Future searchHome(String data) async {
    searchShipment = await _shipmentServices.search(data, filterBy);
    if (searchShipment.isNotEmpty) {
      return true;
    } else
      return false;
  }

  void changeSearchBy({SearchByShipment? newSearchBy}) {
    search = newSearchBy!;
    if (newSearchBy == SearchByShipment.MBL) {
      filterBy = "MBL";
    } else if (newSearchBy == SearchByShipment.HBL) {
      filterBy = "HBL";
    } else if (newSearchBy == SearchByShipment.CONTAINERNYMBER) {
      filterBy = 'Container Number';
    } else if (newSearchBy == SearchByShipment.VOLUME) {
      filterBy = 'Volume';
    } else if (newSearchBy == SearchByShipment.POL) {
      filterBy = 'POL';
    } else if (newSearchBy == SearchByShipment.POD) {
      filterBy = 'POD';
    } else if (newSearchBy == SearchByShipment.SHIPINGLINE) {
      filterBy = 'Shiping Line';
    } else if (newSearchBy == SearchByShipment.AGENTNAME) {
      filterBy = 'Agent Name';
    }
    notifyListeners();
  }
}
