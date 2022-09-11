import 'dart:convert';

List<OrderModel> orderModelsFromJson(String str) => List<OrderModel>.from(json.decode(str).map((x) => OrderModel.fromJson(x)));

class OrderModel {
  int? id;
  Attributes? attributes;

  OrderModel({this.id, this.attributes});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributes = json['attributes'] != null ? Attributes.fromJson(json['attributes']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (attributes != null) {
      data['attributes'] = attributes!.toJson();
    }
    return data;
  }
}

class Attributes {
  String? ad;
  String? soyad;
  String? telefon;
  String? adres;
  String? siparisTarihi;
  String? guncellemeTarihi;
  String? urunId;
  String? siparisDurumu;
  String? createdAt;
  String? updatedAt;
  String? publishedAt;

  Attributes(
      {this.ad,
      this.soyad,
      this.telefon,
      this.adres,
      this.siparisTarihi,
      this.guncellemeTarihi,
      this.urunId,
      this.createdAt,
      this.updatedAt,
      this.publishedAt,
      this.siparisDurumu});

  Attributes.fromJson(Map<String, dynamic> json) {
    ad = json['ad'];
    soyad = json['soyad'];
    telefon = json['telefon'];
    adres = json['adres'];
    siparisTarihi = json['siparis_tarihi'];
    guncellemeTarihi = json['guncelleme_tarihi'];
    urunId = json['urun_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    siparisDurumu = json['siparis_durumu'];
    publishedAt = json['publishedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ad'] = ad;
    data['soyad'] = soyad;
    data['telefon'] = telefon;
    data['adres'] = adres;
    data['siparis_tarihi'] = siparisTarihi;
    data['guncelleme_tarihi'] = guncellemeTarihi;
    data['urun_id'] = urunId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['publishedAt'] = publishedAt;
    data['siparis_durumu'] = siparisDurumu;
    return data;
  }
}
