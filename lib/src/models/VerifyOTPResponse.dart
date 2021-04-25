// To parse this JSON data, do
//
//     final verifyOtpResponse = verifyOtpResponseFromJson(jsonString);

import 'dart:convert';

class VerifyOtpResponse {
  bool success;
  String message;
  Data data;

  VerifyOtpResponse({
    this.success,
    this.message,
    this.data,
  });

  factory VerifyOtpResponse.fromRawJson(String str) => VerifyOtpResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) => VerifyOtpResponse(
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
  String verifyToken;

  Data({
    this.verifyToken,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    verifyToken: json["verify_token"] == null ? null : json["verify_token"],
  );

  Map<String, dynamic> toJson() => {
    "verify_token": verifyToken == null ? null : verifyToken,
  };
}
