// To parse this JSON data, do
//
//     final userAddressResponse = userAddressResponseFromJson(jsonString);

import 'dart:convert';

import 'package:veca_customer/src/models/AddressModel.dart';


class UserAddressResponse {
  bool success;
  String message;
  List<AddressModel> data;

  UserAddressResponse({
    this.success,
    this.message,
    this.data,
  });

  factory UserAddressResponse.fromRawJson(String str) => UserAddressResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserAddressResponse.fromJson(Map<String, dynamic> json) => UserAddressResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<AddressModel>.from(json["data"].map((x) => AddressModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}
