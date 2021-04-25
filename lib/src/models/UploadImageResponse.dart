// To parse this JSON data, do
//
//     final uploadImageResponse = uploadImageResponseFromJson(jsonString);

import 'dart:convert';

class UploadImageResponse {
  bool success;
  String message;
  Data data;

  UploadImageResponse({
    this.success,
    this.message,
    this.data,
  });

  factory UploadImageResponse.fromRawJson(String str) => UploadImageResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UploadImageResponse.fromJson(Map<String, dynamic> json) => UploadImageResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : data.toJson(),
  };
}

class Data {
  int id;
  String path;
  String name;
  String extension;
  dynamic order;
  bool featured;

  Data({
    this.id,
    this.path,
    this.name,
    this.extension,
    this.order,
    this.featured,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"] == null ? null : json["id"],
    path: json["path"] == null ? null : json["path"],
    name: json["name"] == null ? null : json["name"],
    extension: json["extension"] == null ? null : json["extension"],
    order: json["order"],
    featured: json["featured"] == null ? null : json["featured"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "path": path == null ? null : path,
    "name": name == null ? null : name,
    "extension": extension == null ? null : extension,
    "order": order,
    "featured": featured == null ? null : featured,
  };
}
