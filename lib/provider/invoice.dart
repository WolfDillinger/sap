import 'package:flutter/cupertino.dart';
import 'package:sap/helper/invoice.dart';
import 'package:sap/model/invoice.dart';
import 'package:uuid/uuid.dart';

class InvoiceProvider with ChangeNotifier {
  InvoiceServices _invoiceServices = InvoiceServices();
  List<InvoiceModel> invoices = [];
  List<InvoiceModel> agentInvoice = [];
  bool check = false;

  InvoiceProvider() {
    notifyListeners();
  }
  dynamic getUserInvoice(String id) async {
    invoices = await _invoiceServices.getInoices(id);
  }

  dynamic checkMbl(String mbl) async {
    check = await _invoiceServices.checkMbl(mbl);
  }

  dynamic addInvoice(
    String name,
    String mbl,
    dynamic hbl,
    dynamic agentData,
    dynamic sabData,
    dynamic shipData,
    String fileNumber,
    String uid,
  ) async {
    var uuid = Uuid().v4();
    await _invoiceServices.addInvoice(
        name, mbl, hbl, agentData, sabData, shipData, fileNumber, uid, uuid);
  }

  dynamic getAgentInvoice(String id) async {
    agentInvoice = await _invoiceServices.getAgentInvoice(id);
  }
}
