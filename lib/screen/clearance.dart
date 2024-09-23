import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sap/model/clearance.dart';
import 'package:sap/provider/clearance.dart';
import '../helper/screen_navigation.dart';
import '../provider/monitoring.dart';
import '../provider/user.dart';
import '../widget/custom_text.dart';
import 'edit_clearance_profile.dart';
import 'home.dart';
import 'search_clearance.dart';

class ClearanceScreen extends StatefulWidget {
  ClearanceScreen({Key? key}) : super(key: key);

  @override
  State<ClearanceScreen> createState() => _ClearanceScreenState();
}

class _ClearanceScreenState extends State<ClearanceScreen> {
  TextEditingController searchText = TextEditingController();
  ScrollController scollBarController = ScrollController();
  TextEditingController _name = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _fax = TextEditingController();
  TextEditingController _tel = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _code = TextEditingController();
  TextEditingController _pic = TextEditingController();

  final columns = [
    'Name',
    'Address',
    'Tel',
    'Fax',
    'Phone',
    'Email',
    'Code',
    'Pic',
  ];

  Offset offset = Offset(40, 20);
  bool see = false;
  OverlayEntry? entry;

  void hideOverLay() {
    entry?.remove();
    entry = null;
  }

  List<String> searchItems = [
    'Name',
    'Address',
    'Tel',
    'Fax',
    'Phone',
    'Email',
    'Code',
    'Pic',
  ];

