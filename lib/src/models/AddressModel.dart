// To parse this JSON data, do
//
//     final addressModel = addressModelFromJson(jsonString);

import 'dart:convert';

class AddressModel {
  int id;
  double lLat;
  double lLong;
  String addressTitle;
  String addressDescription;
  String localName;
  String district;
  String city;
  int radius;
  bool isSelect;

  AddressModel({
    this.id,
    this.lLat,
    this.lLong,
    this.addressTitle,
    this.addressDescription,
    this.localName,
    this.district,
    this.city,
    this.radius,
    this.isSelect
  });

  AddressModel copyWith({
    int id,
    double lLat,
    double lLong,
    String addressTitle,
    String addressDescription,
    String localName,
    String district,
    String city,
    int radius,
    bool isSelect
  }) =>
      AddressModel(
        id: id ?? this.id,
        lLat: lLat ?? this.lLat,
        lLong: lLong ?? this.lLong,
        addressTitle: addressTitle ?? this.addressTitle,
        addressDescription: addressDescription ?? this.addressDescription,
        localName: localName ?? this.localName,
        district: district ?? this.district,
        city: city ?? this.city,
        radius: radius ?? this.radius,
          isSelect: isSelect ?? this.isSelect
      );

  factory AddressModel.fromRawJson(String str) => AddressModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    id: json["id"] == null ? null : json["id"],
    lLat: json["l_lat"] == null ? null : json["l_lat"].toDouble(),
    lLong: json["l_long"] == null ? null : json["l_long"].toDouble(),
    addressTitle: json["address_title"] == null ? null : json["address_title"],
    addressDescription: json["address_description"] == null ? null : json["address_description"],
    localName: json["local_name"] == null ? null : json["local_name"],
    district: json["district"] == null ? null : json["district"],
    city: json["city"] == null ? null : json["city"],
    radius: json["radius"] == null ? null : json["radius"], isSelect: false
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
