import 'package:agent_second/models/ben.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GlobalVars with ChangeNotifier {
   BeneficiariesModel beneficiaries;
  Ben benInFocus;
  String benRemaining = "0";
  String orderscount = "0";
  String orderTotal = "0.00";
  String returnscount = "0";
  String returnTotal = "0.00";
  String collectionscount = "0";
  String collectionTotal = "0.00";
  static DateTime timeSinceLoginn = DateTime(2020);
  String timeSinceLogin = DateFormat.Hm().format(timeSinceLoginn);
  void setBenInFocus(Ben ben) {
    benInFocus = ben;
    notifyListeners();
  }

  Ben getbenInFocus() {
    return benInFocus;
  }

  void setBens(BeneficiariesModel x) {
    beneficiaries = x;
    notifyListeners();
  }

  void setDailyLog(String ben, String orders, String orderTot, String rturned,
      String rturnTot, String collection, String collectionTot) {
    benRemaining = "$ben / ${beneficiaries.data.length}";
    orderscount = orders;
    orderTotal = orderTot;

    returnscount = rturned;
    returnTotal = rturnTot;
    collectionscount = collection;
    collectionTotal = collectionTot;

    notifyListeners();
  }

  void incrementTimeSinceLogin() {
    timeSinceLoginn = timeSinceLoginn.add(const Duration(minutes: 1));
    timeSinceLogin = DateFormat.Hm().format(timeSinceLoginn);

    notifyListeners();
  }
}
