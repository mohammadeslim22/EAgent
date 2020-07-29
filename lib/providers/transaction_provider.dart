import 'package:agent_second/models/ben.dart';
import 'package:agent_second/models/collection.dart';
import 'package:agent_second/models/transactions.dart';
import 'package:agent_second/util/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TransactionProvider with ChangeNotifier {
  Ben ben;
  Transactions benTrans;
  Transaction transaction;
  Collections collection;
  Future<List<Transaction>> getOrdersTransactions(int page, int benId) async {
    final Response<dynamic> response = await dio
        .get<dynamic>("btransactions", queryParameters: <String, dynamic>{
      "page": page,
      "beneficiary_id": benId,
      // "transaction_type": 1,
    });
    print(response.data);

    benTrans = Transactions.fromJson(response.data);

    return benTrans.transactions;
  }

  Future<List<Transaction>> getReturnTransactions(int page, int benId) async {
    final Response<dynamic> response = await dio
        .get<dynamic>("btransactions", queryParameters: <String, dynamic>{
      "page": page,
      "beneficiary_id": benId,
      //"transaction_type": 2,
    });
    print(response.data);
    benTrans = Transactions.fromJson(response.data);

    return benTrans.transactions;
  }

  Future<List<SingleCollection>> getCollectionTransactions(
      int page, int benId) async {
    final Response<dynamic> response =
        await dio.get<dynamic>("collection", queryParameters: <String, dynamic>{
      "page": page,
      "beneficiary_id": benId,
    });

    collection = Collections.fromJson(response.data);

    return collection.collectionList;
  }
}
