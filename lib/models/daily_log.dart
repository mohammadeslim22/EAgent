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
    transactionsCount = int.parse(json['transactions_count'].toString());
    tBeneficiariryCount = int.parse(json['t_beneficiariry_count'].toString());
    orderCount = int.parse(json['order_count'].toString());
    returnCount = int.parse(json['return_count'].toString());
    totalOrderCount = int.parse(json['total_order_count'].toString());
    totalReturnCount = int.parse(json['total_return_count'].toString());
    totalCollectionCount = int.parse(json['total_collection_count'].toString());
    collectionCount = int.parse(json['collection_count'].toString());
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
