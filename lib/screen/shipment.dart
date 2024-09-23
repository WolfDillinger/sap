import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../helper/screen_navigation.dart';
import '../provider/shipment.dart';
import '../widget/custom_text.dart';
import '../widget/divider.dart';
import 'home.dart';
import 'search_shipment.dart';

class ShipmentScreen extends StatefulWidget {
  ShipmentScreen({Key? key}) : super(key: key);

  @override
  State<ShipmentScreen> createState() => _ShipmentScreenState();
}

class _ShipmentScreenState extends State<ShipmentScreen> {
  ScrollController scollBarController = ScrollController();
  TextEditingController searchText = TextEditingController();
  final columns = [
    "MBL",
    "HBL",
    'Container',
    'size',
    'Volume',
    'POL',
    'POD',
    'Shiping Line',
    'Agent Name',
    'Loading',
    'Arrival',
  ];
  Offset offset = Offset(40, 20);
  bool see = false;
  OverlayEntry? entry;

  void hideOverLay() {
    entry?.remove();
    entry = null;
  }

  List<String> searchItems = [
    "MBL",
    "HBL",
    'Container Number',
    'Volume',
    'POL',
    'POD',
    'Shiping Line',
    'Agent Name',
  ];

  void overlay() {
    entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(context).size.height * 0.22,
          right: MediaQuery.of(context).size.width * 0.22,
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
                        if (e == "MBL") {
                          Provider.of<ShipmentProvider>(context, listen: false)
                              .changeSearchBy(
                                  newSearchBy: SearchByShipment.MBL);
                        } else if (e == "HBL") {
                          Provider.of<ShipmentProvider>(context, listen: false)
                              .changeSearchBy(
                                  newSearchBy: SearchByShipment.HBL);
                        } else if (e == "Container Number") {
                          Provider.of<ShipmentProvider>(context, listen: false)
                              .changeSearchBy(
                                  newSearchBy:
                                      SearchByShipment.CONTAINERNYMBER);
                        } else if (e == "Volume") {
                          Provider.of<ShipmentProvider>(context, listen: false)
                              .changeSearchBy(
                                  newSearchBy: SearchByShipment.VOLUME);
                        } else if (e == "POL") {
                          Provider.of<ShipmentProvider>(context, listen: false)
                              .changeSearchBy(
                                  newSearchBy: SearchByShipment.POL);
                        } else if (e == "POD") {
                          Provider.of<ShipmentProvider>(context, listen: false)
                              .changeSearchBy(
                                  newSearchBy: SearchByShipment.POD);
                        } else if (e == 'Shiping Line') {
                          Provider.of<ShipmentProvider>(context, listen: false)
                              .changeSearchBy(
                                  newSearchBy: SearchByShipment.SHIPINGLINE);
                        } else if (e == "Agent Name") {
                          Provider.of<ShipmentProvider>(context, listen: false)
                              .changeSearchBy(
                                  newSearchBy: SearchByShipment.AGENTNAME);
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

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shipment = Provider.of<ShipmentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Shipment"),
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
                            if (await shipment.searchHome(searchText.text)) {
                              hideOverLay();
                              see = !see;
                              changeScreen(context, SearchShipmentScreen());
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
              ],
            ),
            SizedBox(
              height: 15,
            ),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("shipment").snapshots(),
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
                                                width: 200,
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
                                                        width: 5,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          hideOverLay();
                                                          see = !see;
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
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Container(
                                                width: 200,
                                                child: Center(
                                                  child: IconButton(
                                                    onPressed: () {
                                                      hideOverLay();
                                                      see = !see;
                                                      final x = snapshot
                                                          .data!.docs[index]
                                                          .get("hbl");

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
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons
                                                          .arrow_upward_rounded,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              snapshot.data!.docs[index]
                                                          .get("container")
                                                          .length >
                                                      1
                                                  ? Container(
                                                      width: 200,
                                                      child: Center(
                                                        child: IconButton(
                                                          onPressed: () {
                                                            hideOverLay();
                                                            see = !see;
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
                                                                .arrow_upward_rounded,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      width: 200,
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
                                                      width: 200,
                                                      child: Center(
                                                        child: IconButton(
                                                          onPressed: () {
                                                            hideOverLay();
                                                            see = !see;
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
                                                                .arrow_upward_rounded,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      width: 200,
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
                                                      width: 200,
                                                      child: Center(
                                                        child: IconButton(
                                                          onPressed: () {
                                                            hideOverLay();
                                                            see = !see;
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
                                                                .arrow_upward_rounded,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      width: 200,
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
                                                width: 200,
                                                child: Center(
                                                  child: CustomText(
                                                    text: snapshot
                                                        .data!.docs[index]
                                                        .get("pol"),
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
                                                        .get("pod"),
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
                                                        .get("shipingLine"),
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
                                                        .get("agentName"),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Container(
                                                width: 100,
                                                child: Center(
                                                  child: CustomText(
                                                    text: snapshot
                                                        .data!.docs[index]
                                                        .get("loading"),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Container(
                                                width: 100,
                                                child: Center(
                                                  child: CustomText(
                                                    text: snapshot
                                                        .data!.docs[index]
                                                        .get("arrival"),
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
