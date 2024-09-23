import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sap/model/client.dart';
import 'package:sap/provider/client.dart';
import 'package:sap/provider/monitoring.dart';
import 'package:sap/provider/user.dart';
import 'package:sap/screen/shipment.dart';
import '../helper/screen_navigation.dart';
import '../helper/shared_preferences_service.dart';
import '../provider/action.dart';
import '../widget/custom_text.dart';
import '../widget/progress.dart';
import 'agents.dart';
import 'clearance.dart';
import 'client_profile.dart';
import 'login.dart';
import 'monitoring.dart';
import 'notifiction.dart';
import 'search_client.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController scollBarController = ScrollController();
  TextEditingController searchText = TextEditingController();
  TextEditingController _ar = TextEditingController();
  TextEditingController _en = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _fax = TextEditingController();
  TextEditingController _clearanceCode = TextEditingController();
  TextEditingController _clearanceName = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _pic = TextEditingController();
  TextEditingController _taxId = TextEditingController();
  TextEditingController _tel = TextEditingController();

  final columns = [
    'Name Ar',
    'Name En',
    'Email',
    'Phone',
    'Pic',
    'Clearance',
    'Location',
    'Tax',
    'Action',
  ];
  int? sortColumnIndex;
  bool isAscending = false, vip = false;

  Offset offset = Offset(40, 20);
  bool see = false;
  OverlayEntry? entry;

  void hideOverLay() {
    entry?.remove();
    entry = null;
  }

  List<String> searchItems = [
    'Ar',
    'En',
    'Email',
    'Phone',
    'Pic',
    'Clearance Name',
    'Clearance Code',
    'Location',
    'Tax',
    'Fax',
  ];

  void overlay() {
    entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(context).size.height * 0.22,
          right: MediaQuery.of(context).size.width * 0.278,
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
                        if (e == "Ar") {
                          Provider.of<ClientProvider>(context, listen: false)
                              .changeSearchBy(newSearchBy: SearchBy.AR);
                        } else if (e == "En") {
                          Provider.of<ClientProvider>(context, listen: false)
                              .changeSearchBy(newSearchBy: SearchBy.EN);
                        } else if (e == "Email") {
                          Provider.of<ClientProvider>(context, listen: false)
                              .changeSearchBy(newSearchBy: SearchBy.EMAIL);
                        } else if (e == "Phone") {
                          Provider.of<ClientProvider>(context, listen: false)
                              .changeSearchBy(newSearchBy: SearchBy.PHONE);
                        } else if (e == "Pic") {
                          Provider.of<ClientProvider>(context, listen: false)
                              .changeSearchBy(newSearchBy: SearchBy.PIC);
                        } else if (e == "Clearance Name") {
                          Provider.of<ClientProvider>(context, listen: false)
                              .changeSearchBy(newSearchBy: SearchBy.NAME);
                        } else if (e == "Clearance Code") {
                          Provider.of<ClientProvider>(context, listen: false)
                              .changeSearchBy(newSearchBy: SearchBy.CODE);
                        } else if (e == "Location") {
                          Provider.of<ClientProvider>(context, listen: false)
                              .changeSearchBy(newSearchBy: SearchBy.LOCATION);
                        } else if (e == "Fax") {
                          Provider.of<ClientProvider>(context, listen: false)
                              .changeSearchBy(newSearchBy: SearchBy.FAX);
                        } else {
                          Provider.of<ClientProvider>(context, listen: false)
                              .changeSearchBy(newSearchBy: SearchBy.TAX);
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
    final client = Provider.of<ClientProvider>(context);
    final action = Provider.of<ActionProvider>(context);
    final size = MediaQuery.of(context).size;
    final monitoring = Provider.of<MonitoringProvider>(context);
    final PrefService _prefService = PrefService();
    return Scaffold(
      appBar: AppBar(
        title: Text("home".toUpperCase()),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () async {
              hideOverLay();
              see = false;
              changeScreen(
                context,
                NotificationScreen(
                  name: user.userModel.name,
                ),
              );
            },
            child: Card(
              color: Colors.grey[800],
              shadowColor: Colors.black,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: 50,
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: 25,
                      height: 20,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Center(
                              child: Text(
                                action.userActions.length.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        color: Colors.white,
                        Icons.notifications,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 25,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                image: new DecorationImage(
                  image: AssetImage("assets/DrowerBg.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              padding: EdgeInsets.all(0.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: 100,
                    height: 100,
                  ),
                  Text(
                    "Hi, " + user.userModel.name.toUpperCase(),
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 10,
                shadowColor: Colors.black,
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.amber,
                  ),
                  title: Text("Customer Page"),
                  onTap: () {
                    hideOverLay();
                    see = false;
                    changeScreen(context, HomeScreen());
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 10,
                shadowColor: Colors.black,
                child: ListTile(
                  leading: Icon(
                    Icons.person_outline_rounded,
                    color: Colors.amber,
                  ),
                  title: Text("Agents Page"),
                  onTap: () {
                    hideOverLay();
                    see = false;
                    changeScreen(
                      context,
                      AgentsScreen(
                        name: user.userModel.name,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 10,
                shadowColor: Colors.black,
                child: ListTile(
                  leading: Icon(
                    Icons.qr_code,
                    color: Colors.amber,
                  ),
                  title: Text("Clearance Page"),
                  onTap: () {
                    hideOverLay();
                    see = false;
                    changeScreen(context, ClearanceScreen());
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 10,
                shadowColor: Colors.black,
                child: ListTile(
                  leading: Icon(
                    Icons.directions_boat_rounded,
                    color: Colors.amber,
                  ),
                  title: Text("Shipment Page"),
                  onTap: () {
                    hideOverLay();
                    see = false;
                    changeScreen(context, ShipmentScreen());
                  },
                ),
              ),
            ),
            user.userModel.role == "owner"
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 10,
                      shadowColor: Colors.black,
                      child: ListTile(
                        leading: Icon(
                          Icons.monitor_rounded,
                          color: Colors.amber,
                        ),
                        title: Text("Monitoring Page"),
                        onTap: () {
                          hideOverLay();
                          see = false;
                          changeScreen(
                            context,
                            MonitoringScreen(),
                          );
                        },
                      ),
                    ),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 10,
                shadowColor: Colors.black,
                child: ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Colors.amber,
                  ),
                  title: Text("Logout"),
                  onTap: () {
                    var dialog = AlertDialog(
                      title: Text("Logout"),
                      content: Text("Are you sure you want to logout ?"),
                      actionsAlignment: MainAxisAlignment.spaceEvenly,
                      actions: [
                        TextButton(
                            onPressed: () {
                              hideOverLay();
                              see = false;
                              _prefService.removeCache();
                              user.signOut();
                              pushAndRemoveUntil(
                                context,
                                LoginScreen(),
                              );
                            },
                            child: Text("Yes ,Logout")),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancel")),
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
            ),
          ],
        ),
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
                            if (await client.searchHome(searchText.text)) {
                              hideOverLay();
                              see = false;
                              changeScreen(
                                  context,
                                  SearchClientScreen(
                                    name: user.userModel.name,
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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      vip = !vip;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 10,
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: !vip ? Colors.black : Colors.amber,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "VIP",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: !vip ? Colors.white : Colors.black,
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
                                  hideOverLay();
                                  see = false;
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
                                                                      _ar,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "CO Name AR",
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
                                                                      _en,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "CO Name En",
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
                                                                      _clearanceName,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "Clearance Name",
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
                                                                      _clearanceCode,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "Clearance Code",
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
                                                                      _location,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "Location",
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
                                                                      _taxId,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "Tax ID",
                                                                    icon: Icon(
                                                                      Icons
                                                                          .insert_drive_file,
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
                                                                  await client
                                                                      .checkEmail(
                                                                          _email
                                                                              .text);
                                                                  if (client
                                                                      .check) {
                                                                    await monitoring
                                                                        .addMonitoring(
                                                                      user.userModel
                                                                          .name,
                                                                      "add name ${_ar.text} and email ${_email.text}",
                                                                      "Add New Client",
                                                                      DateTime
                                                                          .now(),
                                                                    );
                                                                    await client.addNewClient(
                                                                        user.userModel
                                                                            .name,
                                                                        _ar
                                                                            .text,
                                                                        _en
                                                                            .text,
                                                                        _phone
                                                                            .text,
                                                                        _location
                                                                            .text,
                                                                        _taxId
                                                                            .text,
                                                                        _email
                                                                            .text,
                                                                        _pic
                                                                            .text,
                                                                        _clearanceName
                                                                            .text,
                                                                        _clearanceCode
                                                                            .text,
                                                                        _fax.text,
                                                                        _tel.text);

                                                                    _ar.text =
                                                                        "";
                                                                    _en.text =
                                                                        "";
                                                                    _phone.text =
                                                                        "";
                                                                    _location
                                                                        .text = "";
                                                                    _taxId.text =
                                                                        "";
                                                                    _email.text =
                                                                        "";
                                                                    _pic.text =
                                                                        "";
                                                                    _clearanceName
                                                                        .text = "";
                                                                    _clearanceCode
                                                                        .text = "";
                                                                    _fax.text =
                                                                        "";
                                                                    _tel.text =
                                                                        "";
                                                                    Navigator.pop(
                                                                        context);
                                                                    setState(
                                                                        () {});
                                                                  } else
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "Client in system check his email");
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
                                                                    "Add Client",
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
                SizedBox(
                  width: 50,
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            vip
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("clients")
                          .where(
                            "vip",
                            isEqualTo: true,
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
                            {
                              client.vips = snapshot.data!.docs
                                  .map((e) => ClientModel.fromSnapshot(e))
                                  .toList();
                              return Scrollbar(
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
                                              dataRowMinHeight: 100,
                                              dataTextStyle: TextStyle(
                                                color: Colors.orange,
                                              ),
                                              showBottomBorder: true,
                                              headingRowColor:
                                                  WidgetStateProperty.all<
                                                      Color>(
                                                Color.fromRGBO(0, 0, 0, 0),
                                              ),
                                              dataRowColor: WidgetStateProperty
                                                  .all<Color>(
                                                Color.fromRGBO(0, 0, 0, 0),
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.white,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
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
                                                          await client
                                                              .getClient(
                                                            snapshot.data!
                                                                .docs[index]
                                                                .get("id"),
                                                          );
                                                          hideOverLay();
                                                          see = false;
                                                          changeScreen(
                                                            context,
                                                            ClientProfile(
                                                              name: user
                                                                  .userModel
                                                                  .name,
                                                              id: snapshot.data!
                                                                  .docs[index]
                                                                  .get("id"),
                                                              clientName: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .get(
                                                                      "nameAr"),
                                                              clientEng: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .get(
                                                                      "nameEn"),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          width: 200,
                                                          child: Center(
                                                            child: CustomText(
                                                              text: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .get(
                                                                      "nameAr"),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      GestureDetector(
                                                        onTap: () async {
                                                          await client
                                                              .getClient(
                                                            snapshot.data!
                                                                .docs[index]
                                                                .get("id"),
                                                          );
                                                          hideOverLay();
                                                          see = false;
                                                          changeScreen(
                                                            context,
                                                            ClientProfile(
                                                              clientName: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .get(
                                                                      "nameAr"),
                                                              clientEng: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .get(
                                                                      "nameEn"),
                                                              name: user
                                                                  .userModel
                                                                  .name,
                                                              id: snapshot.data!
                                                                  .docs[index]
                                                                  .get("id"),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          width: 200,
                                                          child: Center(
                                                            child: CustomText(
                                                              text: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .get(
                                                                      "nameEn"),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      GestureDetector(
                                                        onTap: () async {
                                                          await client
                                                              .getClient(
                                                            snapshot.data!
                                                                .docs[index]
                                                                .get("id"),
                                                          );
                                                          hideOverLay();
                                                          see = false;
                                                          changeScreen(
                                                            context,
                                                            ClientProfile(
                                                              clientName: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .get(
                                                                      "nameAr"),
                                                              clientEng: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .get(
                                                                      "nameEn"),
                                                              name: user
                                                                  .userModel
                                                                  .name,
                                                              id: snapshot.data!
                                                                  .docs[index]
                                                                  .get("id"),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          width: 200,
                                                          child: Center(
                                                            child: CustomText(
                                                              text: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .get("email"),
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
                                                            text: snapshot.data!
                                                                .docs[index]
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
                                                            text: snapshot.data!
                                                                .docs[index]
                                                                .get("pic"),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                        width: 200,
                                                        child: Center(
                                                          child: CustomText(
                                                            text: snapshot.data!
                                                                .docs[index]
                                                                .get(
                                                                    "clearanceName"),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                        width: 200,
                                                        child: Center(
                                                          child: CustomText(
                                                            text: snapshot.data!
                                                                .docs[index]
                                                                .get(
                                                                    "location"),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                        width: 200,
                                                        child: Center(
                                                          child: CustomText(
                                                            text: snapshot.data!
                                                                .docs[index]
                                                                .get("taxId"),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                        width: 200,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            ElevatedButton(
                                                              onPressed: () {},
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors.green[
                                                                        700],
                                                                foregroundColor:
                                                                    Colors
                                                                        .black,
                                                                elevation: 10,
                                                                shadowColor:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                              child: Icon(
                                                                Icons.edit,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                var dialog =
                                                                    AlertDialog(
                                                                  title: Text(
                                                                      "Alert"),
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
                                                                            user.userModel.name,
                                                                            "client name ${snapshot.data!.docs[index].get("ar")} and email ${snapshot.data!.docs[index].get("email")}",
                                                                            "Delete Client",
                                                                            DateTime.now(),
                                                                          );
                                                                          await client
                                                                              .delete(
                                                                            snapshot.data!.docs[index].get("id"),
                                                                          );
                                                                          Navigator.pop(
                                                                              context);
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        child: Text(
                                                                            "Yes ,Remove it")),
                                                                  ],
                                                                );
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          cxt) {
                                                                    return dialog;
                                                                  },
                                                                );
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors.red[
                                                                        700],
                                                                foregroundColor:
                                                                    Colors
                                                                        .black,
                                                                elevation: 10,
                                                                shadowColor:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                              child: Icon(
                                                                Icons.delete,
                                                              ),
                                                            ),
                                                          ],
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
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("clients")
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
                              client.clients = snapshot.data!.docs
                                  .map((e) => ClientModel.fromSnapshot(e))
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
                                              dataRowMinHeight: 100,
                                              dataTextStyle: TextStyle(
                                                color: Colors.orange,
                                              ),
                                              showBottomBorder: true,
                                              headingRowColor:
                                                  WidgetStateProperty.all<
                                                      Color>(
                                                Color.fromRGBO(0, 0, 0, 0),
                                              ),
                                              dataRowColor: WidgetStateProperty
                                                  .all<Color>(
                                                Color.fromRGBO(0, 0, 0, 0),
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.white,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              columns: getColumns(columns),
                                              rows: List<DataRow>.generate(
                                                snapshot.data!.docs.length,
                                                (index) => DataRow(
                                                  cells: [
                                                    DataCell(
                                                      GestureDetector(
                                                        onTap: () async {
                                                          await client
                                                              .getClient(
                                                            snapshot.data!
                                                                .docs[index]
                                                                .get("id"),
                                                          );
                                                          hideOverLay();
                                                          see = false;
                                                          changeScreen(
                                                            context,
                                                            ClientProfile(
                                                              clientName: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .get(
                                                                      "nameAr"),
                                                              clientEng: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .get(
                                                                      "nameEn"),
                                                              name: user
                                                                  .userModel
                                                                  .name,
                                                              id: snapshot.data!
                                                                  .docs[index]
                                                                  .get("id"),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          width: 200,
                                                          child: Center(
                                                            child: CustomText(
                                                              text: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .get(
                                                                      "nameAr"),
                                                              align:
                                                                  TextAlign.end,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                        width: 200,
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            await client
                                                                .getClient(
                                                              snapshot.data!
                                                                  .docs[index]
                                                                  .get("id"),
                                                            );
                                                            hideOverLay();
                                                            see = false;
                                                            changeScreen(
                                                              context,
                                                              ClientProfile(
                                                                clientName: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                    .get(
                                                                        "nameAr"),
                                                                clientEng: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                    .get(
                                                                        "nameEn"),
                                                                name: user
                                                                    .userModel
                                                                    .name,
                                                                id: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                    .get("id"),
                                                              ),
                                                            );
                                                          },
                                                          child: Container(
                                                            width: 200,
                                                            child: Center(
                                                              child: CustomText(
                                                                text: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                    .get(
                                                                        "nameEn"),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      GestureDetector(
                                                        onTap: () async {
                                                          await client
                                                              .getClient(
                                                            snapshot.data!
                                                                .docs[index]
                                                                .get("id"),
                                                          );
                                                          hideOverLay();
                                                          see = false;
                                                          changeScreen(
                                                            context,
                                                            ClientProfile(
                                                              clientName: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .get(
                                                                      "nameAr"),
                                                              clientEng: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .get(
                                                                      "nameEn"),
                                                              name: user
                                                                  .userModel
                                                                  .name,
                                                              id: snapshot.data!
                                                                  .docs[index]
                                                                  .get("id"),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          width: 200,
                                                          child: Center(
                                                            child: CustomText(
                                                              text: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .get("email"),
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
                                                            text: snapshot.data!
                                                                .docs[index]
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
                                                            text: snapshot.data!
                                                                .docs[index]
                                                                .get("pic"),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                        width: 200,
                                                        child: Center(
                                                          child: CustomText(
                                                            text: snapshot.data!
                                                                .docs[index]
                                                                .get(
                                                                    "clearanceName"),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                        width: 200,
                                                        child: Center(
                                                          child: CustomText(
                                                            text: snapshot.data!
                                                                .docs[index]
                                                                .get(
                                                                    "location"),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                        width: 200,
                                                        child: Center(
                                                          child: CustomText(
                                                            text: snapshot.data!
                                                                .docs[index]
                                                                .get("taxId"),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                        width: 200,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return StatefulBuilder(
                                                                      builder: (BuildContext
                                                                              context,
                                                                          setStateDia) {
                                                                        return Dialog(
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                680,
                                                                            child:
                                                                                SingleChildScrollView(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(15),
                                                                                child: Card(
                                                                                  elevation: 10,
                                                                                  shadowColor: Colors.black,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Column(
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
                                                                                              child: TextFormField(
                                                                                                controller: _ar,
                                                                                                decoration: InputDecoration(
                                                                                                  border: InputBorder.none,
                                                                                                  hintText: snapshot.data!.docs[index].get("nameAr"),
                                                                                                  icon: Icon(
                                                                                                    Icons.person,
                                                                                                    size: 32,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
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
                                                                                              child: TextFormField(
                                                                                                controller: _en,
                                                                                                decoration: InputDecoration(
                                                                                                  border: InputBorder.none,
                                                                                                  hintText: snapshot.data!.docs[index].get("nameEn"),
                                                                                                  icon: Icon(
                                                                                                    Icons.person,
                                                                                                    size: 32,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
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
                                                                                              child: TextFormField(
                                                                                                controller: _email,
                                                                                                decoration: InputDecoration(
                                                                                                  border: InputBorder.none,
                                                                                                  hintText: snapshot.data!.docs[index].get("email"),
                                                                                                  icon: Icon(
                                                                                                    Icons.email,
                                                                                                    size: 32,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
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
                                                                                              child: TextFormField(
                                                                                                controller: _phone,
                                                                                                decoration: InputDecoration(
                                                                                                  border: InputBorder.none,
                                                                                                  hintText: snapshot.data!.docs[index].get("phone"),
                                                                                                  icon: Icon(
                                                                                                    Icons.phone_android,
                                                                                                    size: 32,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
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
                                                                                              child: TextFormField(
                                                                                                controller: _tel,
                                                                                                decoration: InputDecoration(
                                                                                                  border: InputBorder.none,
                                                                                                  hintText: snapshot.data!.docs[index].get("tel"),
                                                                                                  icon: Icon(
                                                                                                    Icons.phone,
                                                                                                    size: 32,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
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
                                                                                              child: TextFormField(
                                                                                                controller: _fax,
                                                                                                decoration: InputDecoration(
                                                                                                  border: InputBorder.none,
                                                                                                  hintText: snapshot.data!.docs[index].get("fax"),
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
                                                                                          padding: const EdgeInsets.all(10.0),
                                                                                          child: Card(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                            ),
                                                                                            elevation: 10,
                                                                                            shadowColor: Colors.black,
                                                                                            child: Padding(
                                                                                              padding: EdgeInsets.all(10),
                                                                                              child: TextFormField(
                                                                                                controller: _clearanceName,
                                                                                                decoration: InputDecoration(
                                                                                                  border: InputBorder.none,
                                                                                                  hintText: snapshot.data!.docs[index].get("clearanceName"),
                                                                                                  icon: Icon(
                                                                                                    Icons.person,
                                                                                                    size: 32,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
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
                                                                                              child: TextFormField(
                                                                                                controller: _clearanceCode,
                                                                                                decoration: InputDecoration(
                                                                                                  border: InputBorder.none,
                                                                                                  hintText: snapshot.data!.docs[index].get("clearanceCode"),
                                                                                                  icon: Icon(
                                                                                                    Icons.code,
                                                                                                    size: 32,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
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
                                                                                              child: TextFormField(
                                                                                                controller: _location,
                                                                                                decoration: InputDecoration(
                                                                                                  border: InputBorder.none,
                                                                                                  hintText: snapshot.data!.docs[index].get("location"),
                                                                                                  icon: Icon(
                                                                                                    Icons.location_on_rounded,
                                                                                                    size: 32,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
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
                                                                                              child: TextFormField(
                                                                                                controller: _pic,
                                                                                                decoration: InputDecoration(
                                                                                                  border: InputBorder.none,
                                                                                                  hintText: snapshot.data!.docs[index].get("pic"),
                                                                                                  icon: Icon(
                                                                                                    Icons.person_outline_rounded,
                                                                                                    size: 32,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
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
                                                                                              child: TextFormField(
                                                                                                controller: _taxId,
                                                                                                decoration: InputDecoration(
                                                                                                  border: InputBorder.none,
                                                                                                  hintText: snapshot.data!.docs[index].get("taxId"),
                                                                                                  icon: Icon(
                                                                                                    Icons.insert_drive_file,
                                                                                                    size: 32,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        ConstrainedBox(
                                                                                          constraints: BoxConstraints(maxWidth: 150),
                                                                                          child: Center(
                                                                                            child: ElevatedButton(
                                                                                              onPressed: () async {
                                                                                                showDialog(
                                                                                                  context: context,
                                                                                                  builder: (BuildContext context) => ProgressWidget(
                                                                                                    msg: "Please wait...",
                                                                                                  ),
                                                                                                );

                                                                                                await client.updateClient(
                                                                                                  _en.text,
                                                                                                  _ar.text,
                                                                                                  _email.text,
                                                                                                  _phone.text,
                                                                                                  _tel.text,
                                                                                                  _fax.text,
                                                                                                  _clearanceName.text,
                                                                                                  _clearanceCode.text,
                                                                                                  _location.text,
                                                                                                  _pic.text,
                                                                                                  _taxId.text,
                                                                                                  snapshot.data!.docs[index].get("id"),
                                                                                                );

                                                                                                await new Future.delayed(
                                                                                                  const Duration(seconds: 1),
                                                                                                );
                                                                                                Navigator.pop(context);
                                                                                                Navigator.pop(context);
                                                                                                setState(() {});

                                                                                                Fluttertoast.showToast(msg: "Update Client Profile");
                                                                                              },
                                                                                              style: ElevatedButton.styleFrom(
                                                                                                foregroundColor: Colors.black,
                                                                                                backgroundColor: Colors.orange[700],
                                                                                                elevation: 3,
                                                                                                shadowColor: Colors.orange,
                                                                                              ),
                                                                                              child: Center(
                                                                                                child: Text(
                                                                                                  "Update Client",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 16,
                                                                                                    fontWeight: FontWeight.bold,
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
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors.green[
                                                                        700],
                                                                foregroundColor:
                                                                    Colors
                                                                        .black,
                                                                elevation: 10,
                                                                shadowColor:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                              child: Icon(
                                                                Icons.edit,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                var dialog =
                                                                    AlertDialog(
                                                                  title: Text(
                                                                      "Alert"),
                                                                  content: Text(
                                                                      "Are you sure you want to Remove this information ?"),
                                                                  actionsAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          await client
                                                                              .delete(
                                                                            snapshot.data!.docs[index].get("id"),
                                                                          );
                                                                          Navigator.pop(
                                                                              context);
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        child: Text(
                                                                            "Yes ,Remove it")),
                                                                  ],
                                                                );
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          cxt) {
                                                                    return dialog;
                                                                  },
                                                                );
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors.red[
                                                                        700],
                                                                foregroundColor:
                                                                    Colors
                                                                        .black,
                                                                elevation: 10,
                                                                shadowColor:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                              child: Icon(
                                                                Icons.delete,
                                                              ),
                                                            ),
                                                          ],
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
          size: ColumnSize.L,
        ),
      )
      .toList();
}
