import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/port.dart';
import '../provider/ship.dart';
import 'divider.dart';

class CountryPredictionWidget extends StatefulWidget {
  CountryPredictionWidget({Key? key}) : super(key: key);

  @override
  State<CountryPredictionWidget> createState() =>
      _CountryPredictionWidgetState();
}

class _CountryPredictionWidgetState extends State<CountryPredictionWidget> {
  List<PortModel> portPredictionList = [];
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 680),
              child: SingleChildScrollView(
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
                        child: TextField(
                          onChanged: (val) {
                            setState(() {});
                            findPlace(val);
                          },
                          decoration: InputDecoration(
                            hintText: "Select Place",
                            fillColor: Colors.grey[700],
                            filled: true,
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.only(
                              left: 11.0,
                              top: 8.0,
                              bottom: 8.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    (portPredictionList.length > 0)
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            child: ListView.separated(
                              padding: EdgeInsets.all(0),
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      DividerWidget(),
                              itemCount: portPredictionList.length,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return PredictionTile(
                                  portPrediction: portPredictionList[index],
                                );
                              },
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void findPlace(String placeName) async {
    List<PortModel> pre = [];
    if (placeName.length > 1) {
      var ports = Provider.of<ShipProvider>(context, listen: false).ports;

      for (PortModel port in ports!) {
        if (port.city!.toUpperCase().contains(placeName.toUpperCase())) {
          pre.add(port);
        }
      }
      setState(() {
        portPredictionList = pre;
      });
    } else {
      setState(() {
        portPredictionList = [];
      });
    }
  }
}

// ignore: must_be_immutable
class PredictionTile extends StatelessWidget {
  final PortModel? portPrediction;
  PredictionTile({Key? key, this.portPrediction}) : super(key: key);

  TextEditingController name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        getPlaceAddress(portPrediction!.name!, context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(
              width: 10.0,
            ),
            Row(
              children: [
                Icon(
                  Icons.directions_boat_sharp,
                  color: Colors.orange,
                ),
                SizedBox(
                  width: 14.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        portPrediction!.name!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        portPrediction!.country!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        portPrediction!.unlocs![0],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  getPlaceAddress(String placeId, context) async {
    Navigator.pop(context, placeId);
  }
}
