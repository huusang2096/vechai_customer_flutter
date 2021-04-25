// To parse this JSON data, do
//
//     final accountResponse = accountResponseFromJson(jsonString);

import 'dart:convert';

class AccountResponse {
  bool success;
  String message;
  Account data;

  AccountResponse({
    this.success,
    this.message,
    this.data,
  });

  factory AccountResponse.fromRawJson(String str) =>
      AccountResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AccountResponse.fromJson(Map<String, dynamic> json) =>
      AccountResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Account.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data.toJson(),
      };
}

class Account {
  int id;
  String name;
  String phoneCountryCode;
  String phoneNumber;
  String email;
  dynamic dob;
  String sex;
  dynamic identificationNumber;
  dynamic description;
  bool active;
  String avatar;
  CurrentAddress currentAddress;
  String apiToken;
  String balance;
  List<dynamic> host;

  Account({
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

  factory Account.fromRawJson(String str) => Account.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? "" : json["name"],
        phoneCountryCode: json["phone_country_code"] == null
            ? ""
            : json["phone_country_code"],
        phoneNumber: json["phone_number"] == null ? "" : json["phone_number"],
        email: json["email"] == null ? "" : json["email"],
        dob: json["dob"] == null ? null : json["dob"],
        sex: json["sex"] == null ? "Male" : json["sex"],
        identificationNumber: json["identification_number"] == null
            ? ""
            : json["identification_number"],
        description: json["description"] == null ? "" : json["description"],
        active: json["active"] == null ? "" : json["active"],
        avatar: json["avatar"] == null ? "" : json["avatar"],
        currentAddress: json["current_address"] == null
            ? null
            : CurrentAddress.fromJson(json["current_address"]),
        apiToken: json["api_token"] == null ? "" : json["api_token"],
        balance: json["balance"] == null ? "" : json["balance"],
        host: json["host"] == null
            ? null
            : List<dynamic>.from(json["host"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "phone_country_code":
            phoneCountryCode == null ? null : phoneCountryCode,
        "phone_number": phoneNumber == null ? null : phoneNumber,
        "email": email == null ? null : email,
        "dob": dob == null ? null : dob,
        "sex": sex == null ? null : sex,
        "identification_number":
            identificationNumber == null ? null : identificationNumber,
        "description": description == null ? null : description,
        "active": active == null ? null : active,
        "avatar": avatar == null ? null : avatar,
        "current_address":
            currentAddress == null ? null : currentAddress.toJson(),
        "api_token": apiToken == null ? null : apiToken,
        "balance": balance == null ? null : balance,
        "host": host == null ? null : List<dynamic>.from(host.map((x) => x)),
      };
}

class CurrentAddress {
  int id;
  double lLat;
  double lLong;
  String addressTitle;
  String addressDescription;
  String localName;
  String district;
  String city;
  dynamic radius;

  CurrentAddress({
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

  factory CurrentAddress.fromRawJson(String str) =>
      CurrentAddress.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CurrentAddress.fromJson(Map<String, dynamic> json) => CurrentAddress(
        id: json["id"] == null ? null : json["id"],
        lLat: json["l_lat"] == null ? null : json["l_lat"].toDouble(),
        lLong: json["l_long"] == null ? null : json["l_long"].toDouble(),
        addressTitle:
            json["address_title"] == null ? null : json["address_title"],
        addressDescription: json["address_description"] == null
            ? null
            : json["address_description"],
        localName: json["local_name"] == null ? null : json["local_name"],
        district: json["district"] == null ? null : json["district"],
        city: json["city"] == null ? null : json["city"],
        radius: json["radius"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "l_lat": lLat == null ? null : lLat,
        "l_long": lLong == null ? null : lLong,
        "address_title": addressTitle == null ? null : addressTitle,
        "address_description":
            addressDescription == null ? null : addressDescription,
        "local_name": localName == null ? null : localName,
        "district": district == null ? null : district,
        "city": city == null ? null : city,
        "radius": radius,
      };
}
