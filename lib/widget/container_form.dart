import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

typedef OnDelete();

class ContainerFormWidget extends StatefulWidget {
  final OnDelete? onDelete;
  final state = _ContainerFormWidgetState();
  final TextEditingController? containerContro;
  ContainerFormWidget({Key? key, this.onDelete, this.containerContro})
      : super(key: key);

  @override
  State<ContainerFormWidget> createState() => _ContainerFormWidgetState();
}

class _ContainerFormWidgetState extends State<ContainerFormWidget> {
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
                      widget.containerContro!.text = value;
                      widget.containerContro!.selection =
                          TextSelection.fromPosition(
                        TextPosition(
                            offset: widget.containerContro!.text.length),
                      );
                    },
                    validator: (val) => val!.length <= 8 ? null : fun(),
                    controller: widget.containerContro,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Container Number",
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
            icon: Icon(Icons.remove),
            onPressed: widget.onDelete,
          ),
        ],
      ),
    );
  }
}
