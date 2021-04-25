// To parse this JSON data, do
//
//     final blogDetailResponse = blogDetailResponseFromJson(jsonString);

import 'dart:convert';

class BlogDetailResponse {
  bool success;
  String message;
  BlogDetail data;

  BlogDetailResponse({
    this.success,
    this.message,
    this.data,
  });

  factory BlogDetailResponse.fromRawJson(String str) => BlogDetailResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BlogDetailResponse.fromJson(Map<String, dynamic> json) => BlogDetailResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : BlogDetail.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : data.toJson(),
  };
}

class  BlogDetail{
  int id;
  String title;
  String slug;
  String excerpt;
  String categoryName;
  String content;
  String image;
  int createdAt;
  String url;

  BlogDetail({
    this.id,
    this.title,
    this.slug,
    this.excerpt,
    this.categoryName,
    this.content,
    this.image,
    this.createdAt,
    this.url
  });

  factory BlogDetail.fromRawJson(String str) => BlogDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BlogDetail.fromJson(Map<String, dynamic> json) => BlogDetail(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    slug: json["slug"] == null ? null : json["slug"],
    excerpt: json["excerpt"] == null ? null : json["excerpt"],
    categoryName: json["category_name"] == null ? null : json["category_name"],
    content: json["content"] == null ? null : json["content"],
    image: json["image"] == null ? null : json["image"],
    createdAt: json["created_at"] == null ? null : json["created_at"],
    url: json["video_url"] == null ? null : json["video_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "slug": slug == null ? null : slug,
    "excerpt": excerpt == null ? null : excerpt,
    "category_name": categoryName == null ? null : categoryName,
    "content": content == null ? null : content,
    "image": image == null ? null : image,
    "created_at": createdAt == null ? null : createdAt,
    "video_url": url == null ? null : url,
  };
}
