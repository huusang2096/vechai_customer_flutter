// To parse this JSON data, do
//
//     final loginTokenRequest = loginTokenRequestFromJson(jsonString);

import 'dart:convert';

class LoginTokenRequest {
  String otpToken;
  String phoneCountryCode;
  String phoneNumber;
  String deviceId;
  int accountType;
  String platform;

  LoginTokenRequest({
    this.otpToken,
    this.phoneCountryCode,
    this.phoneNumber,
    this.deviceId,
    this.accountType,
    this.platform
  });

  factory LoginTokenRequest.fromRawJson(String str) => LoginTokenRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginTokenRequest.fromJson(Map<String, dynamic> json) => LoginTokenRequest(
    otpToken: json["otp_token"] == null ? null : json["otp_token"],
    phoneCountryCode: json["phone_country_code"] == null ? null : json["phone_country_code"],
    phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
    deviceId: json["device_id"] == null ? null : json["device_id"],
    accountType: json["account_type"] == null ? null : json["account_type"],
    platform: json["platform"] == null ? null : json["platform"],
  );

  Map<String, dynamic> toJson() => {
    "otp_token": otpToken == null ? null : otpToken,
    "phone_country_code": phoneCountryCode == null ? null : phoneCountryCode,
    "phone_number": phoneNumber == null ? null : phoneNumber,
    "device_id": deviceId == null ? null : deviceId,
    "account_type": accountType == null ? null : accountType,
    "platform": platform == null ? null : platform,
  };
}
