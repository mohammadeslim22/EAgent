import 'package:agent_second/models/ben.dart';
import 'package:flutter/material.dart';

class GlobalVars with ChangeNotifier {
  BeneficiariesModel beneficiaries;
  Ben benInFocus;
  void setBenInFocus(Ben ben) {
    benInFocus = ben;
    notifyListeners();
  }
}

final GlobalVars globalVars = GlobalVars();
