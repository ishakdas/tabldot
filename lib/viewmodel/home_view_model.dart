import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../core/model/post.dart';
import '../core/service/web_service.dart';

enum HomeState { IDLE, BUSY, ERROR }

class HomeViewModel with ChangeNotifier {
  late HomeState _state;
  late int id;
  int _pageKey = 0;
  late List<Post> homeList;
  static const _pageSize = 25;
  late PagingController<int, Post> pagingController = PagingController(firstPageKey: 0);
  HomeViewModel() {
    homeList = [];
    _state = HomeState.IDLE;

    pagingController.addPageRequestListener((pageKey) {
      _fetchJobs(pageKey);
    });
  }

  HomeState get state => _state;

  set state(HomeState state) {
    _state = state;
    notifyListeners();
  }

  void setID(int id) {
    this.id = id;
  }

  Future<List<Post>> fetchJobs(int pageKey) async {
    pagingController = PagingController(firstPageKey: 0);
    _pageKey = pageKey;
    try {
      state = HomeState.BUSY;
      final newItems = await WebService().fetchPosts(id, pageKey);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems, nextPageKey);
      }
      state = HomeState.IDLE;
      return homeList;
    } catch (e) {
      state = HomeState.ERROR;
      pagingController.error = e;
      return [];
    }
  }

  Future<List<Post>> _fetchJobs(int pageKey) async {
    _pageKey = pageKey;
    try {
      final newItems = await WebService().fetchPosts(id, pageKey);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems, nextPageKey);
      }

      return homeList;
    } catch (e) {
      pagingController.error = e;
      return [];
    }
  }

  Future<String> downloadFile(String url, String fileName, String dir) async {
    HttpClient httpClient = HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';

    try {
      myUrl = url + '/' + fileName;
      var request = await httpClient.getUrl(Uri.parse(myUrl));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '$dir/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
      } else {
        filePath = 'Error code: ' + response.statusCode.toString();
      }
    } catch (ex) {
      filePath = 'Can not fetch url';
    }

    return filePath;
  }
}
