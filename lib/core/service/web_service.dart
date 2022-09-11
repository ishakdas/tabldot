import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tabldot/core/model/order_model.dart';
import 'package:tabldot/core/network/script.dart';

import '../constant/application_constans.dart';
import '../model/categories.dart';
import '../model/post.dart';

class WebService {
  Future<List<Post>> fetchPosts(int id, int start) async {
    List<Post> postTest = <Post>[];
    Map<dynamic, dynamic>? toMap = {
      "method": "get",
      "url": ApplicationConstants.API_URL +
          "tabldots?populate=media&filters[tabldot_kategori]=$id&sort[0]=createdAt:desc&pagination[start]=$start",
    };
    final response = await urlReturn(toMap);
    if (response.statusCode == 200) {
      var resultsObjsJson = jsonDecode(response.body)['data'];
      return postsFromJson2(jsonEncode(resultsObjsJson));
    }
    return postTest;
  }

  Future<List<Categories>> fetchCategories(int start) async {
    List<Categories> categoriesList = <Categories>[];
    Map<dynamic, dynamic>? toMap = {
      "method": "get",
      "url": ApplicationConstants.API_URL + "tabldot-kategoris?populate=media&sort[0]=createdAt:desc&pagination[start]=$start",
    };
    final response = await urlReturn(toMap);
    if (response.statusCode == 200) {
      var resultsObjsJson = jsonDecode(response.body)['data'];
      return categoriesFromJson2(jsonEncode(resultsObjsJson));
    }
    return categoriesList;
  }

  Future<String?> addOrder(
      {TextEditingController? ad,
      TextEditingController? soyad,
      TextEditingController? telefon,
      TextEditingController? adres,
      required int urun_id}) async {
    Map<dynamic, dynamic>? toMap = {
      "method": "post",
      "url": ApplicationConstants.API_URL + "siparises",
      "bodyVariable": {
        "data": {
          "ad": ad?.text,
          "soyad": soyad?.text,
          "telefon": telefon?.text,
          "adres": adres?.text,
          "urun_id": urun_id.toString(),
          "siparis_tarihi": DateTime.now().toString(),
          "guncelleme_tarihi": DateTime.now().toString()
        }
      },
      "headersVariable": {"Content-Type": "application/json"}
    };
    try {
      final response = await urlReturn(toMap);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data']['id'].toString();
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<OrderModel?>?> orderfindByIdAndPhone({required String telefon, required String sip_no}) async {
    Map<dynamic, dynamic>? toMap = {
      "method": "get",
      "url": ApplicationConstants.API_URL + "siparises?filters[telefon]=$telefon&filters[id]=$sip_no",
      "headersVariable": {"Content-Type": "application/json"}
    };
    try {
      final response = await urlReturn(toMap);
      if (response.statusCode == 200) {
        if (response.statusCode == 200) {
          var resultsObjsJson = jsonDecode(response.body)['data'];
          return orderModelsFromJson(jsonEncode(resultsObjsJson));
        }
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
