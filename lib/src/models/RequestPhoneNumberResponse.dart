// To parse this JSON data, do
//
//     final requestPhoneNumberResponse = requestPhoneNumberResponseFromJson(jsonString);

import 'dart:convert';

class RequestPhoneNumberResponse {
  String phoneCountryCode;
  String phoneNumber;
  String iSOCode;

  RequestPhoneNumberResponse({
    this.phoneCountryCode,
    this.phoneNumber,
  });

  factory RequestPhoneNumberResponse.fromRawJson(String str) => RequestPhoneNumberResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RequestPhoneNumberResponse.fromJson(Map<String, dynamic> json) => RequestPhoneNumberResponse(
    phoneCountryCode: json["phone_country_code"] == null ? null : json["phone_country_code"],
    phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
  );

  Map<String, dynamic> toJson() => {
    "phone_country_code": phoneCountryCode == null ? null : phoneCountryCode,
    "phone_number": phoneNumber == null ? null : phoneNumber,
  };
}
