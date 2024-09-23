import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sap/model/action.dart';
import '../helper/screen_navigation.dart';
import '../provider/action.dart';
import '../provider/client.dart';
import '../screen/client_profile.dart';

class NotificationViewWidget extends StatefulWidget {
  final ActionModel notification;
  final String name;
  const NotificationViewWidget(
      {Key? key, required this.notification, required this.name})
      : super(key: key);

  @override
  State<NotificationViewWidget> createState() => _NotificationViewWidgetState();
}

class _NotificationViewWidgetState extends State<NotificationViewWidget> {
  @override
  Widget build(BuildContext context) {
    final client = Provider.of<ClientProvider>(context);
    final action = Provider.of<ActionProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 200,
        child: Center(
          child: Card(
            elevation: 10,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(widget.notification.clientName),
                  Text(
                    widget.notification.nextActionType,
                  ),
                  Text(
                    widget.notification.nextDate,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await client.getClient(
                            widget.notification.uid,
                          );
                          changeScreen(
                            context,
                            ClientProfile(
                              clientName: widget.notification.clientName,
                              name: widget.name,
                              id: widget.notification.uid,
                              clientEng: widget.notification.clientName,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.black,
                          elevation: 10,
                          shadowColor: Colors.black,
                        ),
                        child: Icon(
                          Icons.home_max_rounded,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await client.updateView(widget.notification.id);

                          await action.getAction(widget.notification.by);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.black,
                          elevation: 10,
                          shadowColor: Colors.black,
                        ),
                        child: Icon(
                          Icons.check,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
