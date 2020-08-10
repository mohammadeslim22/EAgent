import 'package:agent_second/models/ben.dart';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GlobalVars with ChangeNotifier {
  BeneficiariesModel beneficiaries;
  Ben benInFocus;
  String benRemaining = "0/0";
  String orderscount = "0";
  String orderTotal = "0.00";
  String returnscount = "0";
  String returnTotal = "0.00";
  String collectionscount = "0";
  String collectionTotal = "0.00";

  bool bensIsOpen = false;

  static DateTime timeSinceLoginn = DateTime(2020);
  String timeSinceLogin = DateFormat.Hm().format(timeSinceLoginn);
  static DateTime timeSinceLastTranss = DateTime(2020);
  String timeSinceLastTrans = DateFormat.Hm().format(timeSinceLoginn);
  void setBenInFocus(Ben ben) {
    benInFocus = ben;
    notifyListeners();
  }

  void openBens() {
    bensIsOpen = true;
  }

  void closeBens() {
    bensIsOpen = false;
  }

  Ben getbenInFocus() {
    return benInFocus;
  }

  void setBens(BeneficiariesModel x) {
    beneficiaries = x;
    notifyListeners();
  }

  void setBenVisted(int benId) {
    beneficiaries.data.firstWhere((Ben element) {
      return element.id == benId;
    }).visited = true;
    notifyListeners();
  }

  void setDailyLog(String ben, String orders, String orderTot, String rturned,
      String rturnTot, String collection, String collectionTot) {
    benRemaining = "$ben / ${beneficiaries.data.length}";
    orderscount = orders;
    orderTotal = "$orderTot.00";
    returnscount = rturned;
    returnTotal = "$rturnTot.00";
    collectionscount = collection;
    collectionTotal = "$collectionTot.00";

    notifyListeners();
  }

  void incrementTimeSinceLogin() {
    timeSinceLoginn = timeSinceLoginn.add(const Duration(minutes: 1));
    timeSinceLogin = DateFormat.Hm().format(timeSinceLoginn);

    notifyListeners();
  }

  void incrementTimeSinceLastTransaction() {
    timeSinceLastTranss = timeSinceLoginn.add(const Duration(minutes: 1));
    timeSinceLastTrans = DateFormat.Hm().format(timeSinceLoginn);

    notifyListeners();
  }

  void startLastTransactionTimeCounter() {
    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      incrementTimeSinceLastTransaction();
    });
  }
}

// background proccess service
final Cron cron = Cron();