  void overlay() {
    entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(context).size.height * 0.22,
          right: MediaQuery.of(context).size.width * 0.235,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              color: Colors.black,
              height: 100,
              width: 200,
              child: ListView(
                children: searchItems.map(
                  (e) {
                    return GestureDetector(
                      onTap: () {
                        if (e == "Name") {
                          Provider.of<ClearanceProvider>(context, listen: false)
                              .changeSearchBy(newSearchBy: SearchBy.NAME);
                        } else if (e == "Email") {
                          Provider.of<ClearanceProvider>(context, listen: false)
                              .changeSearchBy(newSearchBy: SearchBy.EMAIL);
                        } else if (e == "Phone") {
                          Provider.of<ClearanceProvider>(context, listen: false)
                              .changeSearchBy(newSearchBy: SearchBy.PHONE);
                        } else if (e == "Code") {
                          Provider.of<ClearanceProvider>(context, listen: false)
                              .changeSearchBy(newSearchBy: SearchBy.CODE);
                        } else if (e == "Fax") {
                          Provider.of<ClearanceProvider>(context, listen: false)
                              .changeSearchBy(newSearchBy: SearchBy.FAX);
                        } else if (e == "Tel") {
                          Provider.of<ClearanceProvider>(context, listen: false)
                              .changeSearchBy(newSearchBy: SearchBy.TEL);
                        } else if (e == "Address") {
                          Provider.of<ClearanceProvider>(context, listen: false)
                              .changeSearchBy(newSearchBy: SearchBy.ADDRESS);
                        } else {
                          Provider.of<ClearanceProvider>(context, listen: false)
                              .changeSearchBy(newSearchBy: SearchBy.PIC);
                        }
                        setState(() {
                          hideOverLay();
                          see = !see;
                        });
                      },
                      child: Card(
                        color: Colors.transparent,
                        elevation: 10,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              e,
                              style: TextStyle(
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        );
      },
    );
    final overLay = Overlay.of(context);
    overLay.insert(entry!);
  }

  @override
  void dispose() {
    hideOverLay();
    super.dispose();
  }

  int? sortColumnIndex;
  bool isAscending = false;
  @override
  Widget build(BuildContext context) {
    final monitoring = Provider.of<MonitoringProvider>(context);
    final user = Provider.of<UserProvider>(context);
    final size = MediaQuery.of(context).size;
    final clearance = Provider.of<ClearanceProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Clearances"),
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
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.4,
                  child: Padding(
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
                          controller: searchText,
                          onFieldSubmitted: (pattern) async {
                            if (await clearance.searchHome(searchText.text)) {
                              hideOverLay();
                              see = !see;
                              changeScreen(context, SearchClearanceScreen());
                              return;
                            } else {
                              Fluttertoast.showToast(msg: "Wrong Info Insert");
                            }
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search",
                            icon: Icon(
                              Icons.search,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      if (!see) {
                        setState(() {
                          WidgetsBinding.instance
                              .addPostFrameCallback((timings) {
                            overlay();
                          });
                          see = !see;
                        });
                      } else {
                        setState(() {
                          hideOverLay();
                          see = !see;
                        });
                      }
                    },
                    child: Card(
                      elevation: 10,
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Icon(
                            Icons.filter_list_rounded,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                user.userModel.role != "user"
                    ? ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 150),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _name.text = "";

                                  _address.text = "";

                                  _fax.text = "";

                                  _tel.text = "";

                                  _phone.text = "";

                                  _email.text = "";

                                  _code.text = "";

                                  _pic.text = "";
                                  hideOverLay();
                                  see = !see;
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (BuildContext context,
                                            setStateDia) {
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
                                                                        .all(
                                                                            10),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      _name,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "Name",
                                                                    icon: Icon(
                                                                      Icons
                                                                          .person,
                                                                      size: 32,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
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
                                                                        .all(
                                                                            10),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      _email,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "Email",
                                                                    icon: Icon(
                                                                      Icons
                                                                          .email,
                                                                      size: 32,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
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
                                                                        .all(
                                                                            10),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      _phone,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "Phone",
                                                                    icon: Icon(
                                                                      Icons
                                                                          .phone,
                                                                      size: 32,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
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
                                                                        .all(
                                                                            10),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      _tel,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "Tel",
                                                                    icon: Icon(
                                                                      Icons
                                                                          .phone_enabled_rounded,
                                                                      size: 32,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
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
                                                                        .all(
                                                                            10),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      _fax,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "Fax",
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
                                                                        .all(
                                                                            10),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      _code,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "Code",
                                                                    icon: Icon(
                                                                      Icons
                                                                          .code,
                                                                      size: 32,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
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
                                                                        .all(
                                                                            10),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      _address,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "Address",
                                                                    icon: Icon(
                                                                      Icons
                                                                          .location_on_rounded,
                                                                      size: 32,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
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
                                                                        .all(
                                                                            10),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      _pic,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "PIC",
                                                                    icon: Icon(
                                                                      Icons
                                                                          .person_pin_circle_rounded,
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
                                                            constraints:
                                                                BoxConstraints(
                                                                    maxWidth:
                                                                        150),
                                                            child: Center(
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  clearance
                                                                      .checkEmail(
                                                                          _email
                                                                              .text);
                                                                  if (clearance
                                                                      .check) {
                                                                    await monitoring
                                                                        .addMonitoring(
                                                                      user.userModel
                                                                          .name,
                                                                      "Clearance name ${_name.text} and His Email ${_email.text}",
                                                                      "Add New Clearance",
                                                                      DateTime
                                                                          .now(),
                                                                    );
                                                                    await clearance
                                                                        .addClearance(
                                                                      user.userModel
                                                                          .name,
                                                                      _name
                                                                          .text,
                                                                      _address
                                                                          .text,
                                                                      _fax.text,
                                                                      _tel.text,
                                                                      _phone
                                                                          .text,
                                                                      _email
                                                                          .text,
                                                                      _code
                                                                          .text,
                                                                      _pic.text,
                                                                    );

                                                                    Navigator.pop(
                                                                        context);
                                                                    setState(
                                                                        () {});
                                                                  } else
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "Can't add clearance email in system");
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  foregroundColor:
                                                                      Colors
                                                                          .black,
                                                                  backgroundColor:
                                                                      Colors.orange[
                                                                          700],
                                                                  elevation: 3,
                                                                  shadowColor:
                                                                      Colors
                                                                          .orange,
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    "Add Clearance",
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
                                  elevation: 3,
                                  shadowColor: Colors.orange,
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
                      )
                    : Container(),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("clearance")
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
                      clearance.clearances = snapshot.data!.docs
                          .map((e) => ClearanceModel.fromSnapshot(e))
                          .toList();
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
                                      sortAscending: isAscending,
                                      sortColumnIndex: sortColumnIndex,
                                      columns: getColumns(columns),
                                      rows: List<DataRow>.generate(
                                        snapshot.data!.docs.length,
                                        (index) => DataRow(
                                          cells: [
                                            DataCell(
                                              GestureDetector(
                                                onTap: () async {
                                                  if (user.userModel.role !=
                                                      "user") {
                                                    await clearance
                                                        .getClearance(
                                                      snapshot.data!.docs[index]
                                                          .get("id"),
                                                    );
                                                    hideOverLay();
                                                    see = !see;
                                                    changeScreen(
                                                      context,
                                                      EditClearanceScreen(
                                                        name:
                                                            user.userModel.name,
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  width: 200,
                                                  child: Center(
                                                    child: CustomText(
                                                      text: snapshot
                                                          .data!.docs[index]
                                                          .get("name"),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              GestureDetector(
                                                onTap: () async {
                                                  if (user.userModel.role !=
                                                      "user") {
                                                    await clearance
                                                        .getClearance(
                                                      snapshot.data!.docs[index]
                                                          .get("id"),
                                                    );
                                                    hideOverLay();
                                                    see = !see;
                                                    changeScreen(
                                                      context,
                                                      EditClearanceScreen(
                                                        name:
                                                            user.userModel.name,
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  width: 200,
                                                  child: Center(
                                                    child: CustomText(
                                                      text: snapshot
                                                          .data!.docs[index]
                                                          .get("address"),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              GestureDetector(
                                                onTap: () async {
                                                  if (user.userModel.role !=
                                                      "user") {
                                                    await clearance
                                                        .getClearance(
                                                      snapshot.data!.docs[index]
                                                          .get("id"),
                                                    );
                                                    hideOverLay();
                                                    see = !see;
                                                    changeScreen(
                                                      context,
                                                      EditClearanceScreen(
                                                        name:
                                                            user.userModel.name,
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  width: 200,
                                                  child: Center(
                                                    child: CustomText(
                                                      text: snapshot
                                                          .data!.docs[index]
                                                          .get("tel"),
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
                                                    text: snapshot
                                                        .data!.docs[index]
                                                        .get("fax"),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Container(
                                                width: 200,
                                                child: Center(
                                                  child: CustomText(
                                                    text: snapshot
                                                        .data!.docs[index]
                                                        .get("phone"),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Container(
                                                width: 200,
                                                child: Center(
                                                  child: CustomText(
                                                    text: snapshot
                                                        .data!.docs[index]
                                                        .get("email"),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Container(
                                                width: 200,
                                                child: Center(
                                                  child: CustomText(
                                                    text: snapshot
                                                        .data!.docs[index]
                                                        .get("code"),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Container(
                                                width: 200,
                                                child: Center(
                                                  child: CustomText(
                                                    text: snapshot
                                                        .data!.docs[index]
                                                        .get("pic"),
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
            )
          ],
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
