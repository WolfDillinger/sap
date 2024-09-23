import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sap/provider/agent.dart';

import '../provider/monitoring.dart';

class AgentHomeScreen extends StatefulWidget {
  final String name;
  AgentHomeScreen({Key? key, required this.name}) : super(key: key);

  @override
  State<AgentHomeScreen> createState() => _AgentHomeScreenState();
}

class _AgentHomeScreenState extends State<AgentHomeScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController code = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController fax = TextEditingController();
  TextEditingController phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final agent = Provider.of<AgentProvider>(context);
    final monitoring = Provider.of<MonitoringProvider>(context);
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 980),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                    shadowColor: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: name,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: agent.agentProfile?.agentName,
                          icon: Icon(
                            Icons.person,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                    shadowColor: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: code,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: agent.agentProfile?.agentCode,
                          icon: Icon(
                            Icons.code_rounded,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                    shadowColor: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: address,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: agent.agentProfile?.agentAddress,
                          icon: Icon(
                            Icons.location_on,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                    shadowColor: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: email,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: agent.agentProfile?.agentEmail,
                          icon: Icon(
                            Icons.email,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                    shadowColor: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: fax,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: agent.agentProfile?.agentFax,
                          icon: Icon(
                            Icons.fax,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                    shadowColor: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: phone,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: agent.agentProfile?.agentPhone,
                          icon: Icon(
                            Icons.phone_android_rounded,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 150),
                  child: ElevatedButton(
                    onPressed: () async {
                      await monitoring.addMonitoring(
                        widget.name,
                        "Agent ${name.text} and His Email ${email.text}",
                        "Edit Agent Profile",
                        DateTime.now(),
                      );
                      await agent.updateAgent(name.text, code.text,
                          address.text, email.text, fax.text, phone.text);
                      Fluttertoast.showToast(msg: "Updated");
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.orange[700],
                      elevation: 3,
                    ),
                    child: Center(
                      child: Text("Update"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
