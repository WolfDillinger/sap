import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sap/provider/app.dart';

import '../helper/screen_navigation.dart';
import '../style/custom_text.dart';
import 'home.dart';

class MonitoringScreen extends StatefulWidget {
  MonitoringScreen({Key? key}) : super(key: key);

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  final columns = [
    'Name',
    "Date",
    "Action",
    'Information',
  ];
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Monitoring"),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("monitoring")
                    .orderBy(
                      "time",
                      descending: true,
                    )
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return SpinKitRotatingCircle(
                      color: Colors.black,
                      size: 50.0,
                    );
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return SpinKitRotatingCircle(
                        color: Colors.black,
                        size: 50.0,
                      );
                    default:
                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Center(
                            child: Container(
                              child: Card(
                                elevation: 10,
                                color: Colors.transparent,
                                child: DataTable(
                                  dataTextStyle: TextStyle(
                                    color: Colors.orange,
                                  ),
                                  showBottomBorder: true,
                                  headingRowColor:
                                      WidgetStateProperty.all<Color>(
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
                                    snapshot.data!.docs.length,
                                    (index) => DataRow(
                                      cells: [
                                        DataCell(
                                          Container(
                                            width: 150,
                                            child: Center(
                                              child: CustomText(
                                                text: snapshot.data!.docs[index]
                                                    .get("name"),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Container(
                                            width: 150,
                                            child: Center(
                                              child: CustomText(
                                                text: app.formatted(
                                                  snapshot.data!.docs[index]
                                                      .get("time"),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Container(
                                            width: 100,
                                            child: Center(
                                              child: CustomText(
                                                text: snapshot.data!.docs[index]
                                                    .get("action"),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Container(
                                            width: 250,
                                            child: Center(
                                              child: CustomText(
                                                text: snapshot.data!.docs[index]
                                                    .get("information"),
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
                      );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
