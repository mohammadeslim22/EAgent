class DailyLog {
  DailyLog(
      {this.transactionsCount,
      this.tBeneficiariryCount,
      this.orderCount,
      this.returnCount,
      this.totalOrderCount,
      this.totalReturnCount,
      this.totalCollectionCount,
      this.collectionCount});

  DailyLog.fromJson(dynamic json) {
    print("from json : ${json['transactions_count']}");
    // transactionsCount = json['transactions_count'] as int;

    tBeneficiariryCount = json['t_beneficiariry_count'] as int;
    transactionsCount = json['transactions_count'] as int;
    // tBeneficiariryCount = int.parse(json['t_beneficiariry_count'].toString());
    orderCount = json['order_count'] as int;
    returnCount = json['return_count'] as int;
    totalOrderCount = json['total_order_count'] as int;
    totalReturnCount = json['total_return_count'] as int;
    totalCollectionCount = json['total_collection_count'] as int;
    collectionCount = json['collection_count'] as int;
  }
  int transactionsCount;
  int tBeneficiariryCount;
  int orderCount;
  int returnCount;
  int totalOrderCount;
  int totalReturnCount;
  int totalCollectionCount;
  int collectionCount;
}
