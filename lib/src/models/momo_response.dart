// To parse this JSON data, do
//
//     final momoResponse = momoResponseFromJson(jsonString);

import 'dart:convert';

import 'package:veca_customer/src/models/momo_history_withdrawal_response.dart';

class MomoResponse {
  MomoResponse({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  MomoObject data;

  factory MomoResponse.fromRawJson(String str) =>
      MomoResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MomoResponse.fromJson(Map<String, dynamic> json) => MomoResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : MomoObject.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data.toJson(),
      };
}
