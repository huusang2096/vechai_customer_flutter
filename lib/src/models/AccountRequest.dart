// To parse this JSON data, do
//
//     final accountRequest = accountRequestFromJson(jsonString);

import 'dart:convert';

class AccountRequest {
  String otpToken;
  String phoneCountryCode;
  String phoneNumber;
  String newPassword;
  int accountType;
  String deviceId;
  String platform;

  AccountRequest({
    this.otpToken,
    this.phoneCountryCode,
    this.phoneNumber,
    this.newPassword,
    this.accountType,
    this.deviceId,
    this.platform
  });

  factory AccountRequest.fromRawJson(String str) => AccountRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AccountRequest.fromJson(Map<String, dynamic> json) => AccountRequest(
    otpToken: json["otp_token"] == null ? null : json["otp_token"],
    phoneCountryCode: json["phone_country_code"] == null ? null : json["phone_country_code"],
    phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
    newPassword: json["new_password"] == null ? null : json["new_password"],
    accountType: json["account_type"] == null ? null : json["account_type"],
    deviceId: json["device_id"] == null ? null : json["device_id"],
    platform: json["platform"] == null ? null : json["platform"],
  );

  Map<String, dynamic> toJson() => {
    "otp_token": otpToken == null ? null : otpToken,
    "phone_country_code": phoneCountryCode == null ? null : phoneCountryCode,
    "phone_number": phoneNumber == null ? null : phoneNumber,
    "new_password": newPassword == null ? null : newPassword,
    "account_type": accountType == null ? null : accountType,
    "device_id": deviceId == null ? null : deviceId,
    "platform": platform == null ? null : platform,
  };
}
