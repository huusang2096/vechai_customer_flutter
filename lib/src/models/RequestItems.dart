
import 'dart:convert';

class RequestItems {
  bool success;
  String message;

  RequestItems({
    this.success,
    this.message,
  });

  factory RequestItems.fromRawJson(String str) => RequestItems.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RequestItems.fromJson(Map<String, dynamic> json) => RequestItems(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
  };
}
