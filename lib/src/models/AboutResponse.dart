// To parse this JSON data, do
//
//     final aboutResonse = aboutResonseFromJson(jsonString);

import 'dart:convert';

class AboutResponse {
  AboutResponse({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  Data data;

  factory AboutResponse.fromRawJson(String str) => AboutResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AboutResponse.fromJson(Map<String, dynamic> json) => AboutResponse(
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
  Data({
    this.supportPhone,
    this.supportEmail,
    this.companyAddress,
    this.companyDescription,
  });

  String supportPhone;
  String supportEmail;
  String companyAddress;
  String companyDescription;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    supportPhone: json["support_phone"] == null ? null : json["support_phone"],
    supportEmail: json["support_email"] == null ? null : json["support_email"],
    companyAddress: json["company_address"] == null ? null : json["company_address"],
    companyDescription: json["company_description"] == null ? null : json["company_description"],
  );

  Map<String, dynamic> toJson() => {
    "support_phone": supportPhone == null ? null : supportPhone,
    "support_email": supportEmail == null ? null : supportEmail,
    "company_address": companyAddress == null ? null : companyAddress,
    "company_description": companyDescription == null ? null : companyDescription,
  };
}
