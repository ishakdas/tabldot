// To parse this JSON data, do
//
//     final Post = PostFromJson(jsonString);

import 'dart:convert';

Categories categoriesFromJson(String str) => Categories.fromJson(json.decode(str));

String categoriesToJson(Categories data) => json.encode(data.toJson());
List<Categories> categoriesFromJson2(String str) => List<Categories>.from(json.decode(str).map((x) => Categories.fromJson(x)));

class Categories {
  Categories({
    this.id,
    this.attributes,
  });

  int? id;
  CategoriesAttributes? attributes;

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        id: json["id"],
        attributes: CategoriesAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes!.toJson(),
      };
}

class CategoriesAttributes {
  CategoriesAttributes({
    this.kategoriAdi,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.media,
  });

  String? kategoriAdi;

  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  Media? media;

  factory CategoriesAttributes.fromJson(Map<String, dynamic> json) => CategoriesAttributes(
        kategoriAdi: json["kategoriAdi"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        media: Media.fromJson(json["media"]),
      );

  Map<String, dynamic> toJson() => {
        "kategoriAdi": kategoriAdi,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "publishedAt": publishedAt?.toIso8601String(),
        "media": media?.toJson(),
      };
}

class Media {
  Media({
    this.data,
  });

  List<Datum>? data;

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.attributes,
  });

  int? id;
  DatumAttributes? attributes;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        attributes: DatumAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes?.toJson(),
      };
}

class DatumAttributes {
  DatumAttributes({
    this.name,
    this.width,
    this.height,
    this.hash,
    this.ext,
    this.mime,
    this.size,
    this.url,
  });

  String? name;
  int? width;
  int? height;
  String? hash;
  String? ext;
  String? mime;
  double? size;
  String? url;

  factory DatumAttributes.fromJson(Map<String, dynamic> json) => DatumAttributes(
        name: json["name"],
        width: json["width"],
        height: json["height"],
        hash: json["hash"],
        ext: json["ext"],
        mime: json["mime"],
        size: json["size"].toDouble(),
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "width": width,
        "height": height,
        "hash": hash,
        "ext": ext,
        "mime": mime,
        "size": size,
        "url": url,
      };
}
