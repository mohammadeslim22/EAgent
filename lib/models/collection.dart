class Collection {
  String status;
  Results results;

  Collection({this.status, this.results});

  Collection.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    results =
        json['results'] != null ? new Results.fromJson(json['results']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.results != null) {
      data['results'] = this.results.toJson();
    }
    return data;
  }
}

class Results {
  int currentPage;
  List<Data> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  Null nextPageUrl;
  String path;
  int perPage;
  Null prevPageUrl;
  int to;
  int total;

  Results(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Results.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Data {
  int id;
  String date;
  int agentId;
  int vehicleId;
  int beneficiaryId;
  int amount;
  int status;
  String createdAt;
  String updatedAt;
  Vehicle vehicle;
  Vehicle beneficiary;

  Data(
      {this.id,
      this.date,
      this.agentId,
      this.vehicleId,
      this.beneficiaryId,
      this.amount,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.vehicle,
      this.beneficiary});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    agentId = json['agent_id'];
    vehicleId = json['vehicle_id'];
    beneficiaryId = json['beneficiary_id'];
    amount = json['amount'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    vehicle =
        json['vehicle'] != null ? new Vehicle.fromJson(json['vehicle']) : null;
    beneficiary = json['beneficiary'] != null
        ? new Vehicle.fromJson(json['beneficiary'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['agent_id'] = this.agentId;
    data['vehicle_id'] = this.vehicleId;
    data['beneficiary_id'] = this.beneficiaryId;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.vehicle != null) {
      data['vehicle'] = this.vehicle.toJson();
    }
    if (this.beneficiary != null) {
      data['beneficiary'] = this.beneficiary.toJson();
    }
    return data;
  }
}

class Vehicle {
  int id;
  String name;

  Vehicle({this.id, this.name});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}