// To parse this JSON data, do
//
//     final addressModel = addressModelFromJson(jsonString);

import 'dart:convert';

import 'package:veca_customer/src/models/AddressModel.dart';

class AddAddressResponse {
  bool success;
  String message;
  AddressModel data;

  AddAddressResponse({
    this.success,
    this.message,
    this.data,
  });

  factory AddAddressResponse.fromRawJson(String str) => AddAddressResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddAddressResponse.fromJson(Map<String, dynamic> json) => AddAddressResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : AddressModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : data.toJson(),
  };
}
