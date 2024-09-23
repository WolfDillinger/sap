import 'package:flutter/material.dart';

class HblEditsWidget extends StatefulWidget {
  final TextEditingController num;
  final String name;
  HblEditsWidget({Key? key, required this.num, required this.name})
      : super(key: key);

  @override
  State<HblEditsWidget> createState() => _HblEditsWidgetState();
}

class _HblEditsWidgetState extends State<HblEditsWidget> {
  @override
  void initState() {
    super.initState();
    widget.num.text = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            controller: widget.num,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.num.text,
              icon: Icon(
                Icons.data_saver_off_outlined,
                size: 32,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
