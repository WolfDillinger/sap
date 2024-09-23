import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sap/model/form.dart';
import '../helper/ExpandedListAnimationWidget.dart';
import '../helper/Scrollbar.dart';
import 'container_form.dart';

typedef OnDelete();
typedef OnSave();

class AddFormWidget extends StatefulWidget {
  final FormModel form;
  final OnDelete? onDelete;

  AddFormWidget({
    Key? key,
    required this.form,
    this.onDelete,
  }) : super(key: key);

  @override
  State<AddFormWidget> createState() => _AddFormWidgetState();
}

class _AddFormWidgetState extends State<AddFormWidget> {
  Container view = Container();
  dynamic groupValue;
  bool isStrechedDropDown = false;
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

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  onChanged: (value) {
                    widget.form.vol = value;
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Volume",
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
                                borderRadius: BorderRadius.circular(10)),
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
                                  itemCount: items3.length,
                                  itemBuilder: (context, index3) {
                                    return RadioListTile(
                                      title: Text(
                                        items3[index3].toString().toUpperCase(),
                                      ),
                                      value: index3,
                                      groupValue: groupValue,
                                      onChanged: (val) {
                                        setState(
                                          () {
                                            groupValue = val;
                                            widget.form.size = items3[index3]
                                                .toString()
                                                .toUpperCase();

                                            view = Container(
                                              decoration: BoxDecoration(
                                                color: Colors.orange[600],
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  left: 15,
                                                  right: 15,
                                                  top: 5,
                                                  bottom: 5,
                                                ),
                                                child: Text(
                                                  widget.form.size!,
                                                  style: GoogleFonts.montserrat(
                                                    color: Colors.white70,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
          Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                    shadowColor: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        onChanged: (val) {
                          widget.form.container = val;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Conatiner NO",
                          icon: Icon(
                            Icons.add_box_rounded,
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
                  setState(() {
                    onAddForm();
                  });
                },
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Column(
            children: widget.form.views,
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
    );
  }

  void onDelete(TextEditingController _value) {
    setState(() {
      var find = widget.form.views.firstWhere(
        (it) => it.containerContro == _value,
        // ignore: null_check_always_fails
        orElse: () => null!,
      );
      // ignore: unnecessary_null_comparison
      if (find != null)
        widget.form.views.removeAt(
          widget.form.views.indexOf(find),
        );
    });
  }

  void onAddForm() {
    setState(() {
      var _value = TextEditingController();
      widget.form.views.add(ContainerFormWidget(
        containerContro: _value,
        onDelete: () => onDelete(_value),
      ));
    });
  }
}
