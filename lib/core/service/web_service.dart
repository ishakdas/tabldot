import 'dart:convert';

import 'package:tabldot/core/network/script.dart';

import '../constant/application_constans.dart';
import '../model/post.dart';

class WebService {
  Future<List<Post>> fetchPosts(int start) async {
    List<Post> postTest = <Post>[];
    Map<dynamic, dynamic>? toMap = {
      "method": "get",
      "url": ApplicationConstants.API_URL + "tabldots?populate=media&sort[0]=createdAt:desc&pagination[start]=$start",
    };
    final response = await urlReturn(toMap);
    if (response.statusCode == 200) {
      var resultsObjsJson = jsonDecode(response.body)['data'];
      return postsFromJson2(jsonEncode(resultsObjsJson));
    }
    return postTest;
  }
}
