import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

typedef OnDelete();

class AddHblWidget extends StatefulWidget {
  final Function()? notifyParent;
  final OnDelete? onDelete;
  final state = _AddHblWidgetState();
  final TextEditingController? hbl;
  AddHblWidget({Key? key, this.onDelete, this.notifyParent, this.hbl})
      : super(key: key);

  @override
  State<AddHblWidget> createState() => _AddHblWidgetState();
}

class _AddHblWidgetState extends State<AddHblWidget> {
  fun() {
    return Fluttertoast.showToast(msg: "invalid");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
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
                    borderRadius: BorderRadius.circular(10)),
                elevation: 10,
                shadowColor: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    onChanged: (value) {
                      widget.hbl!.text = value;
                      widget.hbl!.selection = TextSelection.fromPosition(
                        TextPosition(offset: widget.hbl!.text.length),
                      );
                    },
                    validator: (val) => val!.length <= 8 ? null : fun(),
                    controller: widget.hbl,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "HBL",
                      icon: Icon(
                        Icons.insert_drive_file_outlined,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: widget.onDelete,
          ),
        ],
      ),
    );
  }
}
