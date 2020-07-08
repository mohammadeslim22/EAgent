class BeneficiariesModel {
  BeneficiariesModel({this.status, this.results});

  BeneficiariesModel.fromJson(dynamic json) {
    status = json['status'].toString();
    results =
        json['results'] != null ? Results.fromJson(json['results']) : null;
  }
  String status;
  Results results;
}

class Results {
  Results({
    this.benList,
  });

  Results.fromJson(dynamic json) {
    if (json['data'] != null) {
      benList = <Ben>[];
      json['data'].forEach((dynamic v) {
        benList.add(Ben.fromJson(v));
      });
    }
  }
  List<Ben> benList;
}

class Ben {
  Ben(
      {this.id,
      this.name,
      this.commercialRegister,
      this.status,
      this.classificationId,
      this.agentId,
      this.contactPerson,
      this.mobile,
      this.mobile2,
      this.email,
      this.city,
      this.area,
      this.address,
      this.priceUsed,
      this.contactDetails,
      this.allowReturn,
      this.notes,
      this.location,
      this.debitLimit,
      this.balancesLimit,
      this.transactionsOrderedCount,
      this.transactionsReturnedCount,
      this.collectionsCount,
      this.transactionsOrderedSum,
      this.transactionsReturnedSum,
      this.collectionsSum,
      this.classification});

  Ben.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'].toString();
    commercialRegister = json['commercial_register'].toString();
    status = json['status'] as int;
    classificationId = json['classification_id'] as int;
    agentId = json['agent_id'] as int;
    contactPerson = json['contact_person'].toString();
    mobile = json['mobile'].toString();
    mobile2 = json['mobile2'].toString();
    email = json['email'].toString();
    city = json['city'].toString();
    area = json['area'].toString();
    address = json['address'].toString();
    priceUsed = json['price_used'] as int;
    contactDetails = json['contact_details'].toString();
    allowReturn = json['allow_return'] as int;
    notes = json['notes'].toString();
    location = json['location'].toString();
    debitLimit = json['debit_limit'].toString();
    if (json['balances_limit'] != null) {
      balancesLimit = <BalancesLimit>[];
      json['balances_limit'].forEach((dynamic v) {
        balancesLimit.add(BalancesLimit.fromJson(v));
      });
    }
    transactionsOrderedCount = json['transactions_ordered_count']as int;
    transactionsReturnedCount = json['transactions_returned_count']as int;
    collectionsCount = json['collections_count']as int;
    transactionsOrderedSum = json['transactions_ordered_sum']as int;
    transactionsReturnedSum = json['transactions_returned_sum']as int;
    collectionsSum = json['collections_sum']as int;
    classification = json['classification'] != null
        ? Classification.fromJson(json['classification'])
        : null;
  }
  int id;
  String name;
  String commercialRegister;
  int status;
  int classificationId;
  int agentId;
  String contactPerson;
  String mobile;
  String mobile2;
  String email;
  String city;
  String area;
  String address;
  int priceUsed;
  String contactDetails;
  int allowReturn;
  String notes;
  String location;
  String debitLimit;
  List<BalancesLimit> balancesLimit;
  int transactionsOrderedCount;
  int transactionsReturnedCount;
  int collectionsCount;
  int transactionsOrderedSum;
  int transactionsReturnedSum;
  int collectionsSum;

  Classification classification;
}

class BalancesLimit {
  BalancesLimit({this.itemId, this.limit, this.itemName});

  BalancesLimit.fromJson(dynamic json) {
    itemId = json['item_id'].toString();
    limit = json['limit '].toString();
    itemName = json['item_name'].toString();
  }
  String itemId;
  String limit;
  String itemName;
}

class Classification {
  Classification({this.id, this.name});

  Classification.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'].toString();
  }
  int id;
  String name;
}
