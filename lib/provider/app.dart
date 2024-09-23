import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppProvider with ChangeNotifier {
  String formatted(timeStamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    //  var v = DateTime.now().difference(date).inDays;

    return DateFormat('yyyy-MM-dd hh:mm a').format(date).toString();
  }

  String formattedTrack(String y) {
    var date = DateTime.parse(y);
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(date);
  }

  AppProvider();
}
