import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sap/provider/shipment.dart';
import '../helper/screen_navigation.dart';
import '../provider/agent.dart';
import '../widget/custom_text.dart';
import 'agent_profile.dart';
import 'home.dart';

class SearchAgentScreen extends StatefulWidget {
  final String name;
  SearchAgentScreen({Key? key, required this.name}) : super(key: key);

  @override
  State<SearchAgentScreen> createState() => _SearchAgentScreenState();
}

class _SearchAgentScreenState extends State<SearchAgentScreen> {
  ScrollController scollBarController = ScrollController();
  final columns = [
    "Name",
    "Address",
    'Tel',
    'Fax',
    'Phone',
    'Email',
    'Operation Email',
    'Operation Pic Name',
    'Financial Email',
    'Financial Pic Name',
    'Agent Code',
  ];

  @override
  Widget build(BuildContext context) {
    final agent = Provider.of<AgentProvider>(context);
    final shipment = Provider.of<ShipmentProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              changeScreenReplacement(context, HomeScreen());
            },
            icon: Icon(
              Icons.home,
            ),
          ),
        ],
      ),
      body: Scrollbar(
        thumbVisibility: true,
        scrollbarOrientation: ScrollbarOrientation.top,
        controller: scollBarController,
        child: SingleChildScrollView(
          controller: scollBarController,
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: Card(
                    elevation: 10,
                    color: Colors.transparent,
                    child: DataTable(
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      dataTextStyle: TextStyle(
                        color: Colors.orange,
                      ),
                      showBottomBorder: true,
                      headingRowColor: WidgetStateProperty.all<Color>(
                        Color.fromRGBO(0, 0, 0, 0),
                      ),
                      dataRowColor: WidgetStateProperty.all<Color>(
                        Color.fromRGBO(0, 0, 0, 0),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      sortAscending: false,
                      columns: getColumns(columns),
                      rows: List<DataRow>.generate(
                        agent.agents.length,
                        (index) => DataRow(
                          cells: [
                            DataCell(
                              GestureDetector(
                                onTap: () async {
                                  await shipment
                                      .getShipmentAgent(agent.agents[index].id);
                                  changeScreen(
                                      context,
                                      AgentProfileScreen(
                                        name: widget.name,
                                      ));
                                },
                                child: Container(
                                  width: 200,
                                  child: Center(
                                    child: CustomText(
                                      text: agent.agents[index].agentName,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              GestureDetector(
                                onTap: () async {
                                  await shipment
                                      .getShipmentAgent(agent.agents[index].id);
                                  changeScreen(
                                      context,
                                      AgentProfileScreen(
                                        name: widget.name,
                                      ));
                                },
                                child: Container(
                                  width: 200,
                                  child: Center(
                                    child: CustomText(
                                      text: agent.agents[index].agentAddress,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              GestureDetector(
                                onTap: () async {
                                  await shipment
                                      .getShipmentAgent(agent.agents[index].id);
                                  changeScreen(
                                      context,
                                      AgentProfileScreen(
                                        name: widget.name,
                                      ));
                                },
                                child: Container(
                                  width: 200,
                                  child: Center(
                                    child: CustomText(
                                      text: agent.agents[index].agentTel,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                width: 200,
                                child: Center(
                                  child: CustomText(
                                    text: agent.agents[index].agentFax,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                width: 200,
                                child: Center(
                                  child: CustomText(
                                    text: agent.agents[index].agentPhone,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                width: 200,
                                child: Center(
                                  child: CustomText(
                                    text: agent.agents[index].agentEmail,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                width: 200,
                                child: Center(
                                  child: CustomText(
                                    text:
                                        agent.agents[index].agentOperationEmail,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                width: 200,
                                child: Center(
                                  child: CustomText(
                                    text: agent
                                        .agents[index].agentOperationPicName,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                width: 200,
                                child: Center(
                                  child: CustomText(
                                    text:
                                        agent.agents[index].agentFinancialEmail,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                width: 200,
                                child: Center(
                                  child: CustomText(
                                    text: agent
                                        .agents[index].agentFinancialPicName,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                width: 200,
                                child: Center(
                                  child: CustomText(
                                    text: agent.agents[index].agentCode,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map(
        (String column) => DataColumn(
          label: Expanded(
            child: Text(
              textAlign: TextAlign.center,
              column,
              style: TextStyle(
                color: Colors.orange,
              ),
            ),
          ),
        ),
      )
      .toList();
}
