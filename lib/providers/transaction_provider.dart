import 'package:agent_second/models/ben.dart';
import 'package:agent_second/models/collection.dart';
import 'package:agent_second/models/transactions.dart';
import 'package:agent_second/util/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class TransactionProvider with ChangeNotifier {
  Ben ben;
  Transactions benTrans;
  Transaction transaction;
  Collections collection;
  PagewiseLoadController<dynamic> pagewiseCollectionController;
  PagewiseLoadController<dynamic> pagewiseReturnController;
  PagewiseLoadController<dynamic> pagewiseOrderController;
    PagewiseLoadController<dynamic> pagewiseAgentOrderController;

  //Transaction lastTransaction;
  Future<List<Transaction>> getOrdersTransactions(int page, int benId) async {
    final Response<dynamic> response = await dio
        .get<dynamic>("btransactions", queryParameters: <String, dynamic>{
      "page": page+1,
      "beneficiary_id": benId,
      "type": "order",
    });

    benTrans = Transactions.fromJson(response.data);

    return benTrans.transactions;
  }

  // void setLastTransaction(Transaction x) {
  //   lastTransaction = x;
  //   notifyListeners();
  // }

  Future<List<Transaction>> getReturnTransactions(int page, int benId) async {
    final Response<dynamic> response = await dio
        .get<dynamic>("btransactions", queryParameters: <String, dynamic>{
      "page": page+1,
      "beneficiary_id": benId,
      "type": "return",
    });

    benTrans = Transactions.fromJson(response.data);

    return benTrans.transactions;
  }

  Future<List<SingleCollection>> getCollectionTransactions(
      int page, int benId) async {
    final Response<dynamic> response =
        await dio.get<dynamic>("collection", queryParameters: <String, dynamic>{
      "page": page+1,
      "beneficiary_id": benId,
    });
    collection = Collections.fromJson(response.data);

    return collection.collectionList;
  }
    Future<List<SingleCollection>> getAgentOrderTransactions(
      int page, int benId) async {
    final Response<dynamic> response =
        await dio.get<dynamic>("stocktransactions", queryParameters: <String, dynamic>{
      "page": page+1,
      "agent_id": benId,
    });
    collection = Collections.fromJson(response.data);

    return collection.collectionList;
  }
  
}
