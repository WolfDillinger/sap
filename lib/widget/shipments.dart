import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../helper/ExpandedListAnimationWidget.dart';
import '../helper/Scrollbar.dart';
import '../helper/firebase_api.dart';
import '../model/form.dart';
import '../provider/monitoring.dart';
import '../provider/shipment.dart';
import '../screen/bls_edits.dart';
import 'add_form.dart';
import 'add_hbl.dart';
import 'container_form.dart';
import 'country_prediction.dart';
import 'custom_text.dart';
import 'divider.dart';
import 'progress.dart';
import 'sea_line_prediction.dart';

class ShipmentClientWidget extends StatefulWidget {
  final String id;
  final String name;
  ShipmentClientWidget({Key? key, required this.id, required this.name})
      : super(key: key);

  @override
  State<ShipmentClientWidget> createState() => _ShipmentClientWidgetState();
}

class _ShipmentClientWidgetState extends State<ShipmentClientWidget> {
  ScrollController scollBarController = ScrollController();
  TextEditingController _mbl = TextEditingController();
  TextEditingController _hbl = TextEditingController();
  TextEditingController _vol = TextEditingController();
  TextEditingController _comment = TextEditingController();
  TextEditingController _agentCode = TextEditingController();
  TextEditingController _agentName = TextEditingController();
  TextEditingController pol = TextEditingController();
  TextEditingController pod = TextEditingController();
  TextEditingController containerNumber = TextEditingController();
  TextEditingController _editPol = TextEditingController();
  TextEditingController _editPod = TextEditingController();
  TextEditingController _editSealine = TextEditingController();
  TextEditingController _editComment = TextEditingController();

  final columns = [
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
    'Agent Code',
    'Loading',
    'Arrival',
    'Action',
  ];

  List<String> items3 = [
    '20',
    '40',
    '40 H',
    '45',
    '20 RF',
    '40 RF',
    '20 OT',
    '40 OT',
    '20 FR',
    '40 FR',
  ];

  List<String> items2 = [
    'ORIGINAL',
    'SWB',
  ];
  List<ContainerFormWidget> containers = [];
  List<AddFormWidget> mainForm = [];
  List<AddHblWidget> hbls = [];
  String title = "Sea Line", title2 = "";
  bool isStrechedDropDown = false;
  dynamic groupValue;
  Container view = Container();
  @override
  void initState() {
    super.initState();
    pol.text = "POL";
    pod.text = "POD";
  }

  FilePickerResult? _mblFile, _hblFile;

  String? upView;
  bool _loadingPath = false, vic = true;
  FileType _pickingType = FileType.any;
  UploadTask? task;
  String mblUrl = "", hblUrl = '';
  List<String>? _hblInfo = [];
  List<String>? _conInfo = [];
  List<String>? _sizeInfo = [];
  List<String>? _volInfo = [];
  List<Widget> widgets = [];

