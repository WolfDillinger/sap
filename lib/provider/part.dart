import 'package:flutter/widgets.dart';

import '../helper/part.dart';
import '../model/part.dart';

class PartProvider with ChangeNotifier {
  PartServices _partServices = PartServices();
  List<PartModel> parts = [];
  PartProvider() {
    load();
    notifyListeners();
  }
  Future load() async {
    parts = await _partServices.getParts();
  }
}
