import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

import '../services/clearance.dart';
import '../model/clearance.dart';

enum SearchBy { NAME, EMAIL, PHONE, CODE, PIC, FAX, TEL, ADDRESS }

class ClearanceProvider with ChangeNotifier {
  ClearanceServices _clearanceServices = ClearanceServices();
  List<ClearanceModel> clearances = [];
  List<ClearanceModel> searchClearances = [];
  ClearanceModel? clearanceProfile;
  SearchBy search = SearchBy.NAME;
  bool check = false;
  String filterBy = "Name";
  ClearanceProvider() {
    notifyListeners();
  }
  dynamic checkEmail(String email) async {
    check = await _clearanceServices.checkEmail(email);
  }

  Future searchHome(String data) async {
    searchClearances = await _clearanceServices.search(data, filterBy);
    if (searchClearances.isNotEmpty) {
      return true;
    } else
      return false;
  }

  dynamic addClearance(
    String by,
    String name,
    String address,
    String fax,
    String tel,
    String phone,
    String email,
    String code,
    String pic,
  ) async {
    var uuid = Uuid().v4();
    await _clearanceServices.addNewClearance(
        by, name, address, fax, tel, phone, email, code, pic, uuid);
  }

  dynamic editClearance(
    String by,
    String name,
    String address,
    String fax,
    String tel,
    String phone,
    String email,
    String code,
    String pic,
  ) async {
    var uuid = Uuid().v4();
    await _clearanceServices.editClearance(
        by, name, address, fax, tel, phone, email, code, pic, uuid);
  }

  dynamic getClearance(String id) async {
    clearanceProfile = await _clearanceServices.getClearanceById(id);
  }

  void changeSearchBy({SearchBy? newSearchBy}) {
    search = newSearchBy!;
    if (newSearchBy == SearchBy.NAME) {
      filterBy = "Name";
    } else if (newSearchBy == SearchBy.EMAIL) {
      filterBy = "Email";
    } else if (newSearchBy == SearchBy.PHONE) {
      filterBy = "Phone";
    } else if (newSearchBy == SearchBy.CODE) {
      filterBy = "Code";
    } else if (newSearchBy == SearchBy.FAX) {
      filterBy = "Fax";
    } else if (newSearchBy == SearchBy.TEL) {
      filterBy = "Tel";
    } else if (newSearchBy == SearchBy.ADDRESS) {
      filterBy = "Address";
    } else {
      filterBy = "Pic";
    }
    notifyListeners();
  }
}
