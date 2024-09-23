import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sap/helper/screen_navigation.dart';
import 'package:sap/provider/invoice.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../provider/shipment.dart';
import '../screen/search_invoice.dart';
import '../style/custom_text.dart';
import 'divider.dart';

class AgentShipmentWidget extends StatefulWidget {
  AgentShipmentWidget({Key? key}) : super(key: key);

  @override
  State<AgentShipmentWidget> createState() => _AgentShipmentWidgetState();
}

class _AgentShipmentWidgetState extends State<AgentShipmentWidget> {
  ScrollController scollBarController = ScrollController();
  final columns = [
    'Invoice',
    "MBL",
    "HBL",
    'Container',
    'size',
    'Volume',
    'POL',
    'POD',
    'Comment',
    'Shiping Line',
    'Agent Name',
    'Loading',
    'Arrival',
  ];
  @override
  Widget build(BuildContext context) {
    final shipment = Provider.of<ShipmentProvider>(context);
    final invoice = Provider.of<InvoiceProvider>(context);
    return Scrollbar(
      thumbVisibility: true,
      scrollbarOrientation: ScrollbarOrientation.top,
      controller: scollBarController,
      child: SingleChildScrollView(
        controller: scollBarController,
        scrollDirection: Axis.horizontal,
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
                    ),
                  )
                  .toList(),
              rows: List<DataRow>.generate(
                shipment.shipmentsAgent.length,
                (index) => DataRow(
                  cells: [
                    DataCell(
                      GestureDetector(
                        onTap: () async {
                          await invoice.getAgentInvoice(
                              shipment.shipmentsAgent[index].id);
                          changeScreen(
                            context,
                            SearchInvoiceScreen(),
                          );
                        },
                        child: Center(
                          child: Icon(
                            Icons.remove_red_eye_rounded,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        width: 200,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: CustomText(
                                  text: shipment.shipmentsAgent[index].mbl
                                      .toString(),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              GestureDetector(
                                onTap: () {
                                  final x = shipment.shipmentsAgent[index].mbl;
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (BuildContext context,
                                            setState123) {
                                          return Dialog(
                                            child: Container(
                                              width: 680,
                                              child: SingleChildScrollView(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: Card(
                                                    elevation: 10,
                                                    shadowColor: Colors.black,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Card(
                                                            elevation: 10,
                                                            shadowColor:
                                                                Colors.black,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          3),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Center(
                                                                child: Text(
                                                                  x,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 15,
                                                          ),
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              await _launchURL(
                                                                shipment
                                                                    .shipmentsAgent[
                                                                        index]
                                                                    .file,
                                                              );
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              foregroundColor:
                                                                  Colors.black,
                                                              shadowColor:
                                                                  Colors.black,
                                                              elevation: 3,
                                                              backgroundColor:
                                                                  Colors.orange,
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Center(
                                                                child: Text(
                                                                    "Download"),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        width: 50,
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              final x = shipment.shipmentsAgent[index].hbl;

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context, setState) {
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
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[400],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(3.0),
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            vertical: 8.0,
                                                            horizontal: 16.0,
                                                          ),
                                                          child: ListView
                                                              .separated(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            separatorBuilder: (BuildContext
                                                                        context,
                                                                    int index) =>
                                                                DividerWidget(),
                                                            itemCount:
                                                                x["number"]
                                                                    .length,
                                                            shrinkWrap: true,
                                                            physics:
                                                                ClampingScrollPhysics(),
                                                            itemBuilder:
                                                                (context,
                                                                    index1) {
                                                              return HblViewWidget(
                                                                hbl: x["number"]
                                                                    [index1],
                                                              );
                                                            },
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
                                                          x["file"],
                                                        );
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        foregroundColor:
                                                            Colors.black,
                                                        shadowColor:
                                                            Colors.black,
                                                        elevation: 3,
                                                        backgroundColor:
                                                            Colors.orange,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Center(
                                                          child:
                                                              Text("Download"),
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
                            icon: Icon(
                              Icons.arrow_upward_rounded,
                            ),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      shipment.shipmentsAgent[index].container.length > 1
                          ? Container(
                              width: 50,
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    final x = shipment
                                        .shipmentsAgent[index].container;
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
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: Card(
                                                    elevation: 10,
                                                    shadowColor: Colors.black,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .grey[400],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(3.0),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                  vertical: 8.0,
                                                                  horizontal:
                                                                      16.0,
                                                                ),
                                                                child: ListView
                                                                    .separated(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  separatorBuilder:
                                                                      (BuildContext context,
                                                                              int index) =>
                                                                          DividerWidget(),
                                                                  itemCount:
                                                                      x.length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  physics:
                                                                      ClampingScrollPhysics(),
                                                                  itemBuilder:
                                                                      (context,
                                                                          index1) {
                                                                    return HblViewWidget(
                                                                      hbl: x[
                                                                          index1],
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 15,
                                                          ),
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              await _launchURL(
                                                                x["file"],
                                                              );
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              foregroundColor:
                                                                  Colors.black,
                                                              shadowColor:
                                                                  Colors.black,
                                                              elevation: 3,
                                                              backgroundColor:
                                                                  Colors.orange,
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Center(
                                                                child: Text(
                                                                    "Download"),
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
                                  icon: Icon(
                                    Icons.arrow_upward_rounded,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              width: 100,
                              child: Center(
                                child: CustomText(
                                  text: shipment
                                      .shipmentsAgent[index].container[0],
                                ),
                              ),
                            ),
                    ),
                    DataCell(
                      shipment.shipmentsAgent[index].size.length > 1
                          ? Container(
                              width: 50,
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    final x =
                                        shipment.shipmentsAgent[index].size;
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
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: Card(
                                                    elevation: 10,
                                                    shadowColor: Colors.black,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .grey[400],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(3.0),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                  vertical: 8.0,
                                                                  horizontal:
                                                                      16.0,
                                                                ),
                                                                child: ListView
                                                                    .separated(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  separatorBuilder:
                                                                      (BuildContext context,
                                                                              int index) =>
                                                                          DividerWidget(),
                                                                  itemCount:
                                                                      x.length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  physics:
                                                                      ClampingScrollPhysics(),
                                                                  itemBuilder:
                                                                      (context,
                                                                          index1) {
                                                                    return HblViewWidget(
                                                                      hbl: x[
                                                                          index1],
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 15,
                                                          ),
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              await _launchURL(
                                                                x["file"],
                                                              );
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              foregroundColor:
                                                                  Colors.black,
                                                              shadowColor:
                                                                  Colors.black,
                                                              elevation: 3,
                                                              backgroundColor:
                                                                  Colors.orange,
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Center(
                                                                child: Text(
                                                                    "Download"),
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
                                  icon: Icon(
                                    Icons.arrow_upward_rounded,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              width: 50,
                              child: Center(
                                child: CustomText(
                                  text: shipment.shipmentsAgent[index].size[0],
                                ),
                              ),
                            ),
                    ),
                    DataCell(
                      shipment.shipmentsAgent[index].vol.length > 1
                          ? Container(
                              width: 50,
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    final x =
                                        shipment.shipmentsAgent[index].vol;
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
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: Card(
                                                    elevation: 10,
                                                    shadowColor: Colors.black,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .grey[400],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(3.0),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                  vertical: 8.0,
                                                                  horizontal:
                                                                      16.0,
                                                                ),
                                                                child: ListView
                                                                    .separated(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  separatorBuilder:
                                                                      (BuildContext context,
                                                                              int index) =>
                                                                          DividerWidget(),
                                                                  itemCount:
                                                                      x.length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  physics:
                                                                      ClampingScrollPhysics(),
                                                                  itemBuilder:
                                                                      (context,
                                                                          index1) {
                                                                    return HblViewWidget(
                                                                      hbl: x[
                                                                          index1],
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 15,
                                                          ),
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              await _launchURL(
                                                                x["file"],
                                                              );
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              foregroundColor:
                                                                  Colors.black,
                                                              shadowColor:
                                                                  Colors.black,
                                                              elevation: 3,
                                                              backgroundColor:
                                                                  Colors.orange,
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Center(
                                                                child: Text(
                                                                    "Download"),
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
                                  icon: Icon(
                                    Icons.arrow_upward_rounded,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              width: 50,
                              child: Center(
                                child: CustomText(
                                  text: shipment.shipmentsAgent[index].vol[0],
                                ),
                              ),
                            ),
                    ),
                    DataCell(
                      Container(
                        width: 100,
                        child: Center(
                          child: CustomText(
                            text: shipment.shipmentsAgent[index].pol,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        width: 100,
                        child: Center(
                          child: CustomText(
                            text: shipment.shipmentsAgent[index].pod,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        width: 100,
                        child: Center(
                          child: CustomText(
                            text: shipment.shipmentsAgent[index].comment,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        width: 75,
                        child: Center(
                          child: CustomText(
                            text: shipment.shipmentsAgent[index].shipingLine,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        width: 150,
                        child: Center(
                          child: CustomText(
                            text: shipment.shipmentsAgent[index].agentName,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        width: 100,
                        child: Center(
                          child: Text(
                            shipment.shipmentsAgent[index].loading,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        width: 100,
                        child: Center(
                          child: Text(
                            shipment.shipmentsAgent[index].arrival,
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
    );
  }

  _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class HblViewWidget extends StatelessWidget {
  final dynamic hbl;
  const HblViewWidget({Key? key, this.hbl}) : super(key: key);

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
