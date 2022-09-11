import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../core/constant/application_constans.dart';
import '../core/model/categories.dart';
import '../viewmodel/categories_view_model.dart';
import '../viewmodel/home_view_model.dart';
import 'home_view.dart';

class Categories_view extends StatefulWidget {
  const Categories_view({Key? key}) : super(key: key);

  @override
  State<Categories_view> createState() => _Categories_viewState();
}

class _Categories_viewState extends State<Categories_view> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 47, 26),
      appBar: buildAppBar(),
      body: context.watch<CategoriesViewModel>().state == HomeState.BUSY
          ? buildLoadingWidget()
          : context.watch<CategoriesViewModel>().state == HomeState.ERROR
              ? buildErrorWidget()
              : RefreshIndicator(
                  displacement: 250,
                  strokeWidth: 3,
                  triggerMode: RefreshIndicatorTriggerMode.onEdge,
                  onRefresh: () async {
                    await context.read<CategoriesViewModel>().fetchJobs(0);
                  },
                  child: _buildListView()),
    );
  }

  PagedListView _buildListView() {
    return PagedListView<int, Categories>(
      pagingController: context.read<CategoriesViewModel>().pagingController,
      builderDelegate: PagedChildBuilderDelegate<Categories>(
        itemBuilder: (context, item, index) => _buildListItem(context, item),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, Categories item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
                padding: const EdgeInsets.all(5.0),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeView(id: item.id!),
                        ));
                  },
                  title: Text(
                    item.attributes!.kategoriAdi!,
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  dense: true,
                  leading: CachedNetworkImage(
                    imageUrl: ApplicationConstants.URL + item.attributes!.media!.data![0].attributes!.url!,
                    placeholder: (context, url) => const SizedBox(width: 15, child: Center(child: CircularProgressIndicator())),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                )),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            height: 1,
            color: Colors.white,
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
          ),
        ],
      ),
    );
  }
}
