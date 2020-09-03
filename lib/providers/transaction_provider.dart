import 'package:agent_second/models/ben.dart';
import 'package:agent_second/models/collection.dart';
import 'package:agent_second/models/finanical_records.dart';
import 'package:agent_second/models/transactions.dart';
import 'package:agent_second/util/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TransactionProvider with ChangeNotifier {
  Ben ben;
  Transactions benOrderTrans;
  Transactions benReturnTrans;
  Transactions agentTrans;
  // Transaction transaction;
  Collections collection;
  FinanicalRecords finanicalRecords;
  bool transactionsDataLoaded = false;

  PagewiseLoadController<dynamic> pagewiseCollectionController;
  PagewiseLoadController<dynamic> pagewiseReturnController;
  PagewiseLoadController<dynamic> pagewiseOrderController;
  PagewiseLoadController<dynamic> pagewiseAgentOrderController;

  int orderTransColorIndecator = 0;
  int returnTransColorIndecator = 0;

  void incrementOrders() {
    orderTransColorIndecator++;
    notifyListeners();
  }

  void incrementReturns() {
    returnTransColorIndecator++;
    notifyListeners();
  }

  Future<void> deleteDradftTrans(int id) async {
    final Response<dynamic> response = await dio.post<dynamic>(
        "transaction/draft/delete",
        data: <String, dynamic>{"transaction_id": id});
    if (response.statusCode == 200) {
      benOrderTrans.transactions.removeWhere((Transaction element) {
        return element.id == id;
      });
      notifyListeners();
    } else {
      Fluttertoast.showToast(msg: "حدث خطأ");
    }
  }

  //Transaction lastTransaction;
  Future<List<Transaction>> getOrdersTransactions(int page, int benId) async {
    transactionsDataLoaded = false;
    final Response<dynamic> response = await dio
        .get<dynamic>("btransactions", queryParameters: <String, dynamic>{
      "page": page + 1,
      "beneficiary_id": benId,
      "type": "order",
    });

    benOrderTrans = Transactions.fromJson(response.data);
    transactionsDataLoaded = true;
    notifyListeners();
    return benOrderTrans.transactions;
  }

  // void setLastTransaction(Transaction x) {
  //   lastTransaction = x;
  //   notifyListeners();
  // }

  Future<List<Transaction>> getReturnTransactions(int page, int benId) async {
    transactionsDataLoaded = false;
    final Response<dynamic> response = await dio
        .get<dynamic>("btransactions", queryParameters: <String, dynamic>{
      "page": page + 1,
      "beneficiary_id": benId,
      "type": "return",
    });

    benReturnTrans = Transactions.fromJson(response.data);
    transactionsDataLoaded = true;
    notifyListeners();
    return benReturnTrans.transactions;
  }

  Future<List<FinanicalRecord>> getCollectionTransactions(
      int page, int benId) async {
    transactionsDataLoaded = false;
    final Response<dynamic> response = await dio.get<dynamic>(
        "financial_transactions/$benId",
        queryParameters: <String, dynamic>{
          "page": page + 1,
        });
    finanicalRecords = FinanicalRecords.fromJson(response.data);
    transactionsDataLoaded = true;
    notifyListeners();
    return finanicalRecords.data;
  }

  Future<List<Transaction>> getAgentOrderTransactions(
      int page, int agentId) async {
    final Response<dynamic> response = await dio
        .get<dynamic>("stocktransactions", queryParameters: <String, dynamic>{
      "page": page + 1,
    });
    agentTrans = Transactions.fromJson(response.data);
    return agentTrans.transactions;
  }

  Future<Response<dynamic>> getGonnaPayTransactions(
      int benId, int agentId) async {
    final Response<dynamic> response = await dio.post<dynamic>(
        "transaction/confirmed",
        data: <String, dynamic>{"beneficiary_id": benId, "agent_id": agentId});
    return response;
  }

  void declearPagWiseControllers() {
    pagewiseCollectionController = PagewiseLoadController<dynamic>(
        pageSize: 15,
        pageFuture: (int pageIndex) async {
          return getCollectionTransactions(pageIndex, ben.id);
        });
    pagewiseOrderController = PagewiseLoadController<dynamic>(
        pageSize: 15,
        pageFuture: (int pageIndex) async {
          return getOrdersTransactions(pageIndex, ben.id);
        });
    pagewiseReturnController = PagewiseLoadController<dynamic>(
        pageSize: 15,
        pageFuture: (int pageIndex) async {
          return getReturnTransactions(pageIndex, ben.id);
        });
  }
}
