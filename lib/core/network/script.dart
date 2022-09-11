import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<http.Response> urlReturn(Map<dynamic, dynamic>? jsons) async {
  debugPrint(jsons?["url"]);
  if (jsons?["method"] == "post") {
    return http.post(Uri.parse(jsons?["url"]),
        body: jsons?["bodyVariable"] != null ? json.encode(jsons?["bodyVariable"]) : null, headers: jsons?["headersVariable"]);
  } else if (jsons?["method"] == "get") {
    return http.get(Uri.parse(jsons?["url"]), headers: jsons?["headersVariable"]);
  } else {
    return http.delete(Uri.parse(jsons?["url"]), headers: jsons?["headersVariable"]);
  }
}
