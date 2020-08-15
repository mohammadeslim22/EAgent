import 'package:agent_second/models/ben.dart';
import 'package:agent_second/models/transactions.dart';
import 'package:agent_second/providers/export.dart';
import 'package:agent_second/util/dio.dart';
import 'package:agent_second/util/functions.dart';
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
    notifyListeners();
  }

  void addItemToList(int id, String name, String note, int queantity, int unit,
      String unitPrice, String image) {
    if (selectedOptions.contains(id)) {
    } else {
      ordersList.add(SingleItemForSend(
          id: id,
          name: name,
          notes: note,
          queantity: queantity,
          unit: getUnitNme(id, unit),
          unitId: unit,
          unitPrice: unitPrice,
          image: image));
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
    })
      ..unitId = unitId
      ..unit = unit;

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

  void picksForbringOrderToOrderScreen() {
    if (ordersList.isEmpty) {
    } else {
      ordersList.forEach((SingleItemForSend element) {
        element.image = itemsList.firstWhere((SingleItem e) {
          return e.id == element.id;
        }).image;
      });
    }
  }

  void bringOrderToOrderScreen(Transaction transaction) {
    clearOrcerList();
    sumTotal = transaction.amount.toDouble();
    transaction.details.forEach((MiniItems element) {
      print(element.itemId);
      selectedOptions.add(element.itemId);

      ordersList.add(SingleItemForSend(
          id: element.itemId,
          // image: itemsList.firstWhere((SingleItem e) {
          //   return e.id == element.id;
          // }).image,
          name: element.item,
          queantity: element.quantity,
          unit: element.unit,
          unitPrice: element.itemPrice.toString()));
    });
    notifyListeners();
  }

  Future<bool> sendCollection(
      BuildContext c, int benId, int amount, String status) async {
    final Response<dynamic> response =
        await dio.post<dynamic>("collection", data: <String, dynamic>{
      "beneficiary_id": benId,
      "amount": amount,
      "status": status,
    });
    if (response.statusCode == 200) {
      setDayLog(response);

      getIt<GlobalVars>().setBenVisted(benId);
      getIt<TransactionProvider>().pagewiseCollectionController.reset();
      Navigator.pop(c);
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendOrder(BuildContext c, int benId, int ammoutn, int shortage,
      String type, String status) async {
    final List<int> itemsId = <int>[];
    final List<int> itemsQuantity = <int>[];
    final List<int> itemsPrice = <int>[];
    final List<int> itemsUnit = <int>[];
    final List<String> itemsNote = <String>[];
    for (int i = 0; i < ordersList.length; i++) {
      itemsId.add(ordersList[i].id);
      itemsQuantity.add(ordersList[i].queantity);
      itemsPrice.add(double.parse(ordersList[i].unitPrice).round());
      itemsUnit.add(ordersList[i].unitId);
      itemsNote.add(ordersList[i].notes);
    }

    final Response<dynamic> response =
        await dio.post<dynamic>("btransactions", data: <String, dynamic>{
      "beneficiary_id": benId,
      "status": status,
      "type": type,
      "notes": "",
      "amount": ammoutn,
      "shortage": shortage,
      "item_id": itemsId,
      "item_price": itemsPrice,
      "quantity": itemsQuantity,
      "unit": itemsUnit,
    });
    if (response.statusCode == 200) {
      clearOrcerList();
      setDayLog(response);
      getIt<GlobalVars>().setBenVisted(benId);
      clearOrcerList();
      if (howManyscreensToPop > 2) {
        getIt<TransactionProvider>().pagewiseOrderController.reset();
        getIt<TransactionProvider>().pagewiseReturnController.reset();
        getIt<TransactionProvider>().pagewiseCollectionController.reset();
      } else {
        //  getIt<TransactionProvider>().pagewiseCollectionController.reset();
      }
      // getIt<TransactionProvider>().setLastTransaction(
      //     Transaction(beneficiaryId: benId, amount: ammoutn, type: type));
      Navigator.of(c).pushNamedAndRemoveUntil("/Beneficiary_Center",
          (Route<dynamic> route) {
        return howManyscreensToPop-- == 0;
      }, arguments: <String, dynamic>{
        "ben": getIt<GlobalVars>().getbenInFocus()
      });
      howManyscreensToPop = 2;
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendAgentOrder(BuildContext c, int benId, int ammoutn,
      int shortage, String type, String status) async {
    final List<int> itemsId = <int>[];
    final List<int> itemsQuantity = <int>[];
    final List<int> itemsPrice = <int>[];
    final List<int> itemsUnit = <int>[];
    final List<String> itemsNote = <String>[];
    for (int i = 0; i < ordersList.length; i++) {
      itemsId.add(ordersList[i].id);
      itemsQuantity.add(ordersList[i].queantity);
      itemsPrice.add(double.parse(ordersList[i].unitPrice).round());
      itemsUnit.add(ordersList[i].unitId);
      itemsNote.add(ordersList[i].notes);
    }

    await dio.post<dynamic>("btransactions", data: <String, dynamic>{
      "beneficiary_id": benId,
      "status": status,
      "type": type,
      "notes": "",
      "amount": ammoutn,
      "shortage": shortage,
      "item_id": itemsId,
      "item_price": itemsPrice,
      "quantity": itemsQuantity,
      "unit": itemsUnit,
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> getItems() async {
    dataLoaded = false;
    indexedStack = 0;
    notifyListeners();
    await dio.get<dynamic>("items").then((Response<dynamic> value) {
      itemsList = Items.fromJson(value.data).itemsList;
      dataLoaded = true;
      indexedStack = 1;
      picksForbringOrderToOrderScreen();
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
