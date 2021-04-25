// To parse this JSON data, do
//
//     final notificationResponse = notificationResponseFromJson(jsonString);

import 'dart:convert';

class NotificationResponse {
  NotificationResponse({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  Data data;

  factory NotificationResponse.fromRawJson(String str) => NotificationResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationResponse.fromJson(Map<String, dynamic> json) => NotificationResponse(
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
    this.userNotifications,
    this.systemNotifications,
  });

  List<NotificationData> userNotifications;
  List<NotificationData> systemNotifications;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userNotifications: json["user_notifications"] == null ? null : List<NotificationData>.from(json["user_notifications"].map((x) => NotificationData.fromJson(x))),
    systemNotifications: json["system_notifications"] == null ? null : List<NotificationData>.from(json["system_notifications"].map((x) => NotificationData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "user_notifications": userNotifications == null ? null : List<dynamic>.from(userNotifications.map((x) => x.toJson())),
    "system_notifications": systemNotifications == null ? null : List<dynamic>.from(systemNotifications.map((x) => x.toJson())),
  };
}

class NotificationData {
  NotificationData({
    this.id,
    this.customerId,
    this.fcmToken,
    this.deviceId,
    this.os,
    this.title,
    this.message,
    this.body,
    this.time,
  });

  int id;
  int customerId;
  String fcmToken;
  String deviceId;
  String os;
  String title;
  String message;
  String body;
  String time;

  factory NotificationData.fromRawJson(String str) => NotificationData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    id: json["id"] == null ? null : json["id"],
    customerId: json["customer_id"] == null ? null : json["customer_id"],
    fcmToken: json["fcm_token"] == null ? null : json["fcm_token"],
    deviceId: json["device_id"] == null ? null : json["device_id"],
    os: json["os"] == null ? null : json["os"],
    title: json["title"] == null ? null : json["title"],
    message: json["message"] == null ? null : json["message"],
    body: json["body"] == null ? null : json["body"],
    time: json["time"] == null ? null : json["time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "customer_id": customerId == null ? null : customerId,
    "fcm_token": fcmToken == null ? null : fcmToken,
    "device_id": deviceId == null ? null : deviceId,
    "os": os == null ? null : os,
    "title": title == null ? null : title,
    "message": message == null ? null : message,
    "body": body == null ? null : body,
    "time": time == null ? null : time,
  };
}

class NotificationModel {
  NotificationModel({
    this.id,
    this.title,
    this.subTitle,
    this.body,
    this.image,
    this.uri,
    this.orderId,
    this.type,
  });

  int id;
  String title;
  String subTitle;
  String body;
  dynamic image;
  dynamic uri;
  int orderId;
  String type;

  factory NotificationModel.fromRawJson(String str) => NotificationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    subTitle: json["sub_title"] == null ? null : json["sub_title"],
    body: json["body"] == null ? null : json["body"],
    image: json["image"],
    uri: json["uri"],
    orderId: json["order_id"] == null ? null : json["order_id"],
    type: json["type"] == null ? null : json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "sub_title": subTitle == null ? null : subTitle,
    "body": body == null ? null : body,
    "image": image,
    "uri": uri,
    "order_id": orderId == null ? null : orderId,
    "type": type == null ? null : type,
  };
}
