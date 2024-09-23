import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sap/provider/client.dart';

import '../helper/screen_navigation.dart';
import '../widget/custom_text.dart';
import 'client_profile.dart';
import 'home.dart';

class SearchClientScreen extends StatefulWidget {
  final String name;
  SearchClientScreen({Key? key, required this.name}) : super(key: key);

  @override
  State<SearchClientScreen> createState() => _SearchClientScreenState();
}

class _SearchClientScreenState extends State<SearchClientScreen> {
  ScrollController scollBarController = ScrollController();
  final columns = [
    'Name Ar',
    'Name En',
    'Email',
    'Phone',
    'Pic',
    'Clearance Name',
    'Clearance Code',
    'Location',
    'Tax',
    'Fax',
  ];

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<ClientProvider>(context);
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
                      columns: columns
                          .map(
                            (e) => DataColumn2(
                              label: Expanded(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  e,
                                  style: TextStyle(
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                              size: ColumnSize.L,
                            ),
                          )
                          .toList(),
                      rows: List<DataRow>.generate(
                        client.searchClient.length,
                        (index) => DataRow(
                          cells: [
                            DataCell(
                              GestureDetector(
                                onTap: () async {
                                  await client.getClient(
                                      client.searchClient[index].id!);
                                  changeScreen(
                                    context,
                                    ClientProfile(
                                      clientName:
                                          client.searchClient[index].nameAr!,
                                      name: widget.name,
                                      id: client.searchClient[index].id!,
                                      clientEng:
                                          client.searchClient[index].nameEn!,
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 200,
                                  child: Center(
                                    child: CustomText(
                                      text: client.searchClient[index].nameAr!,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              GestureDetector(
                                onTap: () async {
                                  await client.getClient(
                                      client.searchClient[index].id!);
                                  changeScreen(
                                    context,
                                    ClientProfile(
                                      clientName:
                                          client.searchClient[index].nameAr!,
                                      name: widget.name,
                                      id: client.searchClient[index].id!,
                                      clientEng:
                                          client.searchClient[index].nameEn!,
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 200,
                                  child: Center(
                                    child: CustomText(
                                      text: client.searchClient[index].nameEn!,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              GestureDetector(
                                onTap: () async {
                                  await client.getClient(
                                      client.searchClient[index].id!);
                                  changeScreen(
                                    context,
                                    ClientProfile(
                                      clientName:
                                          client.searchClient[index].nameAr!,
                                      name: widget.name,
                                      id: client.searchClient[index].id!,
                                      clientEng:
                                          client.searchClient[index].nameEn!,
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 200,
                                  child: Center(
                                    child: CustomText(
                                      text: client.searchClient[index].email!,
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
                                    text: client.searchClient[index].phone!,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                width: 200,
                                child: Center(
                                  child: CustomText(
                                    text: client.searchClient[index].pic!,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                width: 200,
                                child: Center(
                                  child: CustomText(
                                    text: client
                                        .searchClient[index].clearanceName!,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                width: 200,
                                child: Center(
                                  child: CustomText(
                                    text: client
                                        .searchClient[index].clearanceCode!,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                width: 200,
                                child: Center(
                                  child: CustomText(
                                    text: client.searchClient[index].location!,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                width: 200,
                                child: Center(
                                  child: CustomText(
                                    text: client.searchClient[index].taxId!,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                width: 200,
                                child: Center(
                                  child: CustomText(
                                    text: client.searchClient[index].fax!,
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
}
