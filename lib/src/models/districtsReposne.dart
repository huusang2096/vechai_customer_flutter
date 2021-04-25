// To parse this JSON data, do
//
//     final districtsReposne = districtsReposneFromJson(jsonString);

import 'dart:convert';

import 'package:veca_customer/src/models/AddressResponse.dart';
import 'package:veca_customer/src/models/basemodel.dart';


class DistrictsReposne extends BaseResponse{
  bool success;
  String message;
  List<District> data;

  DistrictsReposne({
    this.success,
    this.message,
    this.data,
  });

  factory DistrictsReposne.fromRawJson(String str) => DistrictsReposne.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DistrictsReposne.fromJson(Map<String, dynamic> json) => DistrictsReposne(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<District>.from(json["data"].map((x) => District.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };

  @override
  bool hasData() {
    // TODO: implement hasData
    return data != null;
  }
}

