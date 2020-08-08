class Items {
  Items({this.itemsList});

  Items.fromJson(dynamic json) {
    if (json['data'] != null) {
      itemsList = <SingleItem>[];
      json['data'].forEach((dynamic v) {
        itemsList.add(SingleItem.fromJson(v));
      });
    }
  }

  List<SingleItem> itemsList;
}

class SingleItem {
  SingleItem(
      {this.id,
      this.itemCode,
      this.name,
      this.unit,
      this.unitPrice,
      this.price1,
      this.price2,
      this.price3,
      this.price4,
      this.price5,
      this.balanceInventory,
      this.wholesalePrice,
      this.barcode,
      this.image,
      this.vat,
      this.link,
      this.notes,
      this.createdAt,
      this.queantity,
      this.updatedAt,
      this.units});

  SingleItem.fromJson(dynamic json) {
    id = json['id'] as int;
    itemCode = json['item_code'].toString();
    name = json['name'].toString();
    unit = json['unit'].toString();
    unitPrice = json['unit_price'].toString();
    price1 = json['price1'].toString();
    price2 = json['price2'].toString();
    price3 = json['price3'].toString();
    price4 = json['price4'].toString();
    price5 = json['price5'].toString();
    balanceInventory = json['balance_inventory'] as int;
    wholesalePrice = json['wholesale_price'] as int;
    barcode = json['barcode'] as int;
    image = json['image'].toString();
    vat = json['vat'].toString();
    link = json['link'].toString();
    notes = json['notes'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    if (json['units'] != null) {
      units = <Units>[];
      json['units'].forEach((dynamic v) {
        units.add(Units.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['item_code'] = itemCode;
    data['name'] = name;
    data['unit'] = unit;
    data['unit_price'] = unitPrice;
    data['price1'] = price1;
    data['price2'] = price2;
    data['price3'] = price3;
    data['price4'] = price4;
    data['price5'] = price5;
    data['balance_inventory'] = balanceInventory;
    data['wholesale_price'] = wholesalePrice;
    data['barcode'] = barcode;
    data['image'] = image;
    data['vat'] = vat;
    data['link'] = link;
    data['notes'] = notes;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['quantity'] = queantity;
    if (units != null) {
      data['units'] = units.map((Units v) => v.toJson()).toList();
    }
    return data;
  }

  int id;
  String itemCode;
  String name;
  String unit;
  String unitPrice;
  String price1;
  String price2;
  String price3;
  String price4;
  String price5;
  int balanceInventory;
  int wholesalePrice;
  int barcode;
  String image;
  String vat;
  String link;
  String notes;
  String createdAt;
  String updatedAt;
  int queantity = 1;
  List<Units> units;
}

class SingleItemForSend {
  SingleItemForSend(
      {this.id,
      this.name,
      this.unit,
      this.unitPrice,
      this.notes,
      this.queantity,
      this.image});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['unit'] = unit;
    data['unit_price'] = unitPrice;
    data['notes'] = notes;
    data['quantity'] = queantity;
    return data;
  }

  int id;
  String name;
  String unit;
  String unitPrice;
  String image;
  String notes;
  int queantity = 1;
}

class Units {
  Units({this.id, this.name});

  Units.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }

  int id;
  String name;
}
