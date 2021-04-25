// To parse this JSON data, do
//
//     final blogResponse = blogResponseFromJson(jsonString);

import 'dart:convert';

class BlogResponse {
  bool success;
  String message;
  List<BlogModel> data;

  BlogResponse({
    this.success,
    this.message,
    this.data,
  });

  factory BlogResponse.fromRawJson(String str) => BlogResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BlogResponse.fromJson(Map<String, dynamic> json) => BlogResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<BlogModel>.from(json["data"].map((x) => BlogModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class BlogModel {
  int id;
  String title;
  String slug;
  String excerpt;
  String categoryName;
  dynamic content;
  String image;
  int createdAt;

  BlogModel({
    this.id,
    this.title,
    this.slug,
    this.excerpt,
    this.categoryName,
    this.content,
    this.image,
    this.createdAt,
  });

  factory BlogModel.fromRawJson(String str) => BlogModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BlogModel.fromJson(Map<String, dynamic> json) => BlogModel(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    slug: json["slug"] == null ? null : json["slug"],
    excerpt: json["excerpt"] == null ? null : json["excerpt"],
    categoryName: json["category_name"] == null ? null : json["category_name"],
    content: json["content"],
    image: json["image"] == null ? null : json["image"],
    createdAt: json["created_at"] == null ? null : json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "slug": slug == null ? null : slug,
    "excerpt": excerpt == null ? null : excerpt,
    "category_name": categoryName == null ? null : categoryName,
    "content": content,
    "image": image == null ? null : image,
    "created_at": createdAt == null ? null : createdAt,
  };
}
