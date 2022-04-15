import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<http.Response> urlReturn(Map<dynamic, dynamic>? json) async {
  debugPrint(json?["url"]);
  if (json?["method"] == "post") {
    return http.post(Uri.parse(json?["url"]), body: json?["bodyVariable"], headers: json?["headersVariable"]);
  } else if (json?["method"] == "get") {
    return http.get(Uri.parse(json?["url"]), headers: json?["headersVariable"]);
  } else {
    return http.delete(Uri.parse(json?["url"]), headers: json?["headersVariable"]);
  }
}
