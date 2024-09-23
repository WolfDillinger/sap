import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../helper/ExpandedListAnimationWidget.dart';
import '../helper/Scrollbar.dart';
import '../helper/firebase_api.dart';
import '../model/invoice_form.dart';
import '../style/progress.dart';

typedef OnDelete();

class AddFormInvoiceWidget extends StatefulWidget {
  final InvoiceFormModel form;
  final OnDelete? onDelete;

  final String? name;
  AddFormInvoiceWidget({
    Key? key,
    required this.form,
    this.onDelete,
    this.name,
  }) : super(key: key);

  @override
  State<AddFormInvoiceWidget> createState() => _AddFormWidgetInvoiceState();
}

class _AddFormWidgetInvoiceState extends State<AddFormInvoiceWidget> {
  Container view = Container();
  dynamic groupValue;
  bool isStrechedDropDown = false;
  List<String> items = [
    'EUR',
    'USD',
    'JOD',
  ];
  UploadTask? task;
  FilePickerResult? sab;
  FileType _pickingType = FileType.any;
  List<Widget> widgets = [];
  bool _loadingPath = false, vic = true;

  Future<void> _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      sab = await FilePicker.platform.pickFiles(
        type: _pickingType,
      );

      widgets.add(
        ListTile(
          title: Text(
            sab!.files.first.name,
          ),
          leading: Text(widget.name!),
          trailing: IconButton(
            icon: Icon(
              Icons.delete_outline,
              size: 20.0,
              color: Colors.brown[900],
            ),
            onPressed: () {
              var dialog = AlertDialog(
                title: Text("Alert"),
                content:
                    Text("Are you sure you want to Remove this infofrmation ?"),
                actionsAlignment: MainAxisAlignment.spaceEvenly,
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
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
    } catch (ex) {}
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      vic = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: Card(
          color: Colors.grey[400],
          elevation: 10,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: Text(
                      widget.name!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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
                      onChanged: (value) {
                        widget.form.invoicesNo = value;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Invoices No",
                        icon: Icon(
                          Icons.insert_drive_file_outlined,
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
                      onChanged: (value) {
                        widget.form.value = value;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Value",
                        icon: Icon(
                          Icons.view_column_rounded,
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
                  setState(() {
                    isStrechedDropDown = !isStrechedDropDown;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          child: Column(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 10,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Curreny :",
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
                                              setState(() {
                                                isStrechedDropDown =
                                                    !isStrechedDropDown;
                                              });
                                            },
                                            child: Icon(isStrechedDropDown
                                                ? Icons.arrow_upward
                                                : Icons.arrow_downward))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                shadowColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: ExpandedSection(
                                  expand: isStrechedDropDown,
                                  height: 100,
                                  child: MyScrollbar(
                                    builder: (context, scrollController) =>
                                        ListView.builder(
                                      padding: EdgeInsets.all(0),
                                      controller: scrollController,
                                      shrinkWrap: true,
                                      itemCount: items.length,
                                      itemBuilder: (context, index) {
                                        return RadioListTile(
                                          title: Text(
                                            items[index]
                                                .toString()
                                                .toUpperCase(),
                                          ),
                                          value: index,
                                          groupValue: groupValue,
                                          onChanged: (val) {
                                            setState(
                                              () {
                                                groupValue = val;
                                                widget.form.currency =
                                                    items[index]
                                                        .toString()
                                                        .toUpperCase();

                                                view = Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange[600],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      15,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 15,
                                                      right: 15,
                                                      top: 5,
                                                      bottom: 5,
                                                    ),
                                                    child: Text(
                                                      widget.form.currency!,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        color: Colors.white70,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                                isStrechedDropDown =
                                                    !isStrechedDropDown;
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await _openFileExplorer();
                      widget.form.url = await uploadFile(sab);

                      showDialog(
                        context: context,
                        builder: (BuildContext context) => ProgressWidget(
                          msg: "Please wait...",
                        ),
                      );
                      await new Future.delayed(
                        const Duration(seconds: 1),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[700],
                      foregroundColor: Colors.black,
                      elevation: 3,
                    ),
                    child: const Text(
                      "Add file",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: widget.onDelete,
                    icon: Icon(Icons.remove),
                  ),
                ],
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

    final snapshot = await task!.whenComplete(() {
      print("ahnaf");
    });

    if (task == null) return;

    setState(() {
      Fluttertoast.showToast(msg: "Files Uploaded");
    });
    return await snapshot.ref.getDownloadURL();
  }
}
