import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/sealine.dart';
import '../provider/ship.dart';
import 'divider.dart';

class SealinePredictionWidget extends StatefulWidget {
  SealinePredictionWidget({Key? key}) : super(key: key);

  @override
  State<SealinePredictionWidget> createState() =>
      _SealinePredictionWidgetState();
}

class _SealinePredictionWidgetState extends State<SealinePredictionWidget> {
  List<SealineModel> seaPredictionList = [];
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
                    (seaPredictionList.length > 0)
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
                              itemCount: seaPredictionList.length,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return PredictionTile(
                                  seaPrediction: seaPredictionList[index],
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
    List<SealineModel> pre = [];
    if (placeName.length > 1) {
      var ports = Provider.of<ShipProvider>(context, listen: false).sealines;

      for (SealineModel port in ports!) {
        if (port.name!.toUpperCase().contains(placeName.toUpperCase())) {
          pre.add(port);
        }
      }
      setState(() {
        seaPredictionList = pre;
      });
    } else {
      setState(() {
        seaPredictionList = [];
      });
    }
  }
}

// ignore: must_be_immutable
class PredictionTile extends StatelessWidget {
  final SealineModel? seaPrediction;
  PredictionTile({Key? key, this.seaPrediction}) : super(key: key);

  TextEditingController name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        getPlaceAddress(seaPrediction!.name!, context);
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
                        seaPrediction!.name!,
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
                        seaPrediction!.scac!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 2.0,
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
