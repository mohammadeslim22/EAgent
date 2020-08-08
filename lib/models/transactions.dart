class Transactions {
  Transactions({this.transactions});

  Transactions.fromJson(dynamic json) {
    if (json['data'] != null) {
      transactions = <Transaction>[];
      json['data'].forEach((dynamic v) {
        transactions.add(Transaction.fromJson(v));
      });
    }
  }

  dynamic toJson() {
    final dynamic data = <dynamic>{};
    if (data != null) {
      data['data'] = data.map<dynamic>((dynamic v) => v.toJson()).toList();
    }
    return data;
  }

  List<Transaction> transactions;
}

class Transaction {
  Transaction(
      {this.id,
      this.beneficiary,
      this.agent,
      this.transDate,
      this.address,
      this.vehicleId,
      this.status,
      this.type,
      this.notes,
      this.amount,
      this.shortage,
      this.latitude,
      this.longitude,
      this.createdAt,
      this.details});

  Transaction.fromJson(dynamic json) {
    id = json['id'] as int;
    beneficiary = json['beneficiary'].toString();
    agent = json['agent'].toString();
    transDate = json['trans_date'].toString();
    address = json['address'].toString();
    vehicleId = json['vehicle_id'] as int;
    status = json['status'].toString();
    type = json['type'].toString();
    notes = json['notes'].toString();
    amount = json['amount'] as int;
    shortage = json['shortage'] as int;
    latitude = json['latitude'] as double;
    longitude = json['longitude'] as double;
    createdAt = json['created_at'].toString();
    if (json['details'] != null) {
      details = <MiniItems>[];
      json['details'].forEach((dynamic v) {
        details.add(MiniItems.fromJson(v));
      });
    }
  }

  dynamic toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['beneficiary'] = beneficiary;
    data['agent'] = agent;
    data['trans_date'] = transDate;
    data['address'] = address;
    data['vehicle_id'] = vehicleId;
    data['status'] = status;
    data['type'] = type;
    data['notes'] = notes;
    data['amount'] = amount;
    data['shortage'] = shortage;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['created_at'] = createdAt;
    if (details != null) {
      data['details'] = details.map((MiniItems v) => v.toJson()).toList();
    }
    return data;
  }

  int id;
  String beneficiary;
  String agent;
  String transDate;
  String address;
  int vehicleId;
  String status;
  String type;
  String notes;
  int amount;
  int shortage;
  double latitude;
  double longitude;
  String createdAt;
  List<MiniItems> details;
}

class MiniItems {
  MiniItems(
      {this.id,
      this.itemId,
      this.unit,
      this.itemPrice,
      this.quantity,
      this.notes});

  MiniItems.fromJson(dynamic json) {
    id = json['id'] as int;
    itemId = json['item_id'] as int;
    unit = json['unit'] as int;
    itemPrice = json['item_price'] as int;
    quantity = json['quantity'] as int;
    notes = json['notes'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['item_id'] = itemId;
    data['unit'] = unit;
    data['item_price'] = itemPrice;
    data['quantity'] = quantity;
    data['notes'] = notes;
    return data;
  }

  int id;
  int itemId;
  int unit;
  int itemPrice;
  int quantity;
  String notes;
}
