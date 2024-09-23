import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sap/provider/invoice.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../helper/screen_navigation.dart';
import '../style/custom_text.dart';
import '../widget/divider.dart';
import 'home.dart';

class SearchInvoiceScreen extends StatefulWidget {
  SearchInvoiceScreen({Key? key}) : super(key: key);

  @override
  State<SearchInvoiceScreen> createState() => _SearchInvoiceScreenState();
}

class _SearchInvoiceScreenState extends State<SearchInvoiceScreen> {
  final columns = [
    "MBL",
    "HBL",
    "Agent",
    'File Number',
  ];
  @override
  Widget build(BuildContext context) {
    final invoice = Provider.of<InvoiceProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice Shipment"),
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
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(10),
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
                            label: Center(
                              child: Text(
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
                      invoice.agentInvoice.length,
                      (index) => DataRow(
                        cells: [
                          DataCell(
                            Center(
                              child: CustomText(
                                text: invoice.agentInvoice[index].mbl!,
                              ),
                            ),
                          ),
                          DataCell(
                            invoice.agentInvoice[index].hbl.length > 1
                                ? Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(
                                              builder: (BuildContext context,
                                                  setState) {
                                                return Dialog(
                                                  child: Container(
                                                    width: 680,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      child: Card(
                                                        elevation: 10,
                                                        shadowColor:
                                                            Colors.black,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                          .grey[
                                                                      400],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              3.0),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .symmetric(
                                                                      vertical:
                                                                          8.0,
                                                                      horizontal:
                                                                          16.0,
                                                                    ),
                                                                    child: ListView
                                                                        .separated(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              0),
                                                                      separatorBuilder:
                                                                          (BuildContext context, int index) =>
                                                                              DividerWidget(),
                                                                      itemCount: invoice
                                                                          .agentInvoice[
                                                                              index]
                                                                          .hbl
                                                                          .length,
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          ClampingScrollPhysics(),
                                                                      itemBuilder:
                                                                          (context,
                                                                              index1) {
                                                                        return HblViewWidget1(
                                                                          hbl: invoice
                                                                              .agentInvoice[index]
                                                                              .hbl[index1],
                                                                        );
                                                                      },
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
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                      child: Icon(
                                        Icons.remove_red_eye_rounded,
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: CustomText(
                                      text: invoice.agentInvoice[index].hbl[0],
                                    ),
                                  ),
                          ),
                          DataCell(
                            GestureDetector(
                              onTap: () {
                                final x = invoice.agentInvoice[index].agent;
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                      builder:
                                          (BuildContext context, setState) {
                                        return Dialog(
                                          child: Container(
                                            width: 680,
                                            child: Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Card(
                                                elevation: 10,
                                                shadowColor: Colors.black,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[400],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  3.0),
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              vertical: 8.0,
                                                              horizontal: 16.0,
                                                            ),
                                                            child: ListView
                                                                .separated(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(0),
                                                              separatorBuilder:
                                                                  (BuildContext
                                                                              context,
                                                                          int index) =>
                                                                      DividerWidget(),
                                                              itemCount:
                                                                  x.length,
                                                              shrinkWrap: true,
                                                              physics:
                                                                  ClampingScrollPhysics(),
                                                              itemBuilder:
                                                                  (context,
                                                                      index1) {
                                                                return HblViewWidget(
                                                                  hbl:
                                                                      x[index1],
                                                                );
                                                              },
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
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              child: Center(
                                child: Icon(
                                  Icons.remove_red_eye_rounded,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Center(
                              child: CustomText(
                                text: invoice.agentInvoice[index].fileNumber!,
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
    );
  }
}

class HblViewWidget1 extends StatelessWidget {
  final dynamic hbl;
  const HblViewWidget1({Key? key, this.hbl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 200,
        child: Center(
          child: Card(
            elevation: 10,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(hbl),
            ),
          ),
        ),
      ),
    );
  }
}

class HblViewWidget extends StatelessWidget {
  final dynamic hbl;
  const HblViewWidget({Key? key, this.hbl}) : super(key: key);

  _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: 200,
            child: Center(
              child: Card(
                elevation: 10,
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(hbl["invoicesNo"]),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: 200,
            child: Center(
              child: Card(
                elevation: 10,
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(hbl["value"]),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: 200,
            child: Center(
              child: Card(
                elevation: 10,
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(hbl["currency"]),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        ElevatedButton(
          onPressed: () async {
            await _launchURL(
              hbl["url"],
            );
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            shadowColor: Colors.black,
            elevation: 3,
            backgroundColor: Colors.orange,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text("Download"),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
