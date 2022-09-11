import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../core/model/categories.dart';
import '../core/service/web_service.dart';

enum CategoriesState { IDLE, BUSY, ERROR }

class CategoriesViewModel with ChangeNotifier {
  late CategoriesState _state;
  int _pageKey = 0;
  late List<Categories> homeList;
  static const _pageSize = 25;
  late PagingController<int, Categories> pagingController = PagingController(firstPageKey: 0);
  CategoriesViewModel() {
    homeList = [];
    _state = CategoriesState.IDLE;
    pagingController.addPageRequestListener((pageKey) {
      _fetchJobs(pageKey);
    });
  }

  CategoriesState get state => _state;
  set state(CategoriesState state) {
    _state = state;
    notifyListeners();
  }

  Future<List<Categories>> fetchJobs(int pageKey) async {
    pagingController = PagingController(firstPageKey: 0);
    _pageKey = pageKey;
    try {
      state = CategoriesState.BUSY;
      final newItems = await WebService().fetchCategories(pageKey);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems, nextPageKey);
      }
      state = CategoriesState.IDLE;
      return homeList;
    } catch (e) {
      state = CategoriesState.ERROR;
      pagingController.error = e;
      return [];
    }
  }

  Future<List<Categories>> _fetchJobs(int pageKey) async {
    _pageKey = pageKey;
    try {
      final newItems = await WebService().fetchCategories(pageKey);
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
}
