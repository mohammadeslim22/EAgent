import 'package:agent_second/util/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:agent_second/models/Items.dart';
import 'package:vibration/vibration.dart';

class OrderListProvider with ChangeNotifier {
  List<SingleItemForSend> ordersList = <SingleItemForSend>[];
  List<SingleItem> itemsList;
  bool dataLoaded = false;
  int indexedStack = 0;
  Set<int> selectedOptions = <int>{};
  double sumTotal = 0;
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
      sumTotal += double.parse(unitPrice);
      notifyListeners();
    }
  }

  void clearOrcerList() {
    ordersList.clear();
    selectedOptions.clear();
    sumTotal = 0.0;
    notifyListeners();
  }

  void incrementQuantity(int itemId) {
    ordersList
        .where((SingleItemForSend element) {
          return element.id == itemId;
        })
        .first
        .queantity += 1;
    sumTotal += double.parse(ordersList
        .where((SingleItemForSend element) {
          return element.id == itemId;
        })
        .first
        .unitPrice);
    notifyListeners();
  }

  void setQuantity(int itemId, int quantity) {
    if (quantity < 1000 && quantity > 0) {
      ordersList
          .where((SingleItemForSend element) {
            return element.id == itemId;
          })
          .first
          .queantity = quantity;
      getTotla();
    } else {
      Vibration.vibrate(duration: 600);
    }

    notifyListeners();
  }

  void decrementQuantity(int itemId) {
    if (ordersList
            .where((SingleItemForSend element) {
              return element.id == itemId;
            })
            .first
            .queantity >
        1) {
      ordersList
          .where((SingleItemForSend element) {
            return element.id == itemId;
          })
          .first
          .queantity -= 1;

      sumTotal -= double.parse(ordersList
          .where((SingleItemForSend element) {
            return element.id == itemId;
          })
          .first
          .unitPrice);
    } else {
      Vibration.vibrate(duration: 600);
    }
    notifyListeners();
  }

  void removeItemFromList(int itemId) {
    ordersList.removeWhere((SingleItemForSend element) {
      return element.id == itemId;
    });
    getTotla();
    notifyListeners();
  }

  void modifyItemUnit(String unit, int itemId) {
    ordersList
        .where((SingleItemForSend element) {
          return element.id == itemId;
        })
        .first
        .unit = unit;
    notifyListeners();
  }

  double getTotla() {
    void sumtoTotal(double price) {
      sumTotal += price;
    }

    sumTotal = 0.0;
    // ignore: avoid_function_literals_in_foreach_calls
    ordersList.forEach((SingleItemForSend element) {
      sumtoTotal(double.parse(element.unitPrice) * element.queantity);
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
