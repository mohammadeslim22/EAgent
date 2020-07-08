class Transactions {
  Transactions({this.status, this.results});

  Transactions.fromJson(dynamic json) {
    status = json['status'].toString();
    results =
        json['results'] != null ? Results.fromJson(json['results']) : null;
  }
  String status;
  Results results;
}

class Results {
  Results({
    this.transactions,
  });

  Results.fromJson(dynamic json) {
    if (json['data'] != null) {
      transactions = <Transaction>[];
      json['data'].forEach((dynamic v) {
        transactions.add(Transaction.fromJson(v));
      });
    }
  }
  List<Transaction> transactions;
}

class Transaction {
  Transaction(
      {this.id,
      this.transactionDate,
      this.transactionType,
      this.agentId,
      this.vehicleId,
      this.beneficiaryId,
      this.totalPrice,
      this.collectedAmount,
      this.deficit,
      this.status,
      this.approvedDate,
      this.location,
      this.notes,
      this.clientId,
      this.createdAt,
      this.updatedAt,
      this.items,
      this.vehicle,
      this.agent,
      this.beneficiary});

  Transaction.fromJson(dynamic json) {
    id = json['id'] as int;
    transactionDate = json['transaction_date'].toString();
    transactionType = json['transaction_type'] as int;
    agentId = json['agent_id'] as int;
    vehicleId = json['vehicle_id'] as int;
    beneficiaryId = json['beneficiary_id'] as int;
    totalPrice = json['total_price'] as int;
    collectedAmount = json['collected_amount'] as int;
    deficit = json['deficit'] as int;
    status = json['status'] as int;
    approvedDate = json['approved_date'].toString();
    location = json['location'].toString();
    notes = json['notes'].toString();
    clientId = json['client_id'] as int;
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((dynamic v) {
        items.add(Items.fromJson(v));
      });
    }
    vehicle =
        json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
    beneficiary = json['beneficiary'] != null
        ? Beneficiary.fromJson(json['beneficiary'])
        : null;
    agent = Agent.fromJson(json['agent']);
  }
  int id;
  String transactionDate;
  int transactionType;
  int agentId;
  int vehicleId;
  int beneficiaryId;
  int totalPrice;
  int collectedAmount;
  int deficit;
  int status;
  String approvedDate;
  String location;
  String notes;
  int clientId;
  String createdAt;
  String updatedAt;
  List<Items> items;
  Vehicle vehicle;
  Agent agent;
  Beneficiary beneficiary;
}

class Items {
  Items(
      {this.id,
      this.transactionId,
      this.itemId,
      this.unit,
      this.quantity,
      this.unitPrice,
      this.price,
      this.notes,
      this.item});

  Items.fromJson(dynamic json) {
    id = json['id'] as int;
    transactionId = json['transaction_id'] as int;
    itemId = json['item_id'] as int;
    unit = json['unit'].toString();
    quantity = json['quantity'] as int;
    unitPrice = json['unit_price'] as int;
    price = json['price'] as int;
    notes = json['notes'].toString();
    item = json['item'] != null ? Item.fromJson(json['item']) : null;
  }
  int id;
  int transactionId;
  int itemId;
  String unit;
  int quantity;
  int unitPrice;
  int price;
  String notes;
  Item item;
}

class Item {
  Item({this.id, this.name, this.code});

  Item.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'].toString();
    code = json['code'].toString();
  }
  int id;
  String name;
  String code;
}

class Vehicle {
  Vehicle({this.id, this.name});

  Vehicle.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'].toString();
  }
  int id;
  String name;
}

class Beneficiary {
  Beneficiary({this.id, this.name});

  Beneficiary.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'].toString();
  }
  int id;
  String name;
}

class Agent {
  Agent({this.id, this.name});

  Agent.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'].toString();
  }
  int id;
  String name;
}
