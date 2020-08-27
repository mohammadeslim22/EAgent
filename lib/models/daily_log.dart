class DailyLog {
  DailyLog(
      {this.transactionsCount,
      this.tBeneficiariryCount,
      this.orderCount,
      this.returnCount,
      this.totalOrderCount,
      this.totalReturnCount,
      this.totalCollectionCount,
      this.collectionCount,
      this.benIds,
      this.totalOrdered,
      this.totalReturned});

  DailyLog.fromJson(dynamic json) {
    // transactionsCount = json['transactions_count'] as int;

    tBeneficiariryCount = json['t_beneficiary_count'] as int;
    transactionsCount = json['transactions_count'] as int;
    // tBeneficiariryCount = int.parse(json['t_beneficiariry_count'].toString());
    orderCount = json['order_count'] as int;
    returnCount = json['return_count'] as int;
    totalOrderCount = json['total_order_count'].toString();
    totalReturnCount = json['total_return_count'].toString();
    totalCollectionCount = json['total_collection_count'] as int;
    collectionCount = json['collection_count'] as int;
    benIds = json['ben_ids'].cast<int>() as List<int>;
    if(json['total_ordered']!=null){
          totalOrdered = json['total_confirmed'].toString();
    totalReturned = json['total_returned_confirmed'].toString();
    }

  }
  int transactionsCount;
  int tBeneficiariryCount;
  int orderCount;
  int returnCount;
  String totalOrderCount;
  String totalReturnCount;
  int totalCollectionCount;
  int collectionCount;
  List<int> benIds;
  String totalOrdered;
  String totalReturned;
}
