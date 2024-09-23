import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sap/provider/clearance.dart';

import '../provider/monitoring.dart';

class EditClearanceScreen extends StatefulWidget {
  final String name;
  EditClearanceScreen({Key? key, required this.name}) : super(key: key);

  @override
  State<EditClearanceScreen> createState() => _EditClearanceScreenState();
}

class _EditClearanceScreenState extends State<EditClearanceScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController fax = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController code = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController pic = TextEditingController();
  TextEditingController tel = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final clearance = Provider.of<ClearanceProvider>(context);
    final monitoring = Provider.of<MonitoringProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Clearance Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 980,
              ),
              child: Container(
                child: Card(
                  elevation: 10,
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                controller: name,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: clearance.clearanceProfile?.name,
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
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: email,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: clearance.clearanceProfile?.email,
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
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: fax,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: clearance.clearanceProfile?.fax,
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
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: address,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: clearance.clearanceProfile?.address,
                                  icon: Icon(
                                    Icons.location_city_rounded,
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
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: code,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: clearance.clearanceProfile?.code,
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
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: phone,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: clearance.clearanceProfile?.phone,
                                  icon: Icon(
                                    Icons.phone_android_rounded,
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
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: pic,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: clearance.clearanceProfile?.pic,
                                  icon: Icon(
                                    Icons.person_add_alt,
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
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: tel,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: clearance.clearanceProfile?.tel,
                                  icon: Icon(
                                    Icons.phone,
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
                              await monitoring.addMonitoring(
                                widget.name,
                                "Clearance name ${name.text} and  Email Action ${email.text}",
                                "Edit Clearance Profile",
                                DateTime.now(),
                              );

                              await clearance.editClearance(
                                  widget.name,
                                  name.text,
                                  address.text,
                                  fax.text,
                                  tel.text,
                                  phone.text,
                                  email.text,
                                  code.text,
                                  pic.text);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.orange[700],
                              elevation: 3,
                            ),
                            child: Center(
                              child: Text("Update"),
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
    );
  }
}
