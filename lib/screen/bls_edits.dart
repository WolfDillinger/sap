import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sap/provider/shipment.dart';
import '../helper/firebase_api.dart';
import '../provider/monitoring.dart';
import '../widget/bls_edits.dart';
import '../widget/progress.dart';

class HblsEditsScreen extends StatefulWidget {
  final dynamic hbls;
  final String id;
  final String name;
  const HblsEditsScreen(
      {Key? key, required this.hbls, required this.id, required this.name})
      : super(key: key);

  @override
  State<HblsEditsScreen> createState() => _HblsEditsScreenState();
}

class _HblsEditsScreenState extends State<HblsEditsScreen> {
  List<HblEditsWidget> wid = [];
  List<String> hblsInfo = [];
  UploadTask? task;
  @override
  void initState() {
    super.initState();
    widget.hbls.forEach((form) {
      var _con = TextEditingController();
      wid.add(
        HblEditsWidget(
          name: form,
          num: _con,
        ),
      );
    });
  }

  String hblUrl = '';

  bool _loadingPath = false, vic = true;
  FileType _pickingType = FileType.any;
  bool checkValue = false;
  FilePickerResult? _paths;

  Future<void> _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _paths = await FilePicker.platform.pickFiles(
        type: _pickingType,
      );
    } on PlatformException catch (e) {
      print(e);
    } catch (ex) {}
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      vic = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final shipment = Provider.of<ShipmentProvider>(context);
    final monitoring = Provider.of<MonitoringProvider>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            AppBar(
              title: Text("HBLS Edits"),
              centerTitle: true,
              leading: Container(),
            ),
            SingleChildScrollView(
              child: Column(
                children: wid,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _openFileExplorer();

                showDialog(
                  context: context,
                  builder: (BuildContext context) => ProgressWidget(
                    msg: "Please wait...",
                  ),
                );
                hblUrl = await uploadFile(_paths);

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[700],
                foregroundColor: Colors.black,
                elevation: 3,
              ),
              child: const Text(
                "Add New File HBL",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              child: Builder(
                builder: (BuildContext context) => _loadingPath
                    ? Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10.0,
                        ),
                        child: const CircularProgressIndicator(),
                      )
                    : vic
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.only(right: 4),
                            height: MediaQuery.of(context).size.height * 0.20,
                            child: ListView.separated(
                              itemCount: 1,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Text(
                                    _paths!.files.first.name,
                                  ),
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
                                        actionsAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                _paths = null;
                                                vic = true;
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
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => ProgressWidget(
                      msg: "Please wait...",
                    ),
                  );
                  await onsave(context);
                  await monitoring.addMonitoring(
                    widget.name,
                    "Shipment HBL ${hblsInfo[0]}",
                    "Update HBL Shipment",
                    DateTime.now(),
                  );
                  await shipment.updateHbl(hblsInfo, hblUrl, widget.id);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  foregroundColor: Colors.black,
                  elevation: 3,
                ),
                child: const Text(
                  "Save",
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

  onsave(context) {
    setState(() {
      wid.forEach((element) {
        hblsInfo.add(element.num.text);
      });
    });
  }
}
