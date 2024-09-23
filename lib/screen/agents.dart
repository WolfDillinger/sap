import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sap/model/agent.dart';
import 'package:sap/provider/user.dart';
import 'package:sap/screen/home.dart';
import '../provider/agent.dart';
import '../helper/screen_navigation.dart';
import '../provider/shipment.dart';
import '../style/custom_text.dart';
import 'agent_profile.dart';
import 'search_agent.dart';

class AgentsScreen extends StatefulWidget {
  final String name;
  AgentsScreen({Key? key, required this.name}) : super(key: key);

  @override
  State<AgentsScreen> createState() => _AgentsScreenState();
}

class _AgentsScreenState extends State<AgentsScreen> {
  TextEditingController searchText = TextEditingController();
  ScrollController scollBarController = ScrollController();
  TextEditingController _agentAddress = TextEditingController();
  TextEditingController _agentEmail = TextEditingController();
  TextEditingController _agentFax = TextEditingController();
  TextEditingController _agentFinancialEmail = TextEditingController();
  TextEditingController _agentFinancialPicName = TextEditingController();
  TextEditingController _agentCode = TextEditingController();
  TextEditingController _agentName = TextEditingController();
  TextEditingController _agentOperationEmail = TextEditingController();
  TextEditingController _agentOperationPicName = TextEditingController();
  TextEditingController _agentPhone = TextEditingController();
  TextEditingController _agentTel = TextEditingController();

  final columns = [
    "Name",
    "Address",
    'Tel',
    'Phone',
    'Email',
    'Operation Email',
    'Pic Name',
    'Operation Email',
    'Pic Name',
    'Agent Code',
  ];

  Offset offset = Offset(40, 20);
  bool see = false;
  OverlayEntry? entry;

  void hideOverLay() {
    entry?.remove();
    entry = null;
  }

  List<String> searchItems = [
    "Name",
    "Address",
    'Tel',
    'Phone',
    'Email',
    'Operation Email',
    'Operation Pic Name',
    'Financial Email',
    'Financial Pic Name',
    'Agent Code',
  ];

