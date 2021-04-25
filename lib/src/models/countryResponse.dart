// To parse this JSON data, do
//
//     final countryReposne = countryReposneFromJson(jsonString);

import 'dart:convert';

import 'package:veca_customer/src/models/AddressResponse.dart';
import 'package:veca_customer/src/models/basemodel.dart';


class CountryReposne extends BaseResponse{
  bool success;
  String message;
  List<CountryData> data;

  CountryReposne({
    this.success,
    this.message,
    this.data,
  });

  factory CountryReposne.fromRawJson(String str) => CountryReposne.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CountryReposne.fromJson(Map<String, dynamic> json) => CountryReposne(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<CountryData>.from(json["data"].map((x) => CountryData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };

  @override
  bool hasData() {
    return data != null;
  }
}
