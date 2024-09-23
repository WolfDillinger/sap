import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/agent.dart';

class AgentServices {
  String collection = "agents";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<AgentModel> getAgentById(String id) async =>
      await _firestore.collection(collection).doc(id).get().then(
        (result) {
          return AgentModel.fromSnapshot(result);
        },
      );

  Future<void> updateAgent(String name, String code, String address,
      String email, String fax, String phone, String uuid) async {
    await _firestore.collection(collection).doc(uuid).update({
      "agentAddress": address,
      "agentEmail": email,
      "agentFax": fax,
      "agentName": name,
      "agentCode": code,
      "agentPhone": phone,
    });
  }

  Future<bool> checkEmail(String id) async => await _firestore
          .collection(collection)
          .where('email', isEqualTo: id)
          .get()
          .then(
        (value) {
          List<AgentModel> agents = [];
          for (DocumentSnapshot agent in value.docs) {
            agents.add(AgentModel.fromSnapshot(agent));
          }
          if (agents.length > 0) {
            return false;
          } else
            return true;
        },
      );

  Future<void> addAgent(
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
    String uuid,
  ) async {
    await _firestore.collection(collection).doc(uuid).set({
      'name': name,
      "agentAddress": agentAddress,
      "agentEmail": agentEmail,
      "agentFax": agentFax,
      "agentFinancialEmail": agentFinancialEmail,
      "agentFinancialPicName": agentFinancialPicName,
      "agentCode": agentCode,
      "id": uuid,
      "agentName": agentName,
      "agentOperationEmail": agentOperationEmail,
      "agentOperationPicName": agentOperationPicName,
      "agentPhone": agentPhone,
      "agentTel": agentTel,
    });
  }

  Future<List<AgentModel>> search(String info, String kind) async =>
      await _firestore.collection(collection).get().then((result) {
        List<AgentModel> search = [];
        List<AgentModel> agents = [];
        for (DocumentSnapshot agent in result.docs) {
          agents.add(AgentModel.fromSnapshot(agent));
        }

        switch (kind) {
          case 'Name':
            {
              agents.forEach((element) {
                if (element.agentName
                    .toUpperCase()
                    .contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'Email':
            {
              agents.forEach((element) {
                if (element.agentEmail
                    .toUpperCase()
                    .contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'Address':
            {
              agents.forEach((element) {
                if (element.agentAddress
                    .toUpperCase()
                    .contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'Phone':
            {
              agents.forEach((element) {
                if (element.agentPhone
                    .toUpperCase()
                    .contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'Fax':
            {
              agents.forEach((element) {
                if (element.agentFax
                    .toUpperCase()
                    .contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'Tel':
            {
              agents.forEach((element) {
                if (element.agentTel
                    .toUpperCase()
                    .contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'Operation Email':
            {
              agents.forEach((element) {
                if (element.agentOperationEmail
                    .toUpperCase()
                    .contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'Operation Pic Name':
            {
              agents.forEach((element) {
                if (element.agentOperationPicName
                    .toUpperCase()
                    .contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'Financial Email':
            {
              agents.forEach((element) {
                if (element.agentFinancialEmail
                    .toUpperCase()
                    .contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
          case 'Financial Pic Name':
            {
              agents.forEach((element) {
                if (element.agentFinancialPicName
                    .toUpperCase()
                    .contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }

          case 'Agent Code':
            {
              agents.forEach((element) {
                if (element.agentCode
                    .toUpperCase()
                    .contains(info.toUpperCase())) {
                  search.add(element);
                }
              });
              break;
            }
        }

        return search;
      });
}
