// To parse this JSON data, do
//
//     final scrapResponse = scrapResponseFromJson(jsonString);

import 'dart:convert';

class ScrapResponse {
  bool success;
  String message;
  List<ScrapModel> data;

  ScrapResponse({
    this.success,
    this.message,
    this.data,
  });

  factory ScrapResponse.fromRawJson(String str) => ScrapResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScrapResponse.fromJson(Map<String, dynamic> json) => ScrapResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<ScrapModel>.from(json["data"].map((x) => ScrapModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class  ScrapModel{
  int id;
  String name;
  String collectorPrice;
  String description;
  String image;
  int status;

  ScrapModel({
    this.id,
    this.name,
    this.collectorPrice,
    this.description,
    this.image,
    this.status,
  });

  factory ScrapModel.fromRawJson(String str) => ScrapModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScrapModel.fromJson(Map<String, dynamic> json) => ScrapModel(
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
