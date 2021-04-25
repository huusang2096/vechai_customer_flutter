// To parse this JSON data, do
//
//     final sellResponse = sellResponseFromJson(jsonString);

import 'dart:convert';

class SellResponse {
  bool success;
  String message;
  Data data;

  SellResponse({
    this.success,
    this.message,
    this.data,
  });

  factory SellResponse.fromRawJson(String str) => SellResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SellResponse.fromJson(Map<String, dynamic> json) => SellResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : data.toJson(),
  };
}

class Data {
  int id;
  int requestTime;
  Address address;
  RequestBy requestBy;
  dynamic acceptedBy;
  dynamic acceptedAt;
  int createdAt;
  String status;
  List<dynamic> requestItems;
  String grandTotalAmount;

  Data({
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

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"] == null ? null : json["id"],
    requestTime: json["request_time"] == null ? null : json["request_time"],
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
    requestBy: json["request_by"] == null ? null : RequestBy.fromJson(json["request_by"]),
    acceptedBy: json["accepted_by"],
    acceptedAt: json["accepted_at"],
    createdAt: json["created_at"] == null ? null : json["created_at"],
    status: json["status"] == null ? null : json["status"],
    requestItems: json["request_items"] == null ? null : List<dynamic>.from(json["request_items"].map((x) => x)),
    grandTotalAmount: json["grand_total_amount"] == null ? null : json["grand_total_amount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "request_time": requestTime == null ? null : requestTime,
    "address": address == null ? null : address.toJson(),
    "request_by": requestBy == null ? null : requestBy.toJson(),
    "accepted_by": acceptedBy,
    "accepted_at": acceptedAt,
    "created_at": createdAt == null ? null : createdAt,
    "status": status == null ? null : status,
    "request_items": requestItems == null ? null : List<dynamic>.from(requestItems.map((x) => x)),
    "grand_total_amount": grandTotalAmount == null ? null : grandTotalAmount,
  };
}

class Address {
  int id;
  double lLat;
  double lLong;
  String addressTitle;
  String addressDescription;
  String localName;
  dynamic radius;

  Address({
    this.id,
    this.lLat,
    this.lLong,
    this.addressTitle,
    this.addressDescription,
    this.localName,
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
    radius: json["radius"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "l_lat": lLat == null ? null : lLat,
    "l_long": lLong == null ? null : lLong,
    "address_title": addressTitle == null ? null : addressTitle,
    "address_description": addressDescription == null ? null : addressDescription,
    "local_name": localName == null ? null : localName,
    "radius": radius,
  };
}

class RequestBy {
  int id;
  String name;
  String phoneCountryCode;
  String phoneNumber;
  String email;
  String dob;
  String sex;
  dynamic identificationNumber;
  String description;
  bool active;
  String avatar;
  dynamic currentAddress;
  String apiToken;
  String balance;
  List<Host> host;

  RequestBy({
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

  factory RequestBy.fromRawJson(String str) => RequestBy.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RequestBy.fromJson(Map<String, dynamic> json) => RequestBy(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? "" : json["name"],
    phoneCountryCode: json["phone_country_code"] == null ? null : json["phone_country_code"],
    phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
    email: json["email"] == null ? null : json["email"],
    dob: json["dob"] == null ? null : json["dob"],
    sex: json["sex"] == null ? null : json["sex"],
    identificationNumber: json["identification_number"],
    description: json["description"] == null ? null : json["description"],
    active: json["active"] == null ? null : json["active"],
    avatar: json["avatar"] == null ? null : json["avatar"],
    currentAddress: json["current_address"],
    apiToken: json["api_token"] == null ? null : json["api_token"],
    balance: json["balance"] == null ? null : json["balance"],
    host: json["host"] == null ? null : List<Host>.from(json["host"].map((x) => Host.fromJson(x))),
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
    "description": description == null ? null : description,
    "active": active == null ? null : active,
    "avatar": avatar == null ? null : avatar,
    "current_address": currentAddress,
    "api_token": apiToken == null ? null : apiToken,
    "balance": balance == null ? null : balance,
    "host": host == null ? null : List<dynamic>.from(host.map((x) => x.toJson())),
  };
}

class Host {
  int id;
  String name;
  String phone;
  String email;
  List<AcceptScrap> acceptScraps;
  List<Address> addresses;

  Host({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.acceptScraps,
    this.addresses,
  });

  factory Host.fromRawJson(String str) => Host.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Host.fromJson(Map<String, dynamic> json) => Host(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    phone: json["phone"] == null ? null : json["phone"],
    email: json["email"] == null ? null : json["email"],
    acceptScraps: json["accept_scraps"] == null ? null : List<AcceptScrap>.from(json["accept_scraps"].map((x) => AcceptScrap.fromJson(x))),
    addresses: json["addresses"] == null ? null : List<Address>.from(json["addresses"].map((x) => Address.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "phone": phone == null ? null : phone,
    "email": email == null ? null : email,
    "accept_scraps": acceptScraps == null ? null : List<dynamic>.from(acceptScraps.map((x) => x.toJson())),
    "addresses": addresses == null ? null : List<dynamic>.from(addresses.map((x) => x.toJson())),
  };
}

class AcceptScrap {
  int id;
  String hostPrice;
  Scrap scrap;

  AcceptScrap({
    this.id,
    this.hostPrice,
    this.scrap,
  });

  factory AcceptScrap.fromRawJson(String str) => AcceptScrap.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AcceptScrap.fromJson(Map<String, dynamic> json) => AcceptScrap(
    id: json["id"] == null ? null : json["id"],
    hostPrice: json["host_price"] == null ? null : json["host_price"],
    scrap: json["scrap"] == null ? null : Scrap.fromJson(json["scrap"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "host_price": hostPrice == null ? null : hostPrice,
    "scrap": scrap == null ? null : scrap.toJson(),
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
