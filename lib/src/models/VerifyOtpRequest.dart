// To parse this JSON data, do
//
//     final verifyOtpRequest = verifyOtpRequestFromJson(jsonString);

import 'dart:convert';

class VerifyOtpRequest {
  String phoneCountryCode;
  String phoneNumber;
  String otpCode;

  VerifyOtpRequest({
    this.phoneCountryCode,
    this.phoneNumber,
    this.otpCode,
  });

  factory VerifyOtpRequest.fromRawJson(String str) => VerifyOtpRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) => VerifyOtpRequest(
    phoneCountryCode: json["phone_country_code"] == null ? null : json["phone_country_code"],
    phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
    otpCode: json["otp_code"] == null ? null : json["otp_code"],
  );

  Map<String, dynamic> toJson() => {
    "phone_country_code": phoneCountryCode == null ? null : phoneCountryCode,
    "phone_number": phoneNumber == null ? null : phoneNumber,
    "otp_code": otpCode == null ? null : otpCode,
  };
}
