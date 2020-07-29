import 'package:flutter/material.dart';
import 'package:agent_second/models/Items.dart';

class OrderListProvider with ChangeNotifier {
  List<SingleItem> ordersList = <SingleItem>[];

  List<SingleItem> get currentordersList => ordersList;

  void addItemToList(SingleItem item) {
    if (ordersList.contains(item)) {
    } else {
      ordersList.add(item);
      notifyListeners();
    }
  }

  void clearOrcerList() {
    ordersList.clear();
  }

  void removeItemToList(SingleItem item) {
    ordersList.remove(item);
    notifyListeners();
  }

  void modifyItemUnit(String unit, int itemId) {
    for (int i = 0; i < ordersList.length; i++) {
      if (ordersList[i].id == itemId) {
        ordersList[i].unit = unit;
      }
    }
    notifyListeners();
  }

  double getTotla() {
    double sumTotal = 0;
    void sumtoTotal(double price) {
      sumTotal += price;
    }

    // ignore: avoid_function_literals_in_foreach_calls
    ordersList.forEach((SingleItem element) {
      sumtoTotal(double.parse(element.price5));
    });
    return sumTotal;
  }

  void sendOrder() {
    
  }
}
