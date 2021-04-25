// To parse this JSON data, do
//
//     final scrapDetailResponse = scrapDetailResponseFromJson(jsonString);

import 'dart:convert';

class ScrapDetailResponse {
  bool success;
  String message;
  ScrapDetailModel data;

  ScrapDetailResponse({
    this.success,
    this.message,
    this.data,
  });

  factory ScrapDetailResponse.fromRawJson(String str) => ScrapDetailResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScrapDetailResponse.fromJson(Map<String, dynamic> json) => ScrapDetailResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : ScrapDetailModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : data.toJson(),
  };
}

class ScrapDetailModel {
  int id;
  String name;
  String collectorPrice;
  String description;
  String image;
  int status;

  ScrapDetailModel({
    this.id,
    this.name,
    this.collectorPrice,
    this.description,
    this.image,
    this.status,
  });

  factory ScrapDetailModel.fromRawJson(String str) => ScrapDetailModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScrapDetailModel.fromJson(Map<String, dynamic> json) => ScrapDetailModel(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    collectorPrice: json["collector_price"] == null ? null : json["collector_price"],
    description: json["description"] == null ? null : json["description"],
    image: json["image"] == null ? null : json["image"],
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "collector_price": collectorPrice == null ? null : collectorPrice,
    "description": description == null ? null : description,
    "image": image == null ? null : image,
    "status": status == null ? null : status,
  };
}
