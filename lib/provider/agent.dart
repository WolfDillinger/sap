import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';
import '../helper/agent.dart';
import '../model/agent.dart';

enum SearchBy {
  NAME,
  EMAIL,
  PHONE,
  ADDRESS,
  FAX,
  TEL,
  OPERATIONEMAIL,
  OPERATIONPICNAME,
  FINANCIALEMAIL,
  FINANCIALPICNAME,
  AGENTCODE,
}

class AgentProvider with ChangeNotifier {
  AgentServices _agentServices = AgentServices();
  List<AgentModel> agents = [];
  List<AgentModel> searchAgents = [];
  AgentModel? agentProfile;
  SearchBy search = SearchBy.NAME;
  bool check = false;
  String filterBy = "Name";
  AgentProvider() {
    notifyListeners();
  }

  dynamic getAgent(String id) async {
    agentProfile = await _agentServices.getAgentById(id);
  }

  dynamic checkEmail(String email) async {
    check = await _agentServices.checkEmail(email);
  }

  dynamic updateAgent(String name, String code, String address, String email,
      String fax, String phone) async {
    await _agentServices.updateAgent(
        name, code, address, email, fax, phone, agentProfile!.id);
  }

  Future searchHome(String data) async {
    searchAgents = await _agentServices.search(data, filterBy);
    if (searchAgents.isNotEmpty) {
      return true;
    } else
      return false;
  }

  dynamic addAgent(
    String name,
    String agentAddress,
    String agentEmail,
    String agentFax,
    String agentFinancialEmail,
    String agentFinancialPicName,
    String agentName,
    String agentOperationEmail,
    String agentOperationPicName,
    String agentPhone,
    String agentTel,
    String agentCode,
  ) async {
    var uuid = Uuid().v4();
    await _agentServices.addAgent(
      name,
      agentAddress,
      agentEmail,
      agentFax,
      agentFinancialEmail,
      agentFinancialPicName,
      agentName,
      agentOperationEmail,
      agentOperationPicName,
      agentPhone,
      agentTel,
      agentCode,
      uuid,
    );
  }

  void changeSearchBy({SearchBy? newSearchBy}) {
    search = newSearchBy!;
    if (newSearchBy == SearchBy.NAME) {
      filterBy = "Name";
    } else if (newSearchBy == SearchBy.EMAIL) {
      filterBy = "Email";
    } else if (newSearchBy == SearchBy.ADDRESS) {
      filterBy = "Address";
    } else if (newSearchBy == SearchBy.PHONE) {
      filterBy = "Phone";
    } else if (newSearchBy == SearchBy.FAX) {
      filterBy = "Fax";
    } else if (newSearchBy == SearchBy.TEL) {
      filterBy = "Tel";
    } else if (newSearchBy == SearchBy.OPERATIONEMAIL) {
      filterBy = "Operation Email";
    } else if (newSearchBy == SearchBy.OPERATIONPICNAME) {
      filterBy = "Operation Pic Name";
    } else if (newSearchBy == SearchBy.FINANCIALEMAIL) {
      filterBy = "Financial Email";
    } else if (newSearchBy == SearchBy.FINANCIALPICNAME) {
      filterBy = "Financial Pic Name";
    } else if (newSearchBy == SearchBy.AGENTCODE) {
      filterBy = "Agent Code";
    }
    notifyListeners();
  }
}
