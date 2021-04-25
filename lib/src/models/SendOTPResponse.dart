// To parse this JSON data, do
//
//     final checkPhoneNumberResponse = checkPhoneNumberResponseFromJson(jsonString);

import 'dart:convert';

class SendOTPResponse {
  bool success;
  String message;
  List<dynamic> data;

  SendOTPResponse({
    this.success,
    this.message,
    this.data,
  });

  factory SendOTPResponse.fromRawJson(String str) => SendOTPResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SendOTPResponse.fromJson(Map<String, dynamic> json) => SendOTPResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<dynamic>.from(json["data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x)),
  };
}

