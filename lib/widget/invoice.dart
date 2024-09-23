import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sap/provider/invoice.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../helper/ExpandedListAnimationWidget.dart';
import '../helper/Scrollbar.dart';
import '../helper/firebase_api.dart';
import '../model/invoice_form.dart';
import '../provider/monitoring.dart';
import 'add_form_invoice.dart';
import 'add_hbl.dart';
import '../style/custom_text.dart';
import 'divider.dart';
import '../style/progress.dart';

class InvoiceClientWidget extends StatefulWidget {
  final String name;
  final String id;
  InvoiceClientWidget({Key? key, required this.id, required this.name})
      : super(key: key);

  @override
  State<InvoiceClientWidget> createState() => _InvoiceClientWidgetState();
}

class _InvoiceClientWidgetState extends State<InvoiceClientWidget> {
  TextEditingController _mbl = TextEditingController();
  TextEditingController _hbl = TextEditingController();
  TextEditingController _agentInvoiceNo = TextEditingController();
  TextEditingController _agentValue = TextEditingController();
  TextEditingController _sabInvoice = TextEditingController();
  TextEditingController _sabValueInvoice = TextEditingController();
  TextEditingController _shipInvoice = TextEditingController();
  TextEditingController _shipValueInvoice = TextEditingController();
  TextEditingController _fileNumber = TextEditingController();

  List<AddHblWidget> hbls = [];
  List<AddFormInvoiceWidget> agents = [];
  List<AddFormInvoiceWidget> sabs = [];
  List<AddFormInvoiceWidget> ships = [];

  final columns = [
    "MBL",
    "HBL",
    "Agent",
    'Sab',
    'Ship',
    'File Number',
  ];
  List<String>? _hblInfo = [];

  refresh() {
    setState(() {});
  }

  Container view = Container();
  Container view2 = Container();
  Container view3 = Container();
  String currency = "",
      currency2 = "",
      currency3 = "",
      agentUrl = "",
      sabUrl = "",
      shipUrl = "";
  dynamic groupValue, groupValue2, groupValue3;
  bool isStrechedDropDown = false,
      isStrechedDropDown2 = false,
      isStrechedDropDown3 = false;
  List<String> items = [
    'EUR',
    'USD',
    'JOD',
  ];

  late List<dynamic> _agentData = [];
  late List<dynamic> _sabData = [];
  late List<dynamic> _shipData = [];
  UploadTask? task;
  FilePickerResult? _sab, _agent, _ship;
  FileType _pickingType = FileType.any;
  List<Widget> widgets = [], widgets1 = [], widgets2 = [];
  bool _loadingPath = false, vic = true;

