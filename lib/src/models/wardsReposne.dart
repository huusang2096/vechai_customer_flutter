// To parse this JSON data, do
//
//     final wardsReposne = wardsReposneFromJson(jsonString);

import 'dart:convert';

import 'package:veca_customer/src/models/AddressResponse.dart';
import 'package:veca_customer/src/models/basemodel.dart';


class WardsReposne extends BaseResponse{
  bool success;
  String message;
  List<Wards> data;

  WardsReposne({
    this.success,
    this.message,
    this.data,
  });

  factory WardsReposne.fromRawJson(String str) => WardsReposne.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WardsReposne.fromJson(Map<String, dynamic> json) => WardsReposne(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<Wards>.from(json["data"].map((x) => Wards.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };

  @override
  bool hasData() {
    // TODO: implement hasData
    return data != null;  }
}
