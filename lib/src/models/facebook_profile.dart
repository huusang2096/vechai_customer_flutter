// To parse this JSON data, do
//
//     final facebookProfile = facebookProfileFromJson(jsonString);

import 'dart:convert';

class FacebookProfile {
  FacebookProfile({
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.picture,
    this.id,
  });

  String name;
  String firstName;
  String lastName;
  String email;
  Picture picture;
  String id;

  factory FacebookProfile.fromRawJson(String str) =>
      FacebookProfile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FacebookProfile.fromJson(Map<String, dynamic> json) =>
      FacebookProfile(
        name: json["name"] == null ? null : json["name"],
        firstName: json["first_name"] == null ? null : json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        email: json["email"] == null ? null : json["email"],
        picture:
            json["picture"] == null ? null : Picture.fromJson(json["picture"]),
        id: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "first_name": firstName == null ? null : firstName,
        "last_name": lastName == null ? null : lastName,
        "email": email == null ? null : email,
        "picture": picture == null ? null : picture.toJson(),
        "id": id == null ? null : id,
      };
}

class Picture {
  Picture({
    this.data,
  });

  Data data;

  factory Picture.fromRawJson(String str) => Picture.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data.toJson(),
      };
}

class Data {
  Data({
    this.height,
    this.isSilhouette,
    this.url,
    this.width,
  });

  int height;
  bool isSilhouette;
  String url;
  int width;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        height: json["height"] == null ? null : json["height"],
        isSilhouette:
            json["is_silhouette"] == null ? null : json["is_silhouette"],
        url: json["url"] == null ? null : json["url"],
        width: json["width"] == null ? null : json["width"],
      );

  Map<String, dynamic> toJson() => {
        "height": height == null ? null : height,
        "is_silhouette": isSilhouette == null ? null : isSilhouette,
        "url": url == null ? null : url,
        "width": width == null ? null : width,
      };
}
