// To parse this JSON data, do
//
//     final checkPhoneNumberResponse = checkPhoneNumberResponseFromJson(jsonString);

import 'dart:convert';

class CheckPhoneNumberResponse {
  bool success;
  String message;
  Data data;

  CheckPhoneNumberResponse({
    this.success,
    this.message,
    this.data,
  });

  factory CheckPhoneNumberResponse.fromRawJson(String str) => CheckPhoneNumberResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CheckPhoneNumberResponse.fromJson(Map<String, dynamic> json) => CheckPhoneNumberResponse(
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
  bool status;

  Data({
    this.status,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
  };
}
