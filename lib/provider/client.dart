import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../services/client.dart';
import '../model/client.dart';

enum SearchBy { AR, EN, EMAIL, PHONE, PIC, NAME, CODE, LOCATION, TAX, FAX }

class ClientProvider with ChangeNotifier {
  List<ClientModel> clients = [];
  List<ClientModel> vips = [];
  List<ClientModel> searchClient = [];
  ClientServices _clientServices = ClientServices();
  SearchBy search = SearchBy.AR;
  String filterBy = "Name";
  ClientModel? clientProfile;
  bool check = false;

  Future<void> addNewClient(
    String by,
    String ar,
    String en,
    String phone,
    String location,
    String taxId,
    String email,
    String pic,
    String name,
    String code,
    String fax,
    String tel,
  ) async {
    var uuid = Uuid().v4();
    await _clientServices.addNewClient(by, en, ar, phone, location, taxId,
        email, pic, name, code, fax, uuid, tel);
  }

  dynamic checkEmail(String email) async {
    check = await _clientServices.checkEmail(email);
  }

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
  ) async {
    await _clientServices.updateClient(
        en, ar, email, phone, tel, fax, name, code, location, pic, taxId, id);
  }

  ClientProvider() {
    notifyListeners();
  }

  Future<void> getClient(String id) async {
    clientProfile = await _clientServices.getClient(id);
  }

  Future<void> updateView(String id) async {
    await _clientServices.updateView(id);
  }

  Future<void> delete(String id) async {
    await _clientServices.deleteClient(id);
  }

  updateVip(String? id, bool vip) async {
    await _clientServices.updateVip(id, vip);
  }

  Future searchHome(String data) async {
    searchClient = await _clientServices.search(data, filterBy);

    if (searchClient.isNotEmpty) {
      return true;
    } else
      return false;
  }

  void changeSearchBy({SearchBy? newSearchBy}) {
    search = newSearchBy!;
    if (newSearchBy == SearchBy.NAME) {
      filterBy = "clearanceName";
    } else if (newSearchBy == SearchBy.EMAIL) {
      filterBy = "email";
    } else if (newSearchBy == SearchBy.PHONE) {
      filterBy = "phone";
    } else if (newSearchBy == SearchBy.CODE) {
      filterBy = "clearanceCode";
    } else if (newSearchBy == SearchBy.AR) {
      filterBy = "nameAr";
    } else if (newSearchBy == SearchBy.EN) {
      filterBy = "nameEn";
    } else if (newSearchBy == SearchBy.FAX) {
      filterBy = "fax";
    } else if (newSearchBy == SearchBy.TAX) {
      filterBy = "tax";
    } else if (newSearchBy == SearchBy.PIC) {
      filterBy = "pic";
    } else {
      filterBy = "location";
    }
    notifyListeners();
  }
}
