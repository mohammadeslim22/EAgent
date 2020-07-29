import 'package:agent_second/util/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:agent_second/models/Items.dart';

class OrderListProvider with ChangeNotifier {
  List<SingleItemForSend> ordersList = <SingleItemForSend>[];
  List<SingleItem> itemsList;
  bool dataLoaded = false;
  int indexedStack = 0;
  Set<int> selectedOptions = <int>{};

  List<SingleItemForSend> get currentordersList => ordersList;

  void addItemToList(int id, String name, String note, int queantity,
      String unit, String unitPrice) {
    if (selectedOptions.contains(id)) {
    } else {
      ordersList.add(SingleItemForSend(
          id: id,
          name: name,
          notes: note,
          queantity: queantity,
          unit: unit,
          unitPrice: unitPrice));
      notifyListeners();
    }
  }

  void clearOrcerList() {
    ordersList.clear();
  }

  void removeItemFromList(int itemId) {
    ordersList.removeWhere((SingleItemForSend element) {
      return element.id == itemId;
    });
    notifyListeners();
  }

  void modifyItemUnit(String unit, int itemId) {
    ordersList
        .where((SingleItemForSend element) {
          return element.id == itemId;
        })
        .first
        .unit = unit;
    // for (int i = 0; i < ordersList.length; i++) {
    //   if (ordersList[i].id == itemId) {
    //     ordersList[i].unit = unit;
    //   }
    // }
    notifyListeners();
  }

  double getTotla() {
    double sumTotal = 0;
    void sumtoTotal(double price) {
      sumTotal += price;
    }

    // ignore: avoid_function_literals_in_foreach_calls
    ordersList.forEach((SingleItemForSend element) {
      sumtoTotal(double.parse(element.unitPrice));
    });
    return sumTotal;
  }

  void sendOrder() {}
  Future<void> getItems() async {
    dataLoaded = false;
    indexedStack = 0;
    notifyListeners();
    await dio.get<dynamic>("items").then((Response<dynamic> value) {
      itemsList = Items.fromJson(value.data).itemsList;
      dataLoaded = true;
      indexedStack = 1;
      notifyListeners();
    });
  }
}
