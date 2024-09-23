import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sap/provider/shipment.dart';
import 'package:sap/widget/client_home.dart';
import 'package:sap/widget/shipments.dart';
import '../widget/action.dart';
import '../widget/invoice.dart';

class ClientProfile extends StatefulWidget {
  final String id;
  final String name;
  final String clientName;
  final String clientEng;
  ClientProfile(
      {Key? key,
      required this.id,
      required this.name,
      required this.clientEng,
      required this.clientName})
      : super(key: key);

  @override
  State<ClientProfile> createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
  Widget current = ClientHomeWidget();

  @override
  Widget build(BuildContext context) {
    final shipment = Provider.of<ShipmentProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.clientEng.toUpperCase()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 15,
              ),
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 960,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 10,
                      color: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  current = ClientHomeWidget();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.orange,
                                elevation: 3,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Home",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await shipment.getShipment(widget.id);
                                setState(() {
                                  current = ShipmentClientWidget(
                                    name: widget.name,
                                    id: widget.id,
                                  );
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.orange,
                                elevation: 3,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Shipments",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  current = InvoiceClientWidget(
                                    name: widget.name,
                                    id: widget.id,
                                  );
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.orange,
                                elevation: 3,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Invoice",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  current = ActionClientWidget(
                                    clientName: widget.clientName,
                                    name: widget.name,
                                    id: widget.id,
                                  );
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.orange,
                                elevation: 3,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Action Page",
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
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              current,
            ],
          ),
        ),
      ),
    );
  }
}
