import 'package:agent_second/models/ben.dart';
import 'package:agent_second/providers/export.dart';
import 'package:agent_second/util/dio.dart';
import 'package:agent_second/util/service_locator.dart';
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
  ItemsCap dummyItemCap = ItemsCap(balanceCap: 99999999);
  SingleItem dummySiglItem = SingleItem(balanceInventory: 99999999);
  int howManyscreensToPop;
  String getUnitNme(int itemId, int unitId) {
    String name;
    name = itemsList
        .firstWhere((SingleItem element) {
          return element.id == itemId;
        })
        .units
        .firstWhere((Units element) {
          return element.id == unitId;
        })
        .name;
    return name;
  }

  void setScreensToPop(int x) {
    howManyscreensToPop = x;
  }

  void addItemToList(int id, String name, String note, int queantity, int unit,
      String unitPrice) {
    if (selectedOptions.contains(id)) {
    } else {
      ordersList.add(SingleItemForSend(
          id: id,
          name: name,
          notes: note,
          queantity: queantity,
          unit: getUnitNme(id, unit),
          unitId: unit,
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

  void changeUnit(int itemId, String unit, int unitId) {
    ordersList.firstWhere((SingleItemForSend element) {
      return element.id == itemId;
    }).unitId = unitId;

    notifyListeners();
  }

  void incrementQuantity(int itemId) {
    final int quantity = ordersList.firstWhere((SingleItemForSend element) {
      return element.id == itemId;
    }).queantity;
    if (checkValidation(itemId, quantity + 1)) {
      ordersList.firstWhere((SingleItemForSend element) {
        return element.id == itemId;
      }).queantity += 1;
      sumTotal +=
          double.parse(ordersList.firstWhere((SingleItemForSend element) {
        return element.id == itemId;
      }).unitPrice);
    } else {
      Vibration.vibrate(duration: 600);
    }

    notifyListeners();
  }

  void setQuantity(int itemId, int quantity) {
    if (checkValidation(itemId, quantity)) {
      ordersList.firstWhere((SingleItemForSend element) {
        return element.id == itemId;
      }).queantity = quantity;
      getTotla();
    } else {
      Vibration.vibrate(duration: 600);
    }

    notifyListeners();
  }

  void decrementQuantity(int itemId) {
    if (ordersList.firstWhere((SingleItemForSend element) {
          return element.id == itemId;
        }).queantity >
        1) {
      ordersList.firstWhere((SingleItemForSend element) {
        return element.id == itemId;
      }).queantity -= 1;

      sumTotal -=
          double.parse(ordersList.firstWhere((SingleItemForSend element) {
        return element.id == itemId;
      }).unitPrice);
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
    ordersList.firstWhere((SingleItemForSend element) {
      return element.id == itemId;
    }).unit = unit;
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

  bool sendCollection(BuildContext c, int benId, int amount, String status) {
    bool res = false;
    dio.post<dynamic>("collection", data: <String, dynamic>{
      "beneficiary_id": benId,
      "amount": amount,
      "status": status,
      // "vehicle_id": 1
    }).then((Response<dynamic> value) {
      print("hhooooooooollllllllllllaaaaaaaaaaaaa collection   ${value.data}");
      if (value.statusCode == 200) {
        res = true;
      } else {
        res = false;
      }
    });
    getIt<GlobalVars>().setBenVisted(benId);
    getIt<TransactionProvider>().pagewiseCollectionController.reset();
    Navigator.pop(c);
    notifyListeners();
    return res;
  }

  bool sendOrder(BuildContext c, int benId, int ammoutn, int shortage,
      String type, String status) {
    final List<int> itemsId = <int>[];
    final List<int> itemsQuantity = <int>[];
    final List<int> itemsPrice = <int>[];
    final List<int> itemsUnit = <int>[];
    final List<String> itemsNote = <String>[];
    bool res = false;
    for (int i = 0; i < ordersList.length; i++) {
      itemsId.add(ordersList[i].id);
      itemsQuantity.add(ordersList[i].queantity);
      itemsPrice.add(double.parse(ordersList[i].unitPrice).round());
      itemsUnit.add(ordersList[i].unitId);
      itemsNote.add(ordersList[i].notes);
      //'item_id[]': ordersList[i].toJson(),
    }

    dio.post<dynamic>("btransactions", data: <String, dynamic>{
      "beneficiary_id": benId,
      "status": status,
      "type": type,
      "notes": "",
      "amount": ammoutn,
      "shortage": shortage,

      // "item_id":[1],
      // "quantity":[19],
      // "item_price":[100],
      // "unit":[1]
      // for (int i = 0; i < ordersList.length; i++)
      // "item_id[]": ordersList[i].id,

      // for (int i = 0; i < ordersList.length; i++)
      // "quantity[]": ordersList[i].queantity,

      // for (int i = 0; i < ordersList.length; i++)
      // "item_price[]": double.parse(ordersList[i].unitPrice).round(),

      // for (int i = 0; i < ordersList.length; i++)
      // "unit[]": 1,

      "item_id": itemsId,
      "item_price": itemsPrice,
      "quantity": itemsQuantity,
      "unit": itemsUnit,
      // "notes": itemsNote
    }).then((Response<dynamic> value) {
      print("hhooooooooollllllllllllaaaaaaaaaaaaa    ${value.data}");
      if (value.statusCode == 200) {
        clearOrcerList();
        res = true;
      } else {
        res = false;
      }
    });
    getIt<GlobalVars>().setBenVisted(benId);
    clearOrcerList();
    if (howManyscreensToPop >= 3) {
      getIt<TransactionProvider>().pagewiseOrderController.reset();
      getIt<TransactionProvider>().pagewiseReturnController.reset();
    }
    Navigator.of(c).pushNamedAndRemoveUntil("/Beneficiary_Center",
        (Route<dynamic> route) {
      howManyscreensToPop--;
      return howManyscreensToPop == 0;
    }, arguments: <String, dynamic>{
      "ben": getIt<GlobalVars>().getbenInFocus()
    });
    notifyListeners();
    return res;
  }

  Future<void> getItems() async {
    dataLoaded = false;
    indexedStack = 0;
    notifyListeners();
    await dio.get<dynamic>("items").then((Response<dynamic> value) {
      itemsList = Items.fromJson(value.data).itemsList;
      dataLoaded = true;
      indexedStack = 1;
      notifyListeners();
      return null;
    });
  }

  SingleItem getItemForUnit(int itemId) {
    return itemsList.firstWhere((SingleItem element) {
      return element.id == itemId;
    });
  }

  bool checkValidation(int itemId, int quantity) {
    if (quantity <=
            itemsList.firstWhere((SingleItem element) {
              return element.id == itemId;
            }).balanceInventory &&
        quantity > 0) {
      if (quantity <=
          getIt<GlobalVars>().benInFocus.itemsCap.firstWhere(
              (ItemsCap element) {
            return element.itemId == itemId;
          }, orElse: () {
            return dummyItemCap;
          }).balanceCap) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
