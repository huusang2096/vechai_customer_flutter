// To parse this JSON data, do
//
//     final momoHistoryWithdrawalResponse = momoHistoryWithdrawalResponseFromJson(jsonString);

import 'dart:convert';

import 'package:veca_customer/src/models/AccountResponse.dart';

class MomoHistoryWithdrawalResponse {
  MomoHistoryWithdrawalResponse({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<MomoObject> data;

  factory MomoHistoryWithdrawalResponse.fromRawJson(String str) =>
      MomoHistoryWithdrawalResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MomoHistoryWithdrawalResponse.fromJson(Map<String, dynamic> json) =>
      MomoHistoryWithdrawalResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<MomoObject>.from(
                json["data"].map((x) => MomoObject.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class MomoObject {
  MomoObject({
    this.id,
    this.user,
    this.acceptedBy,
    this.amount,
    this.fee,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  Account user;
  dynamic acceptedBy;
  int amount;
  double fee;
  String status;
  int createdAt;
  int updatedAt;

  factory MomoObject.fromRawJson(String str) =>
      MomoObject.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MomoObject.fromJson(Map<String, dynamic> json) => MomoObject(
        id: json["id"] == null ? null : json["id"],
        user: json["user"] == null ? null : Account.fromJson(json["user"]),
        acceptedBy: json["accepted_by"],
        amount: json["amount"] == null ? null : json["amount"],
        fee: json["fee"] == null ? null : json["fee"].toDouble(),
        status: json["status"] == null ? null : json["status"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "user": user == null ? null : user.toJson(),
        "accepted_by": acceptedBy,
        "amount": amount == null ? null : amount,
        "fee": fee == null ? null : fee,
        "status": status == null ? null : status,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
      };
}