  Future<void> _openFileExplorer(dynamic setStateDia, String name) async {
    setStateDia(() => _loadingPath = true);
    try {
      if (name == "MBL") {
        _mblFile = await FilePicker.platform.pickFiles(
          type: _pickingType,
        );

        widgets.add(
          ListTile(
            title: Text(
              _mblFile!.files.first.name,
            ),
            leading: Text("MBL"),
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
      } else if (name == "HBL") {
        _hblFile = await FilePicker.platform.pickFiles(
          type: _pickingType,
        );

        widgets.add(
          ListTile(
            title: Text(
              _hblFile!.files.first.name,
            ),
            leading: Text("HBL"),
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
      }
    } catch (ex) {}
    if (!mounted) return;
    setStateDia(() {
      _loadingPath = false;
      vic = false;
    });
  }

  String _selectedDate1 = "Sea date", _selectedDate2 = "arrival date";

  @override
  Widget build(BuildContext context) {
    final shipment = Provider.of<ShipmentProvider>(context);
    final monitoring = Provider.of<MonitoringProvider>(context);
    Future<void> _selectDate(
        BuildContext context, String x, dynamic setState123) async {
      final DateTime? datePicker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2050),
      );
      if (datePicker != null)
        setState123(
          () {
            var curentDate = DateFormat('dd-MM-yyyy')
                .format(datePicker)
                .toString()
                .split(" ");

            if (x == "sea1") {
              _selectedDate1 = curentDate[0];
            } else if (x == "sea2") {
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        containers = [];
                        mainForm = [];
                        _hblInfo = [];
                        _sizeInfo = [];
                        _volInfo = [];
                        _conInfo = [];
                        pol.text = "POL";
                        pod.text = "POD";
                        _mbl.text = "";
                        _agentName.text = "";
                        _agentCode.text = "";
                        _loadingPath = false;
                        vic = true;
                        _selectedDate1 = "Sea date";
                        _selectedDate2 = "arrival date";
                        title = "Sea Line";
                        containers = [];
                        mainForm = [];
                        hbls = [];
                        view = Container();
                        widgets = [];
                        _comment.text = "";
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
                                                TextButton(
                                                  onPressed: () async {
                                                    pol.text = await showDialog(
                                                      context: context,
                                                      builder:
                                                          (BuildContext cxt) {
                                                        return CountryPredictionWidget();
                                                      },
                                                    );

                                                    setStateDia(() {});
                                                  },
                                                  child: Card(
                                                    elevation: 10,
                                                    shadowColor: Colors.black,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Container(
                                                      height: 60,
                                                      child: Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              pol.text,
                                                              style: GoogleFonts
                                                                  .lato(
                                                                fontSize: 20.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    pod.text = await showDialog(
                                                      context: context,
                                                      builder:
                                                          (BuildContext cxt) {
                                                        return CountryPredictionWidget();
                                                      },
                                                    );
                                                    setStateDia(() {});
                                                  },
                                                  child: Card(
                                                    elevation: 10,
                                                    shadowColor: Colors.black,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Container(
                                                      height: 60,
                                                      child: Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              pod.text,
                                                              style: GoogleFonts
                                                                  .lato(
                                                                fontSize: 20.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    title = await showDialog(
                                                      context: context,
                                                      builder:
                                                          (BuildContext cxt) {
                                                        return SealinePredictionWidget();
                                                      },
                                                    );

                                                    setStateDia(() {});
                                                  },
                                                  child: Card(
                                                    elevation: 10,
                                                    shadowColor: Colors.black,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Container(
                                                      height: 60,
                                                      child: Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              title,
                                                              style: GoogleFonts
                                                                  .lato(
                                                                fontSize: 20.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
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
                                                          EdgeInsets.all(10),
                                                      child: TextFormField(
                                                        controller: _mbl,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
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
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    await _openFileExplorer(
                                                        setStateDia, "MBL");
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          ProgressWidget(
                                                        msg: "Please wait...",
                                                      ),
                                                    );
                                                    mblUrl = await uploadFile(
                                                        _mblFile);

                                                    Navigator.pop(context);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.orange[700],
                                                    foregroundColor:
                                                        Colors.black,
                                                    elevation: 3,
                                                  ),
                                                  child: const Text(
                                                    "Add MBL",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
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
                                                              10,
                                                            ),
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
                                                              controller: _hbl,
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                hintText: "HBL",
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
                                                          onAddForm(
                                                            setStateDia,
                                                            "hbl",
                                                          );
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    await _openFileExplorer(
                                                        setStateDia, "HBL");

                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          ProgressWidget(
                                                        msg: "Please wait...",
                                                      ),
                                                    );
                                                    hblUrl = await uploadFile(
                                                        _hblFile);

                                                    Navigator.pop(context);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.orange[700],
                                                    foregroundColor:
                                                        Colors.black,
                                                    elevation: 3,
                                                  ),
                                                  child: const Text(
                                                    "Add HBL",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Column(
                                                  children: hbls,
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Card(
                                                  color: Colors.grey[400],
                                                  shadowColor: Colors.grey,
                                                  elevation: 10,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
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
                                                                  EdgeInsets
                                                                      .all(10),
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    _vol,
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText:
                                                                      "Volume",
                                                                  icon: Icon(
                                                                    Icons
                                                                        .view_column_rounded,
                                                                    size: 32,
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
                                                            });
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
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
                                                                          elevation:
                                                                              10,
                                                                          shadowColor:
                                                                              Colors.black,
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Container(
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
                                                                                            "Size:",
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
                                                                                        });
                                                                                      },
                                                                                      child: Icon(isStrechedDropDown ? Icons.arrow_upward : Icons.arrow_downward))
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Card(
                                                                          shadowColor:
                                                                              Colors.black,
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                          child:
                                                                              ExpandedSection(
                                                                            expand:
                                                                                isStrechedDropDown,
                                                                            height:
                                                                                100,
                                                                            child:
                                                                                MyScrollbar(
                                                                              builder: (context, scrollController) => ListView.builder(
                                                                                padding: EdgeInsets.all(0),
                                                                                controller: scrollController,
                                                                                shrinkWrap: true,
                                                                                itemCount: items3.length,
                                                                                itemBuilder: (context, index3) {
                                                                                  return RadioListTile(
                                                                                    title: Text(
                                                                                      items3[index3].toString().toUpperCase(),
                                                                                    ),
                                                                                    value: index3,
                                                                                    groupValue: groupValue,
                                                                                    onChanged: (val) {
                                                                                      setStateDia(
                                                                                        () {
                                                                                          groupValue = val;
                                                                                          title2 = items3[index3].toString().toUpperCase();

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
                                                                                                title2,
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
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  elevation: 10,
                                                                  shadowColor:
                                                                      Colors
                                                                          .black,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            10),
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          containerNumber,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        border:
                                                                            InputBorder.none,
                                                                        hintText:
                                                                            "Container NO",
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .add_box_rounded,
                                                                          size:
                                                                              32,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            IconButton(
                                                              icon: Icon(
                                                                  Icons.add),
                                                              onPressed: () {
                                                                setStateDia(() {
                                                                  onAddForm(
                                                                    setStateDia,
                                                                    "containerContro",
                                                                  );
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Column(
                                                          children: containers,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            IconButton(
                                                              onPressed: () {
                                                                onAddMain(
                                                                    setStateDia);
                                                              },
                                                              icon: Icon(
                                                                  Icons.add),
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          children: mainForm,
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
                                                          EdgeInsets.all(10),
                                                      child: TextFormField(
                                                        controller: _agentName,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              "Agent Name",
                                                          icon: Icon(
                                                            Icons
                                                                .support_agent_rounded,
                                                            size: 32,
                                                          ),
                                                        ),
                                                      ),
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
                                                          EdgeInsets.all(10),
                                                      child: TextFormField(
                                                        controller: _agentCode,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              "Agent Code",
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
                                                          EdgeInsets.all(10),
                                                      child: TextField(
                                                        controller: _comment,
                                                        maxLines: 5,
                                                        minLines: 1,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText: "Comment",
                                                          icon: Icon(
                                                            Icons.comment,
                                                            size: 32,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setStateDia(
                                                        () {
                                                          _selectDate(
                                                              context,
                                                              "sea1",
                                                              setStateDia);
                                                        },
                                                      );
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
                                                                    _selectedDate1),
                                                              ),
                                                              IconButton(
                                                                icon: Icon(
                                                                  Icons
                                                                      .calendar_today,
                                                                  size: 32,
                                                                ),
                                                                onPressed: () {
                                                                  setStateDia(
                                                                    () {
                                                                      _selectDate(
                                                                          context,
                                                                          "sea1",
                                                                          setStateDia);
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setStateDia(
                                                        () {
                                                          _selectDate(
                                                              context,
                                                              "sea2",
                                                              setStateDia);
                                                        },
                                                      );
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
                                                                  setStateDia(
                                                                    () {
                                                                      _selectDate(
                                                                          context,
                                                                          "sea2",
                                                                          setStateDia);
                                                                    },
                                                                  );
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
                                                  height: 25,
                                                ),
                                                SingleChildScrollView(
                                                  child: Builder(
                                                    builder: (BuildContext
                                                            context) =>
                                                        _loadingPath
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  bottom: 10.0,
                                                                ),
                                                                child:
                                                                    const CircularProgressIndicator(),
                                                              )
                                                            : vic
                                                                ? Container()
                                                                : Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      right: 4,
                                                                    ),
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.3,
                                                                    child:
                                                                        Column(
                                                                      children:
                                                                          widgets,
                                                                    ),
                                                                  ),
                                                  ),
                                                ),
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxWidth: 150),
                                                  child: Center(
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        if (_agentCode
                                                                .text.length >=
                                                            6) {
                                                          await shipment
                                                              .checkMbl(
                                                                  _mbl.text);
                                                          if (shipment.check) {
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

                                                            await monitoring
                                                                .addMonitoring(
                                                              widget.name,
                                                              "Shipment mbl ${_mbl.text} Agent name  ${_agentName.text}",
                                                              "Add New Shipment",
                                                              DateTime.now(),
                                                            );

                                                            await shipment
                                                                .addShipment(
                                                              widget.name,
                                                              _hblInfo,
                                                              _sizeInfo,
                                                              _volInfo,
                                                              _conInfo,
                                                              pol.text,
                                                              pod.text,
                                                              _mbl.text,
                                                              _agentName.text,
                                                              _agentCode.text,
                                                              mblUrl,
                                                              hblUrl,
                                                              _selectedDate1,
                                                              _selectedDate2,
                                                              _comment.text,
                                                              title,
                                                              widget.id,
                                                            );

                                                            await new Future
                                                                .delayed(
                                                              const Duration(
                                                                  seconds: 1),
                                                            );
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                            setState(() {});
                                                          } else
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Can't add shipment Mbl already in system");
                                                        } else {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Agent Code less than 6 characters");
                                                        }
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
                                                          "Add Shipment",
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
                                                SizedBox(
                                                  height: 15,
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
                  .collection("shipment")
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
                    {
                      return Scrollbar(
                        thumbVisibility: true,
                        scrollbarOrientation: ScrollbarOrientation.top,
                        controller: scollBarController,
                        child: SingleChildScrollView(
                          controller: scollBarController,
                          scrollDirection: Axis.horizontal,
                          child: Container(
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
                                      dataRowColor:
                                          WidgetStateProperty.all<Color>(
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
                                              Container(
                                                width: 225,
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Center(
                                                        child: CustomText(
                                                          text: snapshot
                                                              .data!.docs[index]
                                                              .get("mbl")
                                                              .toString(),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          final x = snapshot
                                                              .data!.docs[index]
                                                              .get("mbl");
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return StatefulBuilder(
                                                                builder: (BuildContext
                                                                        context,
                                                                    setState123) {
                                                                  return Dialog(
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          680,
                                                                      child:
                                                                          SingleChildScrollView(
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              15),
                                                                          child:
                                                                              Card(
                                                                            elevation:
                                                                                10,
                                                                            shadowColor:
                                                                                Colors.black,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  Card(
                                                                                    elevation: 10,
                                                                                    shadowColor: Colors.black,
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(3),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
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
                                                                                    onPressed: () async {
                                                                                      await _launchURL(
                                                                                        snapshot.data!.docs[index].get("file"),
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
                                                            Icons
                                                                .remove_red_eye_rounded,
                                                            size: 14,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return StatefulBuilder(
                                                                builder: (BuildContext
                                                                        context,
                                                                    setState123) {
                                                                  return Dialog(
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          680,
                                                                      child:
                                                                          SingleChildScrollView(
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              15),
                                                                          child:
                                                                              Card(
                                                                            elevation:
                                                                                10,
                                                                            shadowColor:
                                                                                Colors.black,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
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
                                                                                          controller: _mbl,
                                                                                          decoration: InputDecoration(
                                                                                            border: InputBorder.none,
                                                                                            hintText: snapshot.data!.docs[index].get("mbl"),
                                                                                            icon: Icon(
                                                                                              Icons.insert_drive_file_rounded,
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
                                                                                  ElevatedButton(
                                                                                    onPressed: () async {
                                                                                      showDialog(
                                                                                        context: context,
                                                                                        builder: (BuildContext context) => ProgressWidget(
                                                                                          msg: "Please wait...",
                                                                                        ),
                                                                                      );

                                                                                      await monitoring.addMonitoring(
                                                                                        widget.name,
                                                                                        "Shipment mbl ${_mbl.text}",
                                                                                        "Update Mbl Shipment",
                                                                                        DateTime.now(),
                                                                                      );
                                                                                      await shipment.updateMbl(_mbl.text, snapshot.data!.docs[index].get("id"));

                                                                                      await new Future.delayed(
                                                                                        const Duration(seconds: 1),
                                                                                      );
                                                                                      Navigator.pop(context);
                                                                                      Navigator.pop(context);
                                                                                      setState(() {});
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
                                                                                        child: Text("Update Mbl"),
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
                                                            Icons.edit,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 50,
                                                    child: Center(
                                                      child: IconButton(
                                                        onPressed: () {
                                                          final x = snapshot
                                                              .data!.docs[index]
                                                              .get("hbl");

                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return StatefulBuilder(
                                                                builder: (BuildContext
                                                                        context,
                                                                    setState) {
                                                                  return Dialog(
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          680,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            15),
                                                                        child:
                                                                            Card(
                                                                          elevation:
                                                                              10,
                                                                          shadowColor:
                                                                              Colors.black,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
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
                                                                                        itemCount: x["number"].length,
                                                                                        shrinkWrap: true,
                                                                                        physics: ClampingScrollPhysics(),
                                                                                        itemBuilder: (context, index1) {
                                                                                          return HblViewWidget(
                                                                                            hbl: x["number"][index1],
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
                                                          Icons
                                                              .remove_red_eye_rounded,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  GestureDetector(
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
                                                                                  child: HblsEditsScreen(
                                                                                    name: widget.name,
                                                                                    hbls: snapshot.data!.docs[index].get("hbl")["number"],
                                                                                    id: snapshot.data!.docs[index].get("id"),
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
                                                        Icons.edit,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            DataCell(
                                              snapshot.data!.docs[index]
                                                          .get("container")
                                                          .length >
                                                      1
                                                  ? Container(
                                                      width: 50,
                                                      child: Center(
                                                        child: IconButton(
                                                          onPressed: () {
                                                            final x = snapshot
                                                                .data!
                                                                .docs[index]
                                                                .get(
                                                                    "container");
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return StatefulBuilder(
                                                                  builder: (BuildContext
                                                                          context,
                                                                      setState) {
                                                                    return Dialog(
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            680,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              15),
                                                                          child:
                                                                              Card(
                                                                            elevation:
                                                                                10,
                                                                            shadowColor:
                                                                                Colors.black,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
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
                                                                                          itemCount: snapshot.data!.docs[index].get("container").length,
                                                                                          shrinkWrap: true,
                                                                                          physics: ClampingScrollPhysics(),
                                                                                          itemBuilder: (context, index1) {
                                                                                            return HblViewWidget(
                                                                                              hbl: snapshot.data!.docs[index].get("container")[index1],
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
                                                            Icons
                                                                .remove_red_eye_rounded,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      width: 100,
                                                      child: Center(
                                                        child: CustomText(
                                                          text: snapshot
                                                              .data!.docs[index]
                                                              .get(
                                                                  "container")[0],
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                            DataCell(
                                              snapshot.data!.docs[index]
                                                          .get("size")
                                                          .length >
                                                      1
                                                  ? Container(
                                                      width: 50,
                                                      child: Center(
                                                        child: IconButton(
                                                          onPressed: () {
                                                            final x = snapshot
                                                                .data!
                                                                .docs[index]
                                                                .get("size");
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return StatefulBuilder(
                                                                  builder: (BuildContext
                                                                          context,
                                                                      setState) {
                                                                    return Dialog(
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            680,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              15),
                                                                          child:
                                                                              Card(
                                                                            elevation:
                                                                                10,
                                                                            shadowColor:
                                                                                Colors.black,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
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
                                                                                          itemCount: snapshot.data!.docs[index].get("size").length,
                                                                                          shrinkWrap: true,
                                                                                          physics: ClampingScrollPhysics(),
                                                                                          itemBuilder: (context, index1) {
                                                                                            return HblViewWidget(
                                                                                              hbl: snapshot.data!.docs[index].get("size")[index1],
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
                                                            Icons
                                                                .remove_red_eye_rounded,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      width: 50,
                                                      child: Center(
                                                        child: CustomText(
                                                          text: snapshot
                                                              .data!.docs[index]
                                                              .get("size")[0],
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                            DataCell(
                                              snapshot.data!.docs[index]
                                                          .get("vol")
                                                          .length >
                                                      1
                                                  ? Container(
                                                      width: 50,
                                                      child: Center(
                                                        child: IconButton(
                                                          onPressed: () {
                                                            final x = snapshot
                                                                .data!
                                                                .docs[index]
                                                                .get("vol");
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return StatefulBuilder(
                                                                  builder: (BuildContext
                                                                          context,
                                                                      setState) {
                                                                    return Dialog(
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            680,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              15),
                                                                          child:
                                                                              Card(
                                                                            elevation:
                                                                                10,
                                                                            shadowColor:
                                                                                Colors.black,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
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
                                                                                          itemCount: snapshot.data!.docs[index].get("vol").length,
                                                                                          shrinkWrap: true,
                                                                                          physics: ClampingScrollPhysics(),
                                                                                          itemBuilder: (context, index1) {
                                                                                            return HblViewWidget(
                                                                                              hbl: snapshot.data!.docs[index].get("vol")[index1],
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
                                                            Icons
                                                                .remove_red_eye_rounded,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      width: 50,
                                                      child: Center(
                                                        child: CustomText(
                                                          text: snapshot
                                                              .data!.docs[index]
                                                              .get("vol")[0],
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                            DataCell(
                                              Container(
                                                width: 150,
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CustomText(
                                                        text: snapshot
                                                            .data!.docs[index]
                                                            .get("pol"),
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return StatefulBuilder(
                                                                builder: (BuildContext
                                                                        context,
                                                                    setState12) {
                                                                  return Dialog(
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          680,
                                                                      child:
                                                                          SingleChildScrollView(
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              15),
                                                                          child:
                                                                              Card(
                                                                            elevation:
                                                                                10,
                                                                            shadowColor:
                                                                                Colors.black,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  TextButton(
                                                                                    onPressed: () async {
                                                                                      _editPol.text = await showDialog(
                                                                                        context: context,
                                                                                        builder: (BuildContext cxt) {
                                                                                          return CountryPredictionWidget();
                                                                                        },
                                                                                      );

                                                                                      setState12(() {});
                                                                                    },
                                                                                    child: Card(
                                                                                      elevation: 10,
                                                                                      shadowColor: Colors.black,
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                      ),
                                                                                      child: Container(
                                                                                        height: 60,
                                                                                        child: Center(
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [
                                                                                              Text(
                                                                                                snapshot.data!.docs[index].get("pol"),
                                                                                                style: GoogleFonts.lato(
                                                                                                  fontSize: 20.0,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  color: Colors.grey,
                                                                                                ),
                                                                                              ),
                                                                                            ],
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
                                                                                      showDialog(
                                                                                        context: context,
                                                                                        builder: (BuildContext context) => ProgressWidget(
                                                                                          msg: "Please wait...",
                                                                                        ),
                                                                                      );

                                                                                      await monitoring.addMonitoring(
                                                                                        widget.name,
                                                                                        "Shipment mbl ${_mbl.text} New Pol  ${_editPol.text}",
                                                                                        "Update Pol Shipment",
                                                                                        DateTime.now(),
                                                                                      );
                                                                                      await shipment.updatePol(_editPol.text, snapshot.data!.docs[index].get("id"));

                                                                                      await new Future.delayed(
                                                                                        const Duration(seconds: 1),
                                                                                      );
                                                                                      Navigator.pop(context);
                                                                                      Navigator.pop(context);
                                                                                      setState(() {});
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
                                                                                        child: Text("Update Pol"),
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
                                                            Icons.edit,
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
                                                width: 150,
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CustomText(
                                                        text: snapshot
                                                            .data!.docs[index]
                                                            .get("pod"),
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return StatefulBuilder(
                                                                builder: (BuildContext
                                                                        context,
                                                                    setState12) {
                                                                  return Dialog(
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          680,
                                                                      child:
                                                                          SingleChildScrollView(
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              15),
                                                                          child:
                                                                              Card(
                                                                            elevation:
                                                                                10,
                                                                            shadowColor:
                                                                                Colors.black,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  TextButton(
                                                                                    onPressed: () async {
                                                                                      _editPod.text = await showDialog(
                                                                                        context: context,
                                                                                        builder: (BuildContext cxt) {
                                                                                          return CountryPredictionWidget();
                                                                                        },
                                                                                      );

                                                                                      setState12(() {});
                                                                                    },
                                                                                    child: Card(
                                                                                      elevation: 10,
                                                                                      shadowColor: Colors.black,
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                      ),
                                                                                      child: Container(
                                                                                        height: 60,
                                                                                        child: Center(
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [
                                                                                              Text(
                                                                                                snapshot.data!.docs[index].get("pod"),
                                                                                                style: GoogleFonts.lato(
                                                                                                  fontSize: 20.0,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  color: Colors.grey,
                                                                                                ),
                                                                                              ),
                                                                                            ],
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
                                                                                      showDialog(
                                                                                        context: context,
                                                                                        builder: (BuildContext context) => ProgressWidget(
                                                                                          msg: "Please wait...",
                                                                                        ),
                                                                                      );

                                                                                      await monitoring.addMonitoring(
                                                                                        widget.name,
                                                                                        "Shipment mbl ${_mbl.text} New Pod  ${_editPod.text}",
                                                                                        "Update Pod Shipment",
                                                                                        DateTime.now(),
                                                                                      );
                                                                                      await shipment.updatePod(_editPod.text, snapshot.data!.docs[index].get("id"));

                                                                                      await new Future.delayed(
                                                                                        const Duration(seconds: 1),
                                                                                      );
                                                                                      Navigator.pop(context);
                                                                                      Navigator.pop(context);
                                                                                      setState(() {});
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
                                                                                        child: Text("Update Pod"),
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
                                                            Icons.edit,
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
                                                width: 150,
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CustomText(
                                                        text: snapshot
                                                            .data!.docs[index]
                                                            .get("comment"),
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return StatefulBuilder(
                                                                builder: (BuildContext
                                                                        context,
                                                                    setState12) {
                                                                  return Dialog(
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          680,
                                                                      child:
                                                                          SingleChildScrollView(
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              15),
                                                                          child:
                                                                              Card(
                                                                            elevation:
                                                                                10,
                                                                            shadowColor:
                                                                                Colors.black,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
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
                                                                                        padding: EdgeInsets.all(10),
                                                                                        child: TextField(
                                                                                          controller: _editComment,
                                                                                          maxLines: 5,
                                                                                          minLines: 1,
                                                                                          decoration: InputDecoration(
                                                                                            border: InputBorder.none,
                                                                                            hintText: snapshot.data!.docs[index].get("comment"),
                                                                                            icon: Icon(
                                                                                              Icons.comment,
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
                                                                                  ElevatedButton(
                                                                                    onPressed: () async {
                                                                                      showDialog(
                                                                                        context: context,
                                                                                        builder: (BuildContext context) => ProgressWidget(
                                                                                          msg: "Please wait...",
                                                                                        ),
                                                                                      );
                                                                                      await monitoring.addMonitoring(
                                                                                        widget.name,
                                                                                        "Shipment mbl ${_mbl.text} New Comment  ${_editComment.text}",
                                                                                        "Update Comment Shipment",
                                                                                        DateTime.now(),
                                                                                      );
                                                                                      await shipment.updateComment(_editComment.text, snapshot.data!.docs[index].get("id"));

                                                                                      await new Future.delayed(
                                                                                        const Duration(seconds: 1),
                                                                                      );
                                                                                      Navigator.pop(context);
                                                                                      Navigator.pop(context);
                                                                                      setState(() {});
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
                                                                                        child: Text("Update Comment"),
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
                                                            Icons.edit,
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
                                                width: 150,
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CustomText(
                                                        text: snapshot
                                                            .data!.docs[index]
                                                            .get("shipingLine"),
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return StatefulBuilder(
                                                                builder: (BuildContext
                                                                        context,
                                                                    setState12) {
                                                                  return Dialog(
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          680,
                                                                      child:
                                                                          SingleChildScrollView(
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              15),
                                                                          child:
                                                                              Card(
                                                                            elevation:
                                                                                10,
                                                                            shadowColor:
                                                                                Colors.black,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  TextButton(
                                                                                    onPressed: () async {
                                                                                      _editSealine.text = await showDialog(
                                                                                        context: context,
                                                                                        builder: (BuildContext cxt) {
                                                                                          return SealinePredictionWidget();
                                                                                        },
                                                                                      );

                                                                                      setState12(() {});
                                                                                    },
                                                                                    child: Card(
                                                                                      elevation: 10,
                                                                                      shadowColor: Colors.black,
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                      ),
                                                                                      child: Container(
                                                                                        height: 60,
                                                                                        child: Center(
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [
                                                                                              Text(
                                                                                                snapshot.data!.docs[index].get("shipingLine"),
                                                                                                style: GoogleFonts.lato(
                                                                                                  fontSize: 20.0,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  color: Colors.grey,
                                                                                                ),
                                                                                              ),
                                                                                            ],
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
                                                                                      showDialog(
                                                                                        context: context,
                                                                                        builder: (BuildContext context) => ProgressWidget(
                                                                                          msg: "Please wait...",
                                                                                        ),
                                                                                      );
                                                                                      await monitoring.addMonitoring(
                                                                                        widget.name,
                                                                                        "Shipment mbl ${_mbl.text} New Sea Line  ${_editSealine.text}",
                                                                                        "Update Sea Line Shipment",
                                                                                        DateTime.now(),
                                                                                      );
                                                                                      await shipment.updateSealine(_editSealine.text, snapshot.data!.docs[index].get("id"));

                                                                                      await new Future.delayed(
                                                                                        const Duration(seconds: 1),
                                                                                      );
                                                                                      Navigator.pop(context);
                                                                                      Navigator.pop(context);
                                                                                      setState(() {});
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
                                                                                        child: Text("Update Shiping Line"),
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
                                                            Icons.edit,
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
                                                width: 150,
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CustomText(
                                                        text: snapshot
                                                            .data!.docs[index]
                                                            .get("agentName"),
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return StatefulBuilder(
                                                                builder: (BuildContext
                                                                        context,
                                                                    setState123) {
                                                                  return Dialog(
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          680,
                                                                      child:
                                                                          SingleChildScrollView(
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              15),
                                                                          child:
                                                                              Card(
                                                                            elevation:
                                                                                10,
                                                                            shadowColor:
                                                                                Colors.black,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
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
                                                                                          controller: _agentName,
                                                                                          decoration: InputDecoration(
                                                                                            border: InputBorder.none,
                                                                                            hintText: snapshot.data!.docs[index].get("agentName"),
                                                                                            icon: Icon(
                                                                                              Icons.support_agent_rounded,
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
                                                                                  ElevatedButton(
                                                                                    onPressed: () async {
                                                                                      showDialog(
                                                                                        context: context,
                                                                                        builder: (BuildContext context) => ProgressWidget(
                                                                                          msg: "Please wait...",
                                                                                        ),
                                                                                      );

                                                                                      await monitoring.addMonitoring(
                                                                                        widget.name,
                                                                                        "Shipment mbl ${_mbl.text} New Agent Name  ${_agentName.text}",
                                                                                        "Update Agent Name Shipment",
                                                                                        DateTime.now(),
                                                                                      );
                                                                                      await shipment.updateAgentName(_agentName.text, snapshot.data!.docs[index].get("id"));

                                                                                      await new Future.delayed(
                                                                                        const Duration(seconds: 1),
                                                                                      );
                                                                                      Navigator.pop(context);
                                                                                      Navigator.pop(context);
                                                                                      setState(() {});
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
                                                                                        child: Text("Update Agent Name"),
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
                                                            Icons.edit,
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
                                                width: 150,
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CustomText(
                                                        text: snapshot
                                                            .data!.docs[index]
                                                            .get("agentCode"),
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return StatefulBuilder(
                                                                builder: (BuildContext
                                                                        context,
                                                                    setState123) {
                                                                  return Dialog(
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          680,
                                                                      child:
                                                                          SingleChildScrollView(
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              15),
                                                                          child:
                                                                              Card(
                                                                            elevation:
                                                                                10,
                                                                            shadowColor:
                                                                                Colors.black,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
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
                                                                                          controller: _agentCode,
                                                                                          decoration: InputDecoration(
                                                                                            border: InputBorder.none,
                                                                                            hintText: snapshot.data!.docs[index].get("agentCode"),
                                                                                            icon: Icon(
                                                                                              Icons.code,
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
                                                                                  ElevatedButton(
                                                                                    onPressed: () async {
                                                                                      showDialog(
                                                                                        context: context,
                                                                                        builder: (BuildContext context) => ProgressWidget(
                                                                                          msg: "Please wait...",
                                                                                        ),
                                                                                      );

                                                                                      await monitoring.addMonitoring(
                                                                                        widget.name,
                                                                                        "Shipment mbl ${_mbl.text} New Agent Code  ${_agentCode.text}",
                                                                                        "Update Agent Code Shipment",
                                                                                        DateTime.now(),
                                                                                      );
                                                                                      await shipment.updateAgentCode(_agentCode.text, snapshot.data!.docs[index].get("id"));

                                                                                      await new Future.delayed(
                                                                                        const Duration(seconds: 1),
                                                                                      );
                                                                                      Navigator.pop(context);
                                                                                      Navigator.pop(context);
                                                                                      setState(() {});
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
                                                                                        child: Text("Update Agent Code"),
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
                                                            Icons.edit,
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
                                                width: 100,
                                                child: Center(
                                                  child: Text(snapshot
                                                      .data!.docs[index]
                                                      .get("loading")),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Container(
                                                width: 100,
                                                child: Center(
                                                  child: Text(snapshot
                                                      .data!.docs[index]
                                                      .get("arrival")),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Container(
                                                width: 100,
                                                child: Center(
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      var dialog = AlertDialog(
                                                        title: Text("Alert"),
                                                        content: Text(
                                                            "Are you sure you want to Remove this information ?"),
                                                        actionsAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        actions: [
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                await monitoring
                                                                    .addMonitoring(
                                                                  widget.name,
                                                                  "Shipment mbl ${snapshot.data!.docs[index].get("mbl")} ",
                                                                  "Delete Shipment",
                                                                  DateTime
                                                                      .now(),
                                                                );
                                                                await shipment
                                                                    .delete(snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .get(
                                                                            "id"));
                                                                Navigator.pop(
                                                                    context);
                                                                setState(() {});
                                                              },
                                                              child: Text(
                                                                  "Yes ,Remove it")),
                                                        ],
                                                      );
                                                      showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext cxt) {
                                                          return dialog;
                                                        },
                                                      );
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.red[700],
                                                      elevation: 10,
                                                      shadowColor: Colors.black,
                                                    ),
                                                    child: Icon(
                                                      Icons.delete,
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
                            ),
                          ),
                        ),
                      );
                    }
                }
              },
            ),
          ],
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

  void onDelete(
      TextEditingController _value, dynamic setStateDia, dynamic controller) {
    setStateDia(() {
      if (controller == 'hbl') {
        var find = hbls.firstWhere(
          (it) => it.hbl == _value,
          // ignore: null_check_always_fails
          orElse: () => null!,
        );
        // ignore: unnecessary_null_comparison
        if (find != null)
          hbls.removeAt(
            hbls.indexOf(find),
          );
      } else {
        var find = containers.firstWhere(
          (it) => it.containerContro == _value,
          // ignore: null_check_always_fails
          orElse: () => null!,
        );
        // ignore: unnecessary_null_comparison
        if (find != null)
          containers.removeAt(
            containers.indexOf(find),
          );
      }
    });
  }

  void onAddForm(dynamic setStateDia, dynamic con) {
    setStateDia(() {
      var _value = TextEditingController();
      if (con == 'hbl') {
        hbls.add(AddHblWidget(
          hbl: _value,
          onDelete: () => onDelete(_value, setStateDia, con),
        ));
      } else {
        containers.add(ContainerFormWidget(
          containerContro: _value,
          onDelete: () => onDelete(_value, setStateDia, con),
        ));
      }
    });
  }

  void onAddMain(dynamic setStateDia) {
    setStateDia(() {
      var _value = FormModel();

      mainForm.add(AddFormWidget(
        form: _value,
        onDelete: () => onDeleteMain(_value, setStateDia),
      ));
    });
  }

  void onDeleteMain(FormModel _value, dynamic setStateDia) {
    setStateDia(() {
      var find = mainForm.firstWhere(
        (it) => it.form == _value,
        // ignore: null_check_always_fails
        orElse: () => null!,
      );
      // ignore: unnecessary_null_comparison
      if (find != null)
        mainForm.removeAt(
          mainForm.indexOf(find),
        );
    });
  }

  void onSave() {
    containers.forEach((element) {
      _conInfo!.add(element.containerContro!.text);
    });
    mainForm.forEach((element) {
      _sizeInfo!.add(element.form.size!);
      _volInfo!.add(element.form.vol!);
      _conInfo!.add(element.form.container!);
      element.form.views.forEach((element2) {
        _conInfo!.add(element2.containerContro!.text);
      });
    });

    hbls.forEach((element) {
      _hblInfo!.add(element.hbl!.text);
    });

    _hblInfo!.insert(0, _hbl.text);

    _sizeInfo!.insert(0, title2);

    _volInfo!.insert(0, _vol.text);

    _conInfo!.insert(0, containerNumber.text);
  }

  List<DataColumn2> getColumns(List<String> columns) => columns
      .map(
        (String column) => DataColumn2(
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
