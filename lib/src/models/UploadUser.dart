// To parse this JSON data, do
//
//     final uploadUser = uploadUserFromJson(jsonString);

import 'dart:convert';

class UploadUser {
  String name;
  String email;
  String sex;
  String dob;
  String description;
  Host host;

  UploadUser({
    this.name,
    this.email,
    this.sex,
    this.dob,
    this.description,
    this.host,
  });

  factory UploadUser.fromRawJson(String str) => UploadUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UploadUser.fromJson(Map<String, dynamic> json) => UploadUser(
    name: json["name"] == null ? null : json["name"],
    email: json["email"] == null ? null : json["email"],
    sex: json["sex"] == null ? null : json["sex"],
    dob: json["dob"] == null ? null : json["dob"],
    description: json["description"] == null ? null : json["description"],
    host: json["host"] == null ? null : Host.fromJson(json["host"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "email": email == null ? null : email,
    "sex": sex == null ? null : sex,
    "dob": dob == null ? null : dob,
    "description": description == null ? null : description,
    "host": host == null ? null : host.toJson(),
  };
}

class Host {
  String name;
  String phone;
  String email;
  List<Address> addresses;

  Host({
    this.name,
    this.phone,
    this.email,
    this.addresses,
  });

  factory Host.fromRawJson(String str) => Host.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Host.fromJson(Map<String, dynamic> json) => Host(
    name: json["name"] == null ? null : json["name"],
    phone: json["phone"] == null ? null : json["phone"],
    email: json["email"] == null ? null : json["email"],
    addresses: json["addresses"] == null ? null : List<Address>.from(json["addresses"].map((x) => Address.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "phone": phone == null ? null : phone,
    "email": email == null ? null : email,
    "addresses": addresses == null ? null : List<dynamic>.from(addresses.map((x) => x.toJson())),
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
