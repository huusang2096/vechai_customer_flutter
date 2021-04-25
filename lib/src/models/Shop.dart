import 'dart:convert';

class Shop {
  int id;
  String name;
  String slug;
  bool verified;
  dynamic rating;
  String image;

  Shop({
    this.id,
    this.name,
    this.slug,
    this.verified,
    this.rating,
    this.image,
  });

  factory Shop.fromRawJson(String str) => Shop.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        slug: json["slug"] == null ? null : json["slug"],
        verified: json["verified"] == null ? null : json["verified"],
        rating: json["rating"] == null
            ? 0
            : json["rating"] is String
                ? double.parse(json["rating"])
                : json["rating"].toDouble(),
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "slug": slug == null ? null : slug,
        "verified": verified == null ? null : verified,
        "rating": rating == null ? null : rating,
        "image": image == null ? null : image,
      };
}
