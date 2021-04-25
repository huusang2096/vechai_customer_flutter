// To parse this JSON data, do
//
//     final sellRequest = sellRequestFromJson(jsonString);

import 'dart:convert';

class SellRequest {
  int addressId;
  int requestTime;

  SellRequest({
    this.addressId,
    this.requestTime,
  });

  factory SellRequest.fromRawJson(String str) => SellRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SellRequest.fromJson(Map<String, dynamic> json) => SellRequest(
    addressId: json["address_id"] == null ? null : json["address_id"],
    requestTime: json["request_time"] == null ? null : json["request_time"],
  );

  Map<String, dynamic> toJson() => {
    "address_id": addressId == null ? null : addressId,
    "request_time": requestTime == null ? null : requestTime,
  };
}
