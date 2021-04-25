// To parse this JSON data, do
//
//     final changePassRequest = changePassRequestFromJson(jsonString);

import 'dart:convert';

class ChangePassRequest {
  ChangePassRequest({
    this.oldPassword,
    this.newPassword,
  });

  String oldPassword;
  String newPassword;

  factory ChangePassRequest.fromRawJson(String str) => ChangePassRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChangePassRequest.fromJson(Map<String, dynamic> json) => ChangePassRequest(
    oldPassword: json["old_password"] == null ? null : json["old_password"],
    newPassword: json["new_password"] == null ? null : json["new_password"],
  );

  Map<String, dynamic> toJson() => {
    "old_password": oldPassword == null ? null : oldPassword,
    "new_password": newPassword == null ? null : newPassword,
  };
}
