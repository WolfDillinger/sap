import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sap/provider/action.dart';
import '../helper/ExpandedListAnimationWidget.dart';
import '../helper/Scrollbar.dart';
import '../provider/monitoring.dart';
import '../style/custom_text.dart';

class ActionClientWidget extends StatefulWidget {
  final String id;
  final String name;
  final String clientName;
  ActionClientWidget(
      {Key? key,
      required this.id,
      required this.name,
      required this.clientName})
      : super(key: key);

  @override
  State<ActionClientWidget> createState() => _ActionClientWidgetState();
}

class _ActionClientWidgetState extends State<ActionClientWidget> {
  TextEditingController infomation = TextEditingController();
  final columns = [
    'Add By',
    "Date",
    "Action type",
    'Next action type',
    'Next date',
    'Information',
  ];
  final action = [
    "Call",
    "Visit",
    'Note',
    'Booking',
  ];
  String actionType = "", nextAction = "";
  Container view = Container();
  Container view2 = Container();
  dynamic groupValue, groupValue2;
  bool isStrechedDropDown = false, isStrechedDropDown2 = false;
  String _selectedDate = "Date", _selectedDate2 = "Next date";
  @override
  Widget build(BuildContext context) {
    final actionProvider = Provider.of<ActionProvider>(context);
    final monitoring = Provider.of<MonitoringProvider>(context);
    Future<void> _selectDate(
        BuildContext context, String x, dynamic setStateDia) async {
      final DateTime? datePicker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2050),
      );
      if (datePicker != null)
        setStateDia(
          () {
            var curentDate = DateFormat('dd-MM-yyyy')
                .format(datePicker)
                .toString()
                .split(" ");

            if (x == "datePicker1") {
              _selectedDate = curentDate[0];
            } else if (x == "datePicker2") {
              _selectedDate2 = curentDate[0];
            }
          },
        );
    }

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 150),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (BuildContext context, setStateDia) {
                                return Dialog(
                                  child: Container(
                                    width: 680,
                                    child: SingleChildScrollView(
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
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      _selectDate(
                                                          context,
                                                          "datePicker1",
                                                          setStateDia);
                                                    },
                                                    child: Card(
                                                      elevation: 10,
                                                      shadowColor: Colors.black,
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
                                                        child: Container(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            15),
                                                                child: Text(
                                                                    _selectedDate),
                                                              ),
                                                              IconButton(
                                                                icon: Icon(
                                                                  Icons
                                                                      .calendar_today,
                                                                  size: 32,
                                                                ),
                                                                onPressed: () {
                                                                  _selectDate(
                                                                      context,
                                                                      "datePicker1",
                                                                      setStateDia);
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setStateDia(() {
                                                      isStrechedDropDown =
                                                          !isStrechedDropDown;
                                                      isStrechedDropDown2 =
                                                          false;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            child: Column(
                                                              children: [
                                                                Card(
                                                                  elevation: 10,
                                                                  shadowColor:
                                                                      Colors
                                                                          .black,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          45,
                                                                      width: double
                                                                          .infinity,
                                                                      padding: EdgeInsets.only(
                                                                          right:
                                                                              10),
                                                                      constraints:
                                                                          BoxConstraints(
                                                                        minHeight:
                                                                            50,
                                                                        minWidth:
                                                                            double.infinity,
                                                                      ),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.symmetric(
                                                                                horizontal: 20,
                                                                                vertical: 10,
                                                                              ),
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Text(
                                                                                    "Action type :",
                                                                                    style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 15,
                                                                                  ),
                                                                                  view,
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              setStateDia(() {
                                                                                isStrechedDropDown = !isStrechedDropDown;

                                                                                isStrechedDropDown2 = false;
                                                                              });
                                                                            },
                                                                            child: Icon(isStrechedDropDown
                                                                                ? Icons.arrow_upward
                                                                                : Icons.arrow_downward),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Card(
                                                                  elevation: 10,
                                                                  shadowColor:
                                                                      Colors
                                                                          .black,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child:
                                                                      ExpandedSection(
                                                                    expand:
                                                                        isStrechedDropDown,
                                                                    height: 100,
                                                                    child:
                                                                        MyScrollbar(
                                                                      builder: (context,
                                                                              scrollController) =>
                                                                          ListView
                                                                              .builder(
                                                                        padding:
                                                                            EdgeInsets.all(0),
                                                                        controller:
                                                                            scrollController,
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount:
                                                                            action.length,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          return RadioListTile(
                                                                            title:
                                                                                Text(action[index]),
                                                                            value:
                                                                                index,
                                                                            groupValue:
                                                                                groupValue,
                                                                            onChanged:
                                                                                (val) {
                                                                              setStateDia(
                                                                                () {
                                                                                  groupValue = val;
                                                                                  actionType = action[index];

                                                                                  view = Container(
                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors.orange[600],
                                                                                      borderRadius: BorderRadius.circular(15),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.only(
                                                                                        left: 15,
                                                                                        right: 15,
                                                                                        top: 5,
                                                                                        bottom: 5,
                                                                                      ),
                                                                                      child: Text(
                                                                                        actionType,
                                                                                        style: GoogleFonts.montserrat(
                                                                                          color: Colors.white70,
                                                                                          fontSize: 14,
                                                                                          fontWeight: FontWeight.w500,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                  isStrechedDropDown = !isStrechedDropDown;
                                                                                },
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    elevation: 10,
                                                    shadowColor: Colors.black,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: TextField(
                                                        maxLines: 5,
                                                        minLines: 1,
                                                        controller: infomation,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              "Information",
                                                          icon: Icon(
                                                            Icons.info,
                                                            size: 32,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setStateDia(() {
                                                      isStrechedDropDown2 =
                                                          !isStrechedDropDown2;
                                                      isStrechedDropDown =
                                                          false;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            child: Column(
                                                              children: [
                                                                Card(
                                                                  elevation: 10,
                                                                  shadowColor:
                                                                      Colors
                                                                          .black,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          45,
                                                                      width: double
                                                                          .infinity,
                                                                      padding: EdgeInsets.only(
                                                                          right:
                                                                              10),
                                                                      constraints:
                                                                          BoxConstraints(
                                                                        minHeight:
                                                                            50,
                                                                        minWidth:
                                                                            double.infinity,
                                                                      ),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.symmetric(
                                                                                horizontal: 20,
                                                                                vertical: 10,
                                                                              ),
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Text(
                                                                                    "Next Action :",
                                                                                    style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 15,
                                                                                  ),
                                                                                  view2,
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          GestureDetector(
                                                                              onTap: () {
                                                                                setStateDia(() {
                                                                                  isStrechedDropDown2 = !isStrechedDropDown2;
                                                                                  isStrechedDropDown = false;
                                                                                });
                                                                              },
                                                                              child: Icon(isStrechedDropDown2 ? Icons.arrow_upward : Icons.arrow_downward))
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Card(
                                                                  elevation: 10,
                                                                  shadowColor:
                                                                      Colors
                                                                          .black,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  child:
                                                                      ExpandedSection(
                                                                    expand:
                                                                        isStrechedDropDown2,
                                                                    height: 100,
                                                                    child:
                                                                        MyScrollbar(
                                                                      builder: (context,
                                                                              scrollController) =>
                                                                          ListView
                                                                              .builder(
                                                                        padding:
                                                                            EdgeInsets.all(0),
                                                                        controller:
                                                                            scrollController,
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount:
                                                                            action.length,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          return RadioListTile(
                                                                            title:
                                                                                Text(action[index]),
                                                                            value:
                                                                                index,
                                                                            groupValue:
                                                                                groupValue2,
                                                                            onChanged:
                                                                                (val) {
                                                                              setStateDia(
                                                                                () {
                                                                                  groupValue2 = val;
                                                                                  nextAction = action[index];

                                                                                  view2 = Container(
                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors.orange[600],
                                                                                      borderRadius: BorderRadius.circular(15),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.only(
                                                                                        left: 15,
                                                                                        right: 15,
                                                                                        top: 5,
                                                                                        bottom: 5,
                                                                                      ),
                                                                                      child: Text(
                                                                                        nextAction,
                                                                                        style: GoogleFonts.montserrat(
                                                                                          color: Colors.white70,
                                                                                          fontSize: 14,
                                                                                          fontWeight: FontWeight.w500,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                  isStrechedDropDown2 = !isStrechedDropDown2;
                                                                                },
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      _selectDate(
                                                          context,
                                                          "datePicker2",
                                                          setStateDia);
                                                    },
                                                    child: Card(
                                                      elevation: 10,
                                                      shadowColor: Colors.black,
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
                                                        child: Container(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            15),
                                                                child: Text(
                                                                    _selectedDate2),
                                                              ),
                                                              IconButton(
                                                                icon: Icon(
                                                                  Icons
                                                                      .calendar_today,
                                                                  size: 32,
                                                                ),
                                                                onPressed: () {
                                                                  _selectDate(
                                                                      context,
                                                                      "datePicker2",
                                                                      setStateDia);
                                                                },
                                                              ),
                                                            ],
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
                                                  constraints: BoxConstraints(
                                                      maxWidth: 150),
                                                  child: Center(
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        await monitoring
                                                            .addMonitoring(
                                                          widget.name,
                                                          "Action $actionType and  Next Action $nextAction",
                                                          "Add New Action",
                                                          DateTime.now(),
                                                        );
                                                        await actionProvider
                                                            .addAction(
                                                          widget.clientName,
                                                          widget.name,
                                                          _selectedDate,
                                                          _selectedDate2,
                                                          actionType,
                                                          nextAction,
                                                          widget.id,
                                                          infomation.text,
                                                        );

                                                        _selectedDate = "Date";
                                                        _selectedDate2 =
                                                            "Next date";
                                                        actionType = "";
                                                        nextAction = "";
                                                        infomation.text = "";

                                                        Navigator.pop(context);
                                                        setState(() {});
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        foregroundColor:
                                                            Colors.black,
                                                        backgroundColor:
                                                            Colors.orange[700],
                                                        elevation: 3,
                                                        shadowColor:
                                                            Colors.orange,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "Add Action",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
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
                              },
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.orange[700],
                        elevation: 10,
                        shadowColor: Colors.black,
                      ),
                      child: Center(
                        child: Text(
                          "Add",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("action")
                    .where("uid", isEqualTo: widget.id)
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
                                  rows: snapshot.data!.docs
                                      .map(
                                        (e) => DataRow(
                                          cells: [
                                            DataCell(
                                              Center(
                                                child: CustomText(
                                                  text: e.get("by"),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                child: CustomText(
                                                  text: e.get("date"),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                child: CustomText(
                                                  text: e.get("actionType"),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                child: CustomText(
                                                  text: e.get("nextActionType"),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                child: CustomText(
                                                  text: e.get("nextDate"),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                child: CustomText(
                                                  text: e.get("note"),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(), //////////////////////////////
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
          ],
        ),
      ),
    );
  }
}
