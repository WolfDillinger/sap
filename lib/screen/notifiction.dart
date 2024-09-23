import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sap/model/action.dart';
import '../widget/divider.dart';
import '../widget/notification.dart';

class NotificationScreen extends StatefulWidget {
  final String name;

  const NotificationScreen({Key? key, required this.name}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("action")
                  .where('by', isEqualTo: widget.name)
                  .where('click', isEqualTo: false)
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
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16.0,
                              ),
                              child: ListView.separated(
                                padding: EdgeInsets.all(0),
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        DividerWidget(),
                                itemCount: snapshot.data!.docs.length,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return NotificationViewWidget(
                                    name: widget.name,
                                    notification: ActionModel.fromSnapshot(
                                        snapshot.data!.docs[index]),
                                  );
                                },
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
        ),
      ),
    );
  }
}
