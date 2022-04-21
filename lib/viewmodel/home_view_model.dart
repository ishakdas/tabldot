import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/constant/enum/file_enum.dart';
import '../core/key/local_key.dart';
import '../core/model/post.dart';
import '../core/service/web_service.dart';

enum HomeState { IDLE, BUSY, ERROR }

class HomeViewModel with ChangeNotifier {
  late HomeState _state;
  int _pageKey = 0;
  late List<Post> homeList;
  static const _pageSize = 25;
  final PagingController<int, Post> pagingController = PagingController(firstPageKey: 0);
  HomeViewModel() {
    homeList = [];
    _state = HomeState.IDLE;
    fetchJobs(_pageKey);
    pagingController.addPageRequestListener((pageKey) {
      _fetchJobs(pageKey);
    });
  }

  HomeState get state => _state;
  set state(HomeState state) {
    _state = state;
    notifyListeners();
  }

  Future<List<Post>> fetchJobs(int pageKey) async {
    _pageKey = pageKey;
    try {
      state = HomeState.BUSY;
      final newItems = await WebService().fetchPosts(pageKey);
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
      final newItems = await WebService().fetchPosts(pageKey);
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

  void fileDownload(
    String url,
    String imageType,
  ) async {
    if (imageType == FileEnum.image.name) {
      try {
        // Saved with this method.
        bool success = false;
        success = (await GallerySaver.saveImage(url))!;

        if (!success) {
          return;
        }
        Fluttertoast.showToast(
            msg: LocaleKeys.saved_gallery.tr(),
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.grey[600],
            fontSize: 14.0);
      } on PlatformException catch (error) {
        print(error);
      }
    } else if (imageType == FileEnum.video.name) {
      GallerySaver.saveVideo(url).then((bool? success) {
        Fluttertoast.showToast(
            msg: LocaleKeys.saved_gallery.tr(),
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.grey[600],
            fontSize: 14.0);
      });
    } else {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        // can't launch url
      }
    }
  }
}