  void overlay() {
    entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(context).size.height * 0.22,
          right: MediaQuery.of(context).size.width * 0.25,
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
                          Provider.of<AgentProvider>(context, listen: false)
                              .changeSearchBy(newSearchBy: SearchBy.NAME);
                        } else if (e == "Email") {
                          Provider.of<AgentProvider>(context, listen: false)
                              .changeSearchBy(newSearchBy: SearchBy.EMAIL);
                        } else if (e == "Phone") {
                          Provider.of<AgentProvider>(context, listen: false)
                              .changeSearchBy(newSearchBy: SearchBy.PHONE);
                        } else if (e == "Address") {
                          Provider.of<AgentProvider>(context, listen: false)
                              .changeSearchBy(newSearchBy: SearchBy.ADDRESS);
                        } else if (e == "Tel") {
                          Provider.of<AgentProvider>(context, listen: false)
                              .changeSearchBy(newSearchBy: SearchBy.TEL);
                        } else if (e == "Operation Email") {
                          Provider.of<AgentProvider>(context, listen: false)
                              .changeSearchBy(
                                  newSearchBy: SearchBy.OPERATIONEMAIL);
                        } else if (e == "Operation Pic Name") {
                          Provider.of<AgentProvider>(context, listen: false)
                              .changeSearchBy(
                                  newSearchBy: SearchBy.OPERATIONPICNAME);
                        } else if (e == "Financial Email") {
                          Provider.of<AgentProvider>(context, listen: false)
                              .changeSearchBy(
                                  newSearchBy: SearchBy.FINANCIALEMAIL);
                        } else if (e == "Financial Pic Name") {
                          Provider.of<AgentProvider>(context, listen: false)
                              .changeSearchBy(
                                  newSearchBy: SearchBy.FINANCIALPICNAME);
                        } else if (e == "Agent Code") {
                          Provider.of<AgentProvider>(context, listen: false)
                              .changeSearchBy(newSearchBy: SearchBy.AGENTCODE);
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

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final size = MediaQuery.of(context).size;
    final agent = Provider.of<AgentProvider>(context);
    final shipment = Provider.of<ShipmentProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Agents"),
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
                            if (await agent.searchHome(searchText.text)) {
                              hideOverLay();
                              see = !see;
                              changeScreen(
                                  context,
                                  SearchAgentScreen(
                                    name: widget.name,
                                  ));
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
                                  _agentAddress.text = "";
                                  _agentEmail.text = "";
                                  _agentFax.text = "";
                                  _agentFinancialEmail.text = "";
                                  _agentFinancialPicName.text = "";
                                  _agentCode.text = "";
                                  _agentName.text = "";
                                  _agentOperationEmail.text = "";
                                  _agentOperationPicName.text = "";
                                  _agentPhone.text = "";
                                  _agentTel.text = "";
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
                                                                      _agentName,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "Agent Name",
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
                                                                      _agentEmail,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "Agent Email",
                                                                    icon: Icon(
                                                                      Icons
                                                                          .email_rounded,
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
                                                                      _agentPhone,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "Agent Phone",
                                                                    icon: Icon(
                                                                      Icons
                                                                          .phone_android_rounded,
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
                                                                      _agentTel,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "Tel",
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
                                                                      _agentAddress,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "Address",
                                                                    icon: Icon(
                                                                      Icons
                                                                          .location_on,
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
                                                                      _agentFax,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "Agent Fax",
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
                                                                      _agentFinancialEmail,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "Agent Finanacial Email",
                                                                    icon: Icon(
                                                                      Icons
                                                                          .email_rounded,
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
                                                                      _agentFinancialPicName,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "Agent Financial Pic Name",
                                                                    icon: Icon(
                                                                      Icons
                                                                          .person_outline_rounded,
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
                                                                      _agentOperationEmail,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "Agent Operation Email",
                                                                    icon: Icon(
                                                                      Icons
                                                                          .mail_outline_rounded,
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
                                                                      _agentOperationPicName,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "Agent Operation Pic Name",
                                                                    icon: Icon(
                                                                      Icons
                                                                          .person_pin,
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
                                                                      _agentCode,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "Agent Code",
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
                                                                  await agent.checkEmail(
                                                                      _agentEmail
                                                                          .text);
                                                                  if (agent
                                                                      .check) {
                                                                    await agent
                                                                        .addAgent(
                                                                      user.userModel
                                                                          .name,
                                                                      _agentAddress
                                                                          .text,
                                                                      _agentEmail
                                                                          .text,
                                                                      _agentFax
                                                                          .text,
                                                                      _agentFinancialEmail
                                                                          .text,
                                                                      _agentFinancialPicName
                                                                          .text,
                                                                      _agentName
                                                                          .text,
                                                                      _agentOperationEmail
                                                                          .text,
                                                                      _agentOperationPicName
                                                                          .text,
                                                                      _agentPhone
                                                                          .text,
                                                                      _agentTel
                                                                          .text,
                                                                      _agentCode
                                                                          .text,
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
                                                                    "Add Agent",
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
                  .collection("agents")
                  .orderBy("agentName", descending: true)
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
                      agent.agents = snapshot.data!.docs
                          .map((e) => AgentModel.fromSnapshot(e))
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
                                                    await agent.getAgent(
                                                      snapshot.data!.docs[index]
                                                          .get("id"),
                                                    );
                                                    await shipment
                                                        .getShipmentAgent(
                                                      snapshot.data!.docs[index]
                                                          .get("agentCode"),
                                                    );

                                                    hideOverLay();
                                                    see = !see;

                                                    changeScreen(
                                                      context,
                                                      AgentProfileScreen(
                                                        name: widget.name,
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  width: 100,
                                                  child: Center(
                                                    child: CustomText(
                                                      text: snapshot
                                                          .data!.docs[index]
                                                          .get("agentName"),
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
                                                    await agent.getAgent(
                                                      snapshot.data!.docs[index]
                                                          .get("id"),
                                                    );
                                                    await shipment
                                                        .getShipmentAgent(
                                                      snapshot.data!.docs[index]
                                                          .get("agentCode"),
                                                    );

                                                    hideOverLay();
                                                    see = !see;

                                                    changeScreen(
                                                      context,
                                                      AgentProfileScreen(
                                                        name: widget.name,
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  width: 150,
                                                  child: Center(
                                                    child: CustomText(
                                                      text: snapshot
                                                          .data!.docs[index]
                                                          .get("agentAddress"),
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
                                                    await agent.getAgent(
                                                      snapshot.data!.docs[index]
                                                          .get("id"),
                                                    );
                                                    await shipment
                                                        .getShipmentAgent(
                                                      snapshot.data!.docs[index]
                                                          .get("agentCode"),
                                                    );

                                                    hideOverLay();
                                                    see = !see;

                                                    changeScreen(
                                                      context,
                                                      AgentProfileScreen(
                                                        name: widget.name,
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  width: 100,
                                                  child: Center(
                                                    child: CustomText(
                                                      text: snapshot
                                                          .data!.docs[index]
                                                          .get("agentTel"),
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
                                                    text: snapshot
                                                        .data!.docs[index]
                                                        .get("agentPhone"),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Container(
                                                width: 150,
                                                child: Center(
                                                  child: CustomText(
                                                    text: snapshot
                                                        .data!.docs[index]
                                                        .get("agentEmail"),
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
                                                        .get(
                                                            "agentOperationEmail"),
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
                                                        .get(
                                                            "agentOperationPicName"),
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
                                                        .get(
                                                            "agentFinancialEmail"),
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
                                                        .get(
                                                            "agentFinancialPicName"),
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
                                                        .get("agentCode"),
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
}
