// To parse this JSON data, do
//
//     final addressRequest = addressRequestFromJson(jsonString);

import 'dart:convert';

class AddressRequest {
  double lLat;
  double lLong;
  String addressTitle;
  String addressDescription;
  String localName;
  String district;
  String city;
  int radius;

  AddressRequest({
    this.lLat,
    this.lLong,
    this.addressTitle,
    this.addressDescription,
    this.localName,
    this.district,
    this.city,
    this.radius,
  });

  factory AddressRequest.fromRawJson(String str) => AddressRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddressRequest.fromJson(Map<String, dynamic> json) => AddressRequest(
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
