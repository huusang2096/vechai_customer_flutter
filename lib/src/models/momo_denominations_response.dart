// To parse this JSON data, do
//
//     final momoDenominationsResponse = momoDenominationsResponseFromJson(jsonString);

import 'dart:convert';

class MomoDenominationsResponse {
  MomoDenominationsResponse({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<Denomination> data;

  factory MomoDenominationsResponse.fromRawJson(String str) =>
      MomoDenominationsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MomoDenominationsResponse.fromJson(Map<String, dynamic> json) =>
      MomoDenominationsResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<Denomination>.from(json["data"].map((x) => Denomination.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Denomination {
  Denomination({
    this.id,
    this.title,
    this.amount,
  });

  int id;
  String title;
  int amount;

  factory Denomination.fromRawJson(String str) => Denomination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Denomination.fromJson(Map<String, dynamic> json) => Denomination(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        amount: json["amount"] == null ? null : json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "amount": amount == null ? null : amount,
      };
}
