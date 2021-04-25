// To parse this JSON data, do
//
//     final tokenRequest = tokenRequestFromJson(jsonString);

import 'dart:convert';

class TokenRequest {
  TokenRequest({
    this.deviceId,
    this.platform,
    this.fcmToken,
    this.accountType,
  });

  String deviceId;
  String platform;
  String fcmToken;
  int accountType;

  factory TokenRequest.fromRawJson(String str) =>
      TokenRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TokenRequest.fromJson(Map<String, dynamic> json) => TokenRequest(
        deviceId: json["device_id"] == null ? null : json["device_id"],
        platform: json["platform"] == null ? null : json["platform"],
        fcmToken: json["fcm_token"] == null ? null : json["fcm_token"],
        accountType: json["account_type"] == null ? null : json["account_type"],
      );

  Map<String, dynamic> toJson() => {
        "device_id": deviceId == null ? null : deviceId,
        "platform": platform == null ? null : platform,
        "fcm_token": fcmToken == null ? null : fcmToken,
        "account_type": accountType == null ? null : accountType,
      };
}
