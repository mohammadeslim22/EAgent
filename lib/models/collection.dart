class Collections {


  Collections({this.collectionList});

  Collections.fromJson(dynamic json) {
    if (json['data'] != null) {
      collectionList =  <SingleCollection>[];
      json['data'].forEach((dynamic v) {
        collectionList.add( SingleCollection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    if (collectionList != null) {
      data['data'] = collectionList.map((SingleCollection v) => v.toJson()).toList();
    }
    return data;
  }
    List<SingleCollection> collectionList;
}

class SingleCollection {


  SingleCollection(
      {this.id,
      this.beneficiaryId,
      this.userId,
      this.vehicle,
      this.amount,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.user,
      });

  SingleCollection.fromJson(dynamic json) {
    id = json['id']as int;
    beneficiaryId = json['beneficiary_id']as int;
    userId = json['user_id']as int;
    vehicle = json['vehicle'].toString();
    amount = json['amount']as int;
    status = json['status'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    user = json['user'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['beneficiary_id'] = beneficiaryId;
    data['user_id'] = userId;
    data['vehicle'] =vehicle;
    data['amount'] = amount;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['user'] = user;
    return data;
  }
    int id;
  int beneficiaryId;
  int userId;
  String vehicle;
  int amount;
  String status;
  String createdAt;
  String updatedAt;
  String user;
}
