// To parse this JSON data, do
//
//     final userLevelResponse = userLevelResponseFromJson(jsonString);

import 'dart:convert';

class UserLevelResponse {
  bool success;
  String message;
  Data data;

  UserLevelResponse({
    this.success,
    this.message,
    this.data,
  });

  factory UserLevelResponse.fromRawJson(String str) =>
      UserLevelResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserLevelResponse.fromJson(Map<String, dynamic> json) =>
      UserLevelResponse(
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
  List<UserLevel> userLevels;

  Data({
    this.userLevels,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userLevels: json["user_levels"] == null
            ? null
            : List<UserLevel>.from(
                json["user_levels"].map((x) => UserLevel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user_levels": userLevels == null
            ? null
            : List<dynamic>.from(userLevels.map((x) => x.toJson())),
      };
}

class UserLevel {
  int id;
  String name;
  String cost;

  UserLevel({
    this.id,
    this.name,
    this.cost,
  });

  factory UserLevel.fromRawJson(String str) =>
      UserLevel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserLevel.fromJson(Map<String, dynamic> json) => UserLevel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        cost: json["cost"] == null ? null : json["cost"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "cost": cost == null ? null : cost,
      };
}
