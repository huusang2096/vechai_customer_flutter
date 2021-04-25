// To parse this JSON data, do
//
//     final loginAccountRequest = loginAccountRequestFromJson(jsonString);

import 'dart:convert';

class LoginAccountRequest {
  String phoneCountryCode;
  String phoneNumber;
  String password;
  String deviceId;
  int accountType;
  String platform;
  String isoCode;

  LoginAccountRequest({
    this.phoneCountryCode,
    this.phoneNumber,
    this.password,
    this.deviceId,
    this.accountType,
    this.platform
  });

  factory LoginAccountRequest.fromRawJson(String str) => LoginAccountRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginAccountRequest.fromJson(Map<String, dynamic> json) => LoginAccountRequest(
    phoneCountryCode: json["phone_country_code"] == null ? null : json["phone_country_code"],
    phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
    password: json["password"] == null ? null : json["password"],
    deviceId: json["device_id"] == null ? null : json["device_id"],
    accountType: json["account_type"] == null ? null : json["account_type"],
    platform: json["platform"] == null ? null : json["platform"],
  );

  Map<String, dynamic> toJson() => {
    "phone_country_code": phoneCountryCode == null ? null : phoneCountryCode,
    "phone_number": phoneNumber == null ? null : phoneNumber,
    "password": password == null ? null : password,
    "device_id": deviceId == null ? null : deviceId,
    "account_type": accountType == null ? null : accountType,
    "platform": platform == null ? null : platform,
  };
}