  Future<void> _openFileExplorer(dynamic setStateDia, String name) async {
    setStateDia(() => _loadingPath = true);
    try {
      if (name == "sab") {
        _sab = await FilePicker.platform.pickFiles(
          type: _pickingType,
        );

        widgets1.add(
          ListTile(
            title: Text(
              _sab!.files.first.name,
            ),
            leading: Text("Sab Invoice"),
            trailing: IconButton(
              icon: Icon(
                Icons.delete_outline,
                size: 20.0,
                color: Colors.brown[900],
              ),
              onPressed: () {
                var dialog = AlertDialog(
                  title: Text("Alert"),
                  content: Text(
                      "Are you sure you want to Remove this information ?"),
                  actionsAlignment: MainAxisAlignment.spaceEvenly,
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setStateDia(() {
                            widgets1 = [];
                            vic = true;
                          });
                        },
                        child: Text("Yes ,Remove it")),
                  ],
                );
                showDialog(
                  context: context,
                  builder: (BuildContext cxt) {
                    return dialog;
                  },
                );
              },
            ),
          ),
        );
      } else if (name == "agent") {
        _agent = await FilePicker.platform.pickFiles(
          type: _pickingType,
        );

        widgets.add(
          ListTile(
            title: Text(
              _agent!.files.first.name,
            ),
            leading: Text("Agent Invoice"),
            trailing: IconButton(
              icon: Icon(
                Icons.delete_outline,
                size: 20.0,
                color: Colors.brown[900],
              ),
              onPressed: () {
                var dialog = AlertDialog(
                  title: Text("Alert"),
                  content: Text(
                      "Are you sure you want to Remove this information ?"),
                  actionsAlignment: MainAxisAlignment.spaceEvenly,
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setStateDia(() {
                            widgets = [];
                            vic = true;
                          });
                        },
                        child: Text("Yes ,Remove it")),
                  ],
                );
                showDialog(
                  context: context,
                  builder: (BuildContext cxt) {
                    return dialog;
                  },
                );
              },
            ),
          ),
        );
      } else if (name == "ship") {
        _ship = await FilePicker.platform.pickFiles(
          type: _pickingType,
        );

        widgets2.add(
          ListTile(
            title: Text(
              _ship!.files.first.name,
            ),
            leading: Text("Ship Invoice"),
            trailing: IconButton(
              icon: Icon(
                Icons.delete_outline,
                size: 20.0,
                color: Colors.brown[900],
              ),
              onPressed: () {
                var dialog = AlertDialog(
                  title: Text("Alert"),
                  content: Text(
                      "Are you sure you want to Remove this information ?"),
                  actionsAlignment: MainAxisAlignment.spaceEvenly,
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setStateDia(() {
                            widgets2 = [];
                            vic = true;
                          });
                        },
                        child: Text("Yes ,Remove it")),
                  ],
                );
                showDialog(
                  context: context,
                  builder: (BuildContext cxt) {
                    return dialog;
                  },
                );
              },
            ),
          ),
        );
      }
    } catch (ex) {}
    if (!mounted) return;
    setStateDia(() {
      _loadingPath = false;
      vic = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final invoice = Provider.of<InvoiceProvider>(context);
    final monitoring = Provider.of<MonitoringProvider>(context);
    return SingleChildScrollView(
      child: Padding(
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      elevation: 10,
                                                      shadowColor: Colors.black,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: TextFormField(
                                                          controller: _mbl,
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintText: "MBL",
                                                            icon: Icon(
                                                              Icons
                                                                  .insert_drive_file_rounded,
                                                              size: 32,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.35,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 10,
                                                            right: 10,
                                                          ),
                                                          child: Card(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            elevation: 10,
                                                            shadowColor:
                                                                Colors.black,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    _hbl,
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText:
                                                                      "HBL",
                                                                  icon: Icon(
                                                                    Icons
                                                                        .insert_drive_file_outlined,
                                                                    size: 32,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: Icon(Icons.add),
                                                        onPressed: () {
                                                          setStateDia(() {
                                                            addForm(
                                                                setStateDia);
                                                            setStateDia(() {});
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: hbls,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Container(
                                                      child: Card(
                                                        color: Colors.grey[400],
                                                        elevation: 10,
                                                        shadowColor:
                                                            Colors.black,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      10.0),
                                                              child: Card(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                elevation: 10,
                                                                shadowColor:
                                                                    Colors
                                                                        .black,
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  child: Text(
                                                                    "Agent",
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      10.0),
                                                              child: Card(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                elevation: 10,
                                                                shadowColor:
                                                                    Colors
                                                                        .black,
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _agentInvoiceNo,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      border: InputBorder
                                                                          .none,
                                                                      hintText:
                                                                          "Agent Invoices No",
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .inventory_rounded,
                                                                        size:
                                                                            32,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      10.0),
                                                              child: Card(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                elevation: 10,
                                                                shadowColor:
                                                                    Colors
                                                                        .black,
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _agentValue,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      border: InputBorder
                                                                          .none,
                                                                      hintText:
                                                                          "Agent Value",
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .insert_drive_file_outlined,
                                                                        size:
                                                                            32,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                setStateDia(() {
                                                                  isStrechedDropDown =
                                                                      !isStrechedDropDown;
                                                                  isStrechedDropDown2 =
                                                                      false;
                                                                  isStrechedDropDown3 =
                                                                      false;
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Card(
                                                                              elevation: 10,
                                                                              shadowColor: Colors.black,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Container(
                                                                                  height: 45,
                                                                                  width: double.infinity,
                                                                                  padding: EdgeInsets.only(right: 10),
                                                                                  constraints: BoxConstraints(
                                                                                    minHeight: 50,
                                                                                    minWidth: double.infinity,
                                                                                  ),
                                                                                  alignment: Alignment.center,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.symmetric(
                                                                                            horizontal: 20,
                                                                                            vertical: 10,
                                                                                          ),
                                                                                          child: Row(
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            children: [
                                                                                              Text(
                                                                                                "Currency :",
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
                                                                                          onTap: () {
                                                                                            setStateDia(() {
                                                                                              isStrechedDropDown = !isStrechedDropDown;
                                                                                              isStrechedDropDown2 = false;
                                                                                              isStrechedDropDown3 = false;
                                                                                            });
                                                                                          },
                                                                                          child: Icon(isStrechedDropDown ? Icons.arrow_upward : Icons.arrow_downward))
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Card(
                                                                              shadowColor: Colors.black,
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                              child: ExpandedSection(
                                                                                expand: isStrechedDropDown,
                                                                                height: 100,
                                                                                child: MyScrollbar(
                                                                                  builder: (context, scrollController) => ListView.builder(
                                                                                    padding: EdgeInsets.all(0),
                                                                                    controller: scrollController,
                                                                                    shrinkWrap: true,
                                                                                    itemCount: items.length,
                                                                                    itemBuilder: (context, index) {
                                                                                      return RadioListTile(
                                                                                        title: Text(
                                                                                          items[index].toString().toUpperCase(),
                                                                                        ),
                                                                                        value: index,
                                                                                        groupValue: groupValue,
                                                                                        onChanged: (val) {
                                                                                          setStateDia(
                                                                                            () {
                                                                                              groupValue = val;
                                                                                              currency = items[index].toString().toUpperCase();

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
                                                                                                    currency,
                                                                                                    style: GoogleFonts.montserrat(
                                                                                                      color: Colors.white70,
                                                                                                      fontSize: 14,
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              );
                                                                                              isStrechedDropDown = !isStrechedDropDown;
                                                                                              isStrechedDropDown2 = false;
                                                                                              isStrechedDropDown3 = false;
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
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    await _openFileExplorer(
                                                                        setStateDia,
                                                                        "agent");
                                                                    agentUrl =
                                                                        await uploadFile(
                                                                            _agent);
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Colors.orange[
                                                                            700],
                                                                    foregroundColor:
                                                                        Colors
                                                                            .black,
                                                                    elevation:
                                                                        3,
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                    "Add file",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            SingleChildScrollView(
                                                              child: Builder(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    _loadingPath
                                                                        ? Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(
                                                                              bottom: 10.0,
                                                                            ),
                                                                            child:
                                                                                const CircularProgressIndicator(),
                                                                          )
                                                                        : vic
                                                                            ? Container()
                                                                            : Container(
                                                                                padding: const EdgeInsets.only(
                                                                                  right: 4,
                                                                                ),
                                                                                height: MediaQuery.of(context).size.height * 0.1,
                                                                                child: Column(
                                                                                  children: widgets,
                                                                                ),
                                                                              ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    addFormAll(
                                                                        setStateDia,
                                                                        "agent");
                                                                  },
                                                                  icon: Icon(
                                                                    Icons.add,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    children: agents,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Container(
                                                      child: Card(
                                                        color: Colors.grey[400],
                                                        elevation: 10,
                                                        shadowColor:
                                                            Colors.black,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      10.0),
                                                              child: Card(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                elevation: 10,
                                                                shadowColor:
                                                                    Colors
                                                                        .black,
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  child: Text(
                                                                    "Sab",
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      10.0),
                                                              child: Card(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                elevation: 10,
                                                                shadowColor:
                                                                    Colors
                                                                        .black,
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _sabInvoice,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      border: InputBorder
                                                                          .none,
                                                                      hintText:
                                                                          "Sab Invoice",
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .info,
                                                                        size:
                                                                            32,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      10.0),
                                                              child: Card(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                elevation: 10,
                                                                shadowColor:
                                                                    Colors
                                                                        .black,
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _sabValueInvoice,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      border: InputBorder
                                                                          .none,
                                                                      hintText:
                                                                          "Sab Value Invoice",
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .info_outline_rounded,
                                                                        size:
                                                                            32,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                setStateDia(() {
                                                                  isStrechedDropDown2 =
                                                                      !isStrechedDropDown2;
                                                                  isStrechedDropDown =
                                                                      false;
                                                                  isStrechedDropDown3 =
                                                                      false;
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Card(
                                                                              elevation: 10,
                                                                              shadowColor: Colors.black,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Container(
                                                                                  height: 45,
                                                                                  width: double.infinity,
                                                                                  padding: EdgeInsets.only(right: 10),
                                                                                  constraints: BoxConstraints(
                                                                                    minHeight: 50,
                                                                                    minWidth: double.infinity,
                                                                                  ),
                                                                                  alignment: Alignment.center,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.symmetric(
                                                                                            horizontal: 20,
                                                                                            vertical: 10,
                                                                                          ),
                                                                                          child: Row(
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            children: [
                                                                                              Text(
                                                                                                "Currency :",
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
                                                                                              isStrechedDropDown3 = false;
                                                                                            });
                                                                                          },
                                                                                          child: Icon(isStrechedDropDown2 ? Icons.arrow_upward : Icons.arrow_downward))
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Card(
                                                                              shadowColor: Colors.black,
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                              child: ExpandedSection(
                                                                                expand: isStrechedDropDown2,
                                                                                height: 100,
                                                                                child: MyScrollbar(
                                                                                  builder: (context, scrollController) => ListView.builder(
                                                                                    padding: EdgeInsets.all(0),
                                                                                    controller: scrollController,
                                                                                    shrinkWrap: true,
                                                                                    itemCount: items.length,
                                                                                    itemBuilder: (context, index) {
                                                                                      return RadioListTile(
                                                                                        title: Text(
                                                                                          items[index].toString().toUpperCase(),
                                                                                        ),
                                                                                        value: index,
                                                                                        groupValue: groupValue2,
                                                                                        onChanged: (val) {
                                                                                          setStateDia(
                                                                                            () {
                                                                                              groupValue2 = val;
                                                                                              currency2 = items[index].toString().toUpperCase();

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
                                                                                                    currency2,
                                                                                                    style: GoogleFonts.montserrat(
                                                                                                      color: Colors.white70,
                                                                                                      fontSize: 14,
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              );
                                                                                              isStrechedDropDown2 = !isStrechedDropDown2;
                                                                                              isStrechedDropDown = false;
                                                                                              isStrechedDropDown3 = false;
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
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    await _openFileExplorer(
                                                                        setStateDia,
                                                                        "sab");
                                                                    sabUrl =
                                                                        await uploadFile(
                                                                            _sab);
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Colors.orange[
                                                                            700],
                                                                    foregroundColor:
                                                                        Colors
                                                                            .black,
                                                                    elevation:
                                                                        3,
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                    "Add file",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            SingleChildScrollView(
                                                              child: Builder(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    _loadingPath
                                                                        ? Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(
                                                                              bottom: 10.0,
                                                                            ),
                                                                            child:
                                                                                const CircularProgressIndicator(),
                                                                          )
                                                                        : vic
                                                                            ? Container()
                                                                            : Container(
                                                                                padding: const EdgeInsets.only(
                                                                                  right: 4,
                                                                                ),
                                                                                height: MediaQuery.of(context).size.height * 0.1,
                                                                                child: Column(
                                                                                  children: widgets1,
                                                                                ),
                                                                              ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    addFormAll(
                                                                        setStateDia,
                                                                        "sab");
                                                                  },
                                                                  icon: Icon(
                                                                    Icons.add,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    children: sabs,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Container(
                                                      child: Card(
                                                        color: Colors.grey[400],
                                                        elevation: 10,
                                                        shadowColor:
                                                            Colors.black,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      10.0),
                                                              child: Card(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                elevation: 10,
                                                                shadowColor:
                                                                    Colors
                                                                        .black,
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  child: Text(
                                                                    "Ship",
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      10.0),
                                                              child: Card(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                elevation: 10,
                                                                shadowColor:
                                                                    Colors
                                                                        .black,
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _shipInvoice,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      border: InputBorder
                                                                          .none,
                                                                      hintText:
                                                                          "Ship Invoice",
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .info_outline_rounded,
                                                                        size:
                                                                            32,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      10.0),
                                                              child: Card(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                elevation: 10,
                                                                shadowColor:
                                                                    Colors
                                                                        .black,
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _shipValueInvoice,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      border: InputBorder
                                                                          .none,
                                                                      hintText:
                                                                          "Ship Value Invoice",
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .monetization_on_rounded,
                                                                        size:
                                                                            32,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                setStateDia(() {
                                                                  isStrechedDropDown3 =
                                                                      !isStrechedDropDown3;
                                                                  isStrechedDropDown =
                                                                      false;
                                                                  isStrechedDropDown2 =
                                                                      false;
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Card(
                                                                              elevation: 10,
                                                                              shadowColor: Colors.black,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Container(
                                                                                  height: 45,
                                                                                  width: double.infinity,
                                                                                  padding: EdgeInsets.only(right: 10),
                                                                                  constraints: BoxConstraints(
                                                                                    minHeight: 50,
                                                                                    minWidth: double.infinity,
                                                                                  ),
                                                                                  alignment: Alignment.center,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.symmetric(
                                                                                            horizontal: 20,
                                                                                            vertical: 10,
                                                                                          ),
                                                                                          child: Row(
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            children: [
                                                                                              Text(
                                                                                                "Currency :",
                                                                                                style: TextStyle(
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                width: 15,
                                                                                              ),
                                                                                              view3,
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      GestureDetector(
                                                                                          onTap: () {
                                                                                            setStateDia(() {
                                                                                              isStrechedDropDown3 = !isStrechedDropDown3;
                                                                                              isStrechedDropDown = false;
                                                                                              isStrechedDropDown2 = false;
                                                                                            });
                                                                                          },
                                                                                          child: Icon(isStrechedDropDown3 ? Icons.arrow_upward : Icons.arrow_downward))
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Card(
                                                                              shadowColor: Colors.black,
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                              child: ExpandedSection(
                                                                                expand: isStrechedDropDown3,
                                                                                height: 100,
                                                                                child: MyScrollbar(
                                                                                  builder: (context, scrollController) => ListView.builder(
                                                                                    padding: EdgeInsets.all(0),
                                                                                    controller: scrollController,
                                                                                    shrinkWrap: true,
                                                                                    itemCount: items.length,
                                                                                    itemBuilder: (context, index) {
                                                                                      return RadioListTile(
                                                                                        title: Text(
                                                                                          items[index].toString().toUpperCase(),
                                                                                        ),
                                                                                        value: index,
                                                                                        groupValue: groupValue3,
                                                                                        onChanged: (val) {
                                                                                          setStateDia(
                                                                                            () {
                                                                                              groupValue3 = val;
                                                                                              currency3 = items[index].toString().toUpperCase();

                                                                                              view3 = Container(
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
                                                                                                    currency3,
                                                                                                    style: GoogleFonts.montserrat(
                                                                                                      color: Colors.white70,
                                                                                                      fontSize: 14,
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              );
                                                                                              isStrechedDropDown3 = !isStrechedDropDown3;
                                                                                              isStrechedDropDown = false;
                                                                                              isStrechedDropDown2 = false;
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
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    await _openFileExplorer(
                                                                        setStateDia,
                                                                        "ship");
                                                                    shipUrl =
                                                                        await uploadFile(
                                                                            _ship);
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Colors.orange[
                                                                            700],
                                                                    foregroundColor:
                                                                        Colors
                                                                            .black,
                                                                    elevation:
                                                                        3,
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                    "Add file",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            SingleChildScrollView(
                                                              child: Builder(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    _loadingPath
                                                                        ? Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(
                                                                              bottom: 10.0,
                                                                            ),
                                                                            child:
                                                                                const CircularProgressIndicator(),
                                                                          )
                                                                        : vic
                                                                            ? Container()
                                                                            : Container(
                                                                                padding: const EdgeInsets.only(
                                                                                  right: 4,
                                                                                ),
                                                                                height: MediaQuery.of(context).size.height * 0.1,
                                                                                child: Column(
                                                                                  children: widgets2,
                                                                                ),
                                                                              ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    addFormAll(
                                                                        setStateDia,
                                                                        "ship");
                                                                  },
                                                                  icon: Icon(
                                                                    Icons.add,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    children: ships,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      elevation: 10,
                                                      shadowColor: Colors.black,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: TextFormField(
                                                          controller:
                                                              _fileNumber,
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintText:
                                                                "File Number",
                                                            icon: Icon(
                                                              Icons
                                                                  .drive_file_move_rtl_rounded,
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
                                                    constraints: BoxConstraints(
                                                      maxWidth: 150,
                                                    ),
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        await invoice.checkMbl(
                                                            _mbl.text);
                                                        if (invoice.check) {
                                                          onSave();
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                ProgressWidget(
                                                              msg:
                                                                  "Please wait...",
                                                            ),
                                                          );
                                                          await new Future
                                                              .delayed(
                                                            const Duration(
                                                                seconds: 2),
                                                          );
                                                          Navigator.pop(
                                                              context);
                                                          await monitoring
                                                              .addMonitoring(
                                                            widget.name,
                                                            "Invoice mbl ${_mbl.text}",
                                                            "Add New Invoice",
                                                            DateTime.now(),
                                                          );

                                                          await invoice
                                                              .addInvoice(
                                                            widget.name,
                                                            _mbl.text,
                                                            _hblInfo,
                                                            _agentData,
                                                            _sabData,
                                                            _shipData,
                                                            _fileNumber.text,
                                                            widget.id,
                                                          );
                                                          Navigator.pop(
                                                              context);
                                                        } else
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Can't add shipment Mbl already in system");
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        foregroundColor:
                                                            Colors.black,
                                                        backgroundColor:
                                                            Colors.orange[700],
                                                        elevation: 3,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "Add Invoice",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
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
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("invoice")
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
                                  columns: getColumns(columns),
                                  rows: List<DataRow>.generate(
                                    snapshot.data!.docs.length,
                                    (index) => DataRow(
                                      cells: [
                                        DataCell(
                                          Center(
                                            child: CustomText(
                                              text: snapshot.data!.docs[index]
                                                  .get("mbl"),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          snapshot.data!.docs[index]
                                                      .get("hbl")
                                                      .length >
                                                  1
                                              ? Center(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return StatefulBuilder(
                                                            builder:
                                                                (BuildContext
                                                                        context,
                                                                    setState) {
                                                              return Dialog(
                                                                child:
                                                                    Container(
                                                                  width: 680,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            15),
                                                                    child: Card(
                                                                      elevation:
                                                                          10,
                                                                      shadowColor:
                                                                          Colors
                                                                              .black,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Container(
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.grey[400],
                                                                                borderRadius: BorderRadius.circular(5.0),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: EdgeInsets.all(3.0),
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.symmetric(
                                                                                    vertical: 8.0,
                                                                                    horizontal: 16.0,
                                                                                  ),
                                                                                  child: ListView.separated(
                                                                                    padding: EdgeInsets.all(0),
                                                                                    separatorBuilder: (BuildContext context, int index) => DividerWidget(),
                                                                                    itemCount: snapshot.data!.docs[index].get("hbl").length,
                                                                                    shrinkWrap: true,
                                                                                    physics: ClampingScrollPhysics(),
                                                                                    itemBuilder: (context, index1) {
                                                                                      return HblViewWidget1(
                                                                                        hbl: snapshot.data!.docs[index].get("hbl")[index1],
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
                                                      Icons
                                                          .remove_red_eye_rounded,
                                                    ),
                                                  ),
                                                )
                                              : Center(
                                                  child: CustomText(
                                                    text: snapshot
                                                        .data!.docs[index]
                                                        .get("hbl")[0],
                                                  ),
                                                ),
                                        ),
                                        DataCell(
                                          GestureDetector(
                                            onTap: () {
                                              final x = snapshot
                                                  .data!.docs[index]
                                                  .get("agent");
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return StatefulBuilder(
                                                    builder:
                                                        (BuildContext context,
                                                            setState) {
                                                      return Dialog(
                                                        child: Container(
                                                          width: 680,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(15),
                                                            child: Card(
                                                              elevation: 10,
                                                              shadowColor:
                                                                  Colors.black,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .grey[400],
                                                                        borderRadius:
                                                                            BorderRadius.circular(5.0),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.all(3.0),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              EdgeInsets.symmetric(
                                                                            vertical:
                                                                                8.0,
                                                                            horizontal:
                                                                                16.0,
                                                                          ),
                                                                          child:
                                                                              ListView.separated(
                                                                            padding:
                                                                                EdgeInsets.all(0),
                                                                            separatorBuilder: (BuildContext context, int index) =>
                                                                                DividerWidget(),
                                                                            itemCount:
                                                                                x.length,
                                                                            shrinkWrap:
                                                                                true,
                                                                            physics:
                                                                                ClampingScrollPhysics(),
                                                                            itemBuilder:
                                                                                (context, index1) {
                                                                              return HblViewWidget(
                                                                                hbl: x[index1],
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
                                          GestureDetector(
                                            onTap: () {
                                              final x = snapshot
                                                  .data!.docs[index]
                                                  .get("sab");
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return StatefulBuilder(
                                                    builder:
                                                        (BuildContext context,
                                                            setState) {
                                                      return Dialog(
                                                        child: Container(
                                                          width: 680,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(15),
                                                            child: Card(
                                                              elevation: 10,
                                                              shadowColor:
                                                                  Colors.black,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .grey[400],
                                                                        borderRadius:
                                                                            BorderRadius.circular(5.0),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.all(3.0),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              EdgeInsets.symmetric(
                                                                            vertical:
                                                                                8.0,
                                                                            horizontal:
                                                                                16.0,
                                                                          ),
                                                                          child:
                                                                              ListView.separated(
                                                                            padding:
                                                                                EdgeInsets.all(0),
                                                                            separatorBuilder: (BuildContext context, int index) =>
                                                                                DividerWidget(),
                                                                            itemCount:
                                                                                x.length,
                                                                            shrinkWrap:
                                                                                true,
                                                                            physics:
                                                                                ClampingScrollPhysics(),
                                                                            itemBuilder:
                                                                                (context, index1) {
                                                                              return HblViewWidget(
                                                                                hbl: x[index1],
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
                                          GestureDetector(
                                            onTap: () {
                                              final x = snapshot
                                                  .data!.docs[index]
                                                  .get("ship");
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return StatefulBuilder(
                                                    builder:
                                                        (BuildContext context,
                                                            setState) {
                                                      return Dialog(
                                                        child: Container(
                                                          width: 680,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(15),
                                                            child: Card(
                                                              elevation: 10,
                                                              shadowColor:
                                                                  Colors.black,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .grey[400],
                                                                        borderRadius:
                                                                            BorderRadius.circular(5.0),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.all(3.0),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              EdgeInsets.symmetric(
                                                                            vertical:
                                                                                8.0,
                                                                            horizontal:
                                                                                16.0,
                                                                          ),
                                                                          child:
                                                                              ListView.separated(
                                                                            padding:
                                                                                EdgeInsets.all(0),
                                                                            separatorBuilder: (BuildContext context, int index) =>
                                                                                DividerWidget(),
                                                                            itemCount:
                                                                                x.length,
                                                                            shrinkWrap:
                                                                                true,
                                                                            physics:
                                                                                ClampingScrollPhysics(),
                                                                            itemBuilder:
                                                                                (context, index1) {
                                                                              return HblViewWidget(
                                                                                hbl: x[index1],
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
                                              text: snapshot.data!.docs[index]
                                                  .get("fileNumber"),
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
            ],
          ),
        ),
      ),
    );
  }

  Future uploadFile(FilePickerResult? paths) async {
    if (paths == null) {
      Fluttertoast.showToast(msg: "No file Selected");
      return;
    }

    task = FirebaseApi.uploadBytes(
        paths.files.first.name, paths.files.first.bytes!);

    final snapshot = await task!.whenComplete(() {});

    if (task == null) return;

    setState(() {
      Fluttertoast.showToast(msg: "Files Uploaded");
    });
    return await snapshot.ref.getDownloadURL();
  }

  void addForm(dynamic setStateDia) {
    setStateDia(() {
      var _container = TextEditingController();
      hbls.add(AddHblWidget(
        notifyParent: refresh,
        hbl: _container,
        onDelete: () => onDeleteHbl(_container, setStateDia),
      ));
    });
  }

  void addFormAll(dynamic setStateDia, String type) {
    setStateDia(() {
      if (type == 'agent') {
        var _value = InvoiceFormModel();
        agents.add(AddFormInvoiceWidget(
          name: type,
          form: _value,
          onDelete: () => onDelete(_value, setStateDia, type),
        ));
      } else if (type == "sab") {
        var _value = InvoiceFormModel();
        sabs.add(AddFormInvoiceWidget(
          name: type,
          form: _value,
          onDelete: () => onDelete(_value, setStateDia, type),
        ));
      } else if (type == "ship") {
        var _value = InvoiceFormModel();
        ships.add(AddFormInvoiceWidget(
          name: type,
          form: _value,
          onDelete: () => onDelete(_value, setStateDia, type),
        ));
      }
    });
  }

  void onDelete(InvoiceFormModel _container, dynamic setStateDia, String type) {
    setStateDia(() {
      if (type == 'agent') {
        var find = agents.firstWhere(
          (it) => it.form.invoicesNo == _container.invoicesNo,
          // ignore: null_check_always_fails
          orElse: () => null!,
        );
        // ignore: unnecessary_null_comparison
        if (find != null)
          agents.removeAt(
            agents.indexOf(find),
          );
      } else if (type == "sab") {
        var find = sabs.firstWhere(
          (it) => it.form.invoicesNo == _container.invoicesNo,
          // ignore: null_check_always_fails
          orElse: () => null!,
        );
        // ignore: unnecessary_null_comparison
        if (find != null)
          sabs.removeAt(
            sabs.indexOf(find),
          );
      } else if (type == "ship") {
        var find = ships.firstWhere(
          (it) => it.form.invoicesNo == _container.invoicesNo,
          // ignore: null_check_always_fails
          orElse: () => null!,
        );
        // ignore: unnecessary_null_comparison
        if (find != null)
          ships.removeAt(
            ships.indexOf(find),
          );
      }
    });
  }

  void onDeleteHbl(TextEditingController _container, dynamic setStateDia) {
    setStateDia(() {
      var find = hbls.firstWhere(
        (it) => it.hbl == _container,
        // ignore: null_check_always_fails
        orElse: () => null!,
      );
      // ignore: unnecessary_null_comparison
      if (find != null)
        hbls.removeAt(
          hbls.indexOf(find),
        );
    });
  }

  void onSave() {
    _hblInfo = hbls.map((it) => it.hbl!.text).toList();
    _hblInfo!.insert(0, _hbl.text);
    agents.forEach((element) {
      _agentData.add({
        'currency': element.form.currency,
        'value': element.form.value,
        'invoicesNo': element.form.invoicesNo,
        'url': element.form.url,
      });
    });
    _agentData.insert(0, {
      'currency': currency,
      'value': _agentValue.text,
      'invoicesNo': _agentInvoiceNo.text,
      'url': agentUrl,
    });
    sabs.forEach((element) {
      _sabData.add({
        'currency': element.form.currency,
        'value': element.form.value,
        'invoicesNo': element.form.invoicesNo,
        'url': element.form.url,
      });
    });
    _sabData.insert(0, {
      'currency': currency2,
      'value': _sabValueInvoice.text,
      'invoicesNo': _sabInvoice.text,
      'url': sabUrl,
    });
    ships.forEach((element) {
      _shipData.add({
        'currency': element.form.currency,
        'value': element.form.value,
        'invoicesNo': element.form.invoicesNo,
        'url': element.form.url,
      });
    });
    _shipData.insert(0, {
      'currency': currency3,
      'value': _shipValueInvoice.text,
      'invoicesNo': _shipInvoice.text,
      'url': shipUrl,
    });
  }

  List<DataColumn2> getColumns(List<String> columns) => columns
      .map(
        (String column) => DataColumn2(
          label: Text(
            column,
            style: TextStyle(
              color: Colors.orange,
            ),
          ),
        ),
      )
      .toList();
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
