import 'dart:convert';

abstract class BaseResponse {
  bool success;
  String message;
  bool hasData();
  static fromJson(json) {}
}

class BaseModel extends BaseResponse {
  @override
  bool hasData() {
    return success;
  }

  BaseModel({bool success, String message}) {
    this.success = success;
    this.message = message;
  }

  factory BaseModel.fromRawJson(String str) =>
      BaseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BaseModel.fromJson(Map<String, dynamic> json) => BaseModel(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}
