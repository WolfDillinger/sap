import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sap/provider/clearance.dart';
import '../helper/screen_navigation.dart';
import '../model/clearance.dart';
import 'home.dart';

class SearchClearanceScreen extends StatefulWidget {
  SearchClearanceScreen({Key? key}) : super(key: key);

  @override
  State<SearchClearanceScreen> createState() => _SearchClearanceScreenState();
}

class _SearchClearanceScreenState extends State<SearchClearanceScreen> {
  ScrollController scollBarController = ScrollController();
  final columns = [
    'Name',
    'Address',
    'Tel',
    'Fax',
    'Phone',
    'Email',
    'Code',
    'Pic',
  ];

  @override
  Widget build(BuildContext context) {
    final clearance = Provider.of<ClearanceProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              changeScreenReplacement(context, HomeScreen());
            },
            icon: Icon(
              Icons.home,
            ),
          ),
        ],
      ),
      body: Scrollbar(
        thumbVisibility: true,
        scrollbarOrientation: ScrollbarOrientation.top,
        controller: scollBarController,
        child: SingleChildScrollView(
          controller: scollBarController,
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: Card(
                    elevation: 10,
                    color: Colors.transparent,
                    child: DataTable(
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      dataTextStyle: TextStyle(
                        color: Colors.orange,
                      ),
                      showBottomBorder: true,
                      headingRowColor: WidgetStateProperty.all<Color>(
                        Color.fromRGBO(0, 0, 0, 0),
                      ),
                      dataRowColor: WidgetStateProperty.all<Color>(
                        Color.fromRGBO(0, 0, 0, 0),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      sortAscending: false,
                      columns: getColumns(columns),
                      rows: getRows(clearance.searchClearances),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map(
        (String column) => DataColumn(
          label: Expanded(
            child: Text(
              textAlign: TextAlign.center,
              column,
              style: TextStyle(
                color: Colors.orange,
              ),
            ),
          ),
        ),
      )
      .toList();

  List<DataRow> getRows(List<ClearanceModel> users) =>
      users.map((ClearanceModel user) {
        final cells = [
          user.name,
          user.address,
          user.tel,
          user.fax,
          user.phone,
          user.email,
          user.code,
          user.pic,
        ];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) => cells
      .map(
        (data) => DataCell(
          Container(
            width: 200,
            child: Text(
              '$data',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      )
      .toList();
}
