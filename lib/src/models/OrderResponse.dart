// To parse this JSON data, do
//
//     final orderResponse = orderResponseFromJson(jsonString);

import 'dart:convert';

class OrderResponse {
  bool success;
  String message;
  List<OrderModel> data;

  OrderResponse({
    this.success,
    this.message,
    this.data,
  });

  factory OrderResponse.fromRawJson(String str) => OrderResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderResponse.fromJson(Map<String, dynamic> json) => OrderResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<OrderModel>.from(json["data"].map((x) => OrderModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class OrderModel {
  int id;
  int requestTime;
  Address address;
  By requestBy;
  By acceptedBy;
  int acceptedAt;
  int createdAt;
  String status;
  List<RequestItem> requestItems;
  String grandTotalAmount;

  OrderModel({
    this.id,
    this.requestTime,
    this.address,
    this.requestBy,
    this.acceptedBy,
    this.acceptedAt,
    this.createdAt,
    this.status,
    this.requestItems,
    this.grandTotalAmount,
  });

  factory OrderModel.fromRawJson(String str) => OrderModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json["id"] == null ? null : json["id"],
    requestTime: json["request_time"] == null ? null : json["request_time"],
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
    requestBy: json["request_by"] == null ? null : By.fromJson(json["request_by"]),
    acceptedBy: json["accepted_by"] == null ? null : By.fromJson(json["accepted_by"]),
    acceptedAt: json["accepted_at"] == null ? null : json["accepted_at"],
    createdAt: json["created_at"] == null ? null : json["created_at"],
    status: json["status"] == null ? null : json["status"],
    requestItems: json["request_items"] == null ? null : List<RequestItem>.from(json["request_items"].map((x) => RequestItem.fromJson(x))),
    grandTotalAmount: json["grand_total_amount"] == null ? null : json["grand_total_amount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "request_time": requestTime == null ? null : requestTime,
    "address": address == null ? null : address.toJson(),
    "request_by": requestBy == null ? null : requestBy.toJson(),
    "accepted_by": acceptedBy == null ? null : acceptedBy.toJson(),
    "accepted_at": acceptedAt == null ? null : acceptedAt,
    "created_at": createdAt == null ? null : createdAt,
    "status": status == null ? null : status,
    "request_items": requestItems == null ? null : List<dynamic>.from(requestItems.map((x) => x.toJson())),
    "grand_total_amount": grandTotalAmount == null ? null : grandTotalAmount,
  };
}

class By {
  int id;
  String name;
  String phoneCountryCode;
  String phoneNumber;
  String email;
  String dob;
  String sex;
  dynamic identificationNumber;
  dynamic description;
  bool active;
  String avatar;
  Address currentAddress;
  String apiToken;
  String balance;
  List<dynamic> host;

  By({
    this.id,
    this.name,
    this.phoneCountryCode,
    this.phoneNumber,
    this.email,
    this.dob,
    this.sex,
    this.identificationNumber,
    this.description,
    this.active,
    this.avatar,
    this.currentAddress,
    this.apiToken,
    this.balance,
    this.host,
  });

  factory By.fromRawJson(String str) => By.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory By.fromJson(Map<String, dynamic> json) => By(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? "" : json["name"],
    phoneCountryCode: json["phone_country_code"] == null ? null : json["phone_country_code"],
    phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
    email: json["email"] == null ? null : json["email"],
    dob: json["dob"] == null ? null : json["dob"],
    sex: json["sex"] == null ? null : json["sex"],
    identificationNumber: json["identification_number"],
    description: json["description"],
    active: json["active"] == null ? null : json["active"],
    avatar: json["avatar"] == null ? null : json["avatar"],
    currentAddress: json["current_address"] == null ? null : Address.fromJson(json["current_address"]),
    apiToken: json["api_token"] == null ? null : json["api_token"],
    balance: json["balance"] == null ? null : json["balance"],
    host: json["host"] == null ? null : List<dynamic>.from(json["host"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "phone_country_code": phoneCountryCode == null ? null : phoneCountryCode,
    "phone_number": phoneNumber == null ? null : phoneNumber,
    "email": email == null ? null : email,
    "dob": dob == null ? null : dob,
    "sex": sex == null ? null : sex,
    "identification_number": identificationNumber,
    "description": description,
    "active": active == null ? null : active,
    "avatar": avatar == null ? null : avatar,
    "current_address": currentAddress == null ? null : currentAddress.toJson(),
    "api_token": apiToken == null ? null : apiToken,
    "balance": balance == null ? null : balance,
    "host": host == null ? null : List<dynamic>.from(host.map((x) => x)),
  };
}

class Address {
  int id;
  double lLat;
  double lLong;
  String addressTitle;
  String addressDescription;
  String localName;
  String district;
  String city;
  int radius;

  Address({
    this.id,
    this.lLat,
    this.lLong,
    this.addressTitle,
    this.addressDescription,
    this.localName,
    this.district,
    this.city,
    this.radius,
  });

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"] == null ? null : json["id"],
    lLat: json["l_lat"] == null ? null : json["l_lat"].toDouble(),
    lLong: json["l_long"] == null ? null : json["l_long"].toDouble(),
    addressTitle: json["address_title"] == null ? null : json["address_title"],
    addressDescription: json["address_description"] == null ? null : json["address_description"],
    localName: json["local_name"] == null ? null : json["local_name"],
    district: json["district"] == null ? null : json["district"],
    city: json["city"] == null ? null : json["city"],
    radius: json["radius"] == null ? null : json["radius"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "l_lat": lLat == null ? null : lLat,
    "l_long": lLong == null ? null : lLong,
    "address_title": addressTitle == null ? null : addressTitle,
    "address_description": addressDescription == null ? null : addressDescription,
    "local_name": localName == null ? null : localName,
    "district": district == null ? null : district,
    "city": city == null ? null : city,
    "radius": radius == null ? null : radius,
  };
}

class RequestItem {
  int id;
  int requestId;
  Scrap scrap;
  double weight;
  String price;
  String totalAmount;
  int createdAt;
  int updatedAt;

  RequestItem({
    this.id,
    this.requestId,
    this.scrap,
    this.weight,
    this.price,
    this.totalAmount,
    this.createdAt,
    this.updatedAt,
  });

  factory RequestItem.fromRawJson(String str) => RequestItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RequestItem.fromJson(Map<String, dynamic> json) => RequestItem(
    id: json["id"] == null ? null : json["id"],
    requestId: json["request_id"] == null ? null : json["request_id"],
    scrap: json["scrap"] == null ? null : Scrap.fromJson(json["scrap"]),
    weight: json["weight"] == null ? null : json["weight"].toDouble(),
    price: json["price"] == null ? null : json["price"],
    totalAmount: json["total_amount"] == null ? null : json["total_amount"],
    createdAt: json["created_at"] == null ? null : json["created_at"],
    updatedAt: json["updated_at"] == null ? null : json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "request_id": requestId == null ? null : requestId,
    "scrap": scrap == null ? null : scrap.toJson(),
    "weight": weight == null ? null : weight,
    "price": price == null ? null : price,
    "total_amount": totalAmount == null ? null : totalAmount,
    "created_at": createdAt == null ? null : createdAt,
    "updated_at": updatedAt == null ? null : updatedAt,
  };
}

class Scrap {
  int id;
  String name;
  String collectorPrice;
  String description;
  String image;
  int status;

  Scrap({
    this.id,
    this.name,
    this.collectorPrice,
    this.description,
    this.image,
    this.status,
  });

  factory Scrap.fromRawJson(String str) => Scrap.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Scrap.fromJson(Map<String, dynamic> json) => Scrap(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    collectorPrice: json["collector_price"] == null ? null : json["collector_price"],
    description: json["description"] == null ? null : json["description"],
    image: json["image"] == null ? null : json["image"],
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "collector_price": collectorPrice == null ? null : collectorPrice,
    "description": description == null ? null : description,
    "image": image == null ? null : image,
    "status": status == null ? null : status,
  };
}
