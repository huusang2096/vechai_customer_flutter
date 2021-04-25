import 'dart:convert';
import 'package:intl/intl.dart' show DateFormat;
import 'package:veca_customer/src/models/basemodel.dart';

class UserResponse extends BaseResponse {

  User data;
  String message;
  bool success;

  UserResponse({
    this.data,
    this.message,
    this.success,
  });

  factory UserResponse.fromRawJson(String str) => UserResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
    data: json["data"] == null ? null : User.fromJson(json["data"]),
    message: json["message"] == null ? null : json["message"],
    success: json["success"] == null ? false : json["success"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : data.toJson(),
    "message": message == null ? null : message,
    "success": success == null ? false : success,

  };

  @override
  bool hasData() {
    return data != null;
  }

}


class User {
  int id;
  String name;
  dynamic niceName;
  dynamic dob;
  dynamic sex;
  dynamic description;
  bool active;
  bool acceptsMarketing;
  String memberSince;
  String avatar;
  String apiToken;
  String email;
  String dynamicLink;

  User({
    this.id,
    this.name,
    this.niceName,
    this.dob,
    this.sex,
    this.description,
    this.active,
    this.acceptsMarketing,
    this.memberSince,
    this.avatar,
    this.apiToken,
    this.email,
    this.dynamicLink
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] == null ? "" : json["id"],
    name: json["name"] == null ? "" : json["name"],
    niceName: json["nice_name"] == null ? "" : json["nice_name"],
    dob: json["dob"] == null ? "January 1, 1970": json["dob"],
    sex: json["sex"] == null ? "Male":  json["sex"],
    description: json["description"] == null ? "":json["description"],
    active: json["active"] == null ? false : json["active"],
    acceptsMarketing: json["accepts_marketing"] == null ? false : json["accepts_marketing"],
    memberSince: json["member_since"] == null ? "" : json["member_since"],
    avatar: json["avatar"] == null ? "" : json["avatar"],
    apiToken: json["api_token"] == null ? "" : json["api_token"],
    email: json["email"] == null ? "" : json["email"],
    dynamicLink: json["dynamic_link_invite"] == null ? "" : json["dynamic_link_invite"]
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "nice_name": niceName,
    "dob": dob,
    "sex": sex,
    "description": description,
    "active": active == null ? null : active,
    "accepts_marketing": acceptsMarketing == null ? null : acceptsMarketing,
    "member_since": memberSince == null ? null : memberSince,
    "avatar": avatar == null ? null : avatar,
    "api_token": apiToken == null ? null : apiToken,
    "email": email == null ? null : email,
    "dynamic_link_invite": dynamicLink == null ? null : dynamicLink
  };


}
