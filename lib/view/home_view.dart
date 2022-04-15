import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:piyasaekrani/core/constant/enum/file_enum.dart';
import 'package:piyasaekrani/core/model/post.dart';
import 'package:piyasaekrani/core/widgets/core_widget.dart';
import 'package:provider/provider.dart';

import 'package:gallery_saver/gallery_saver.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constant/application_constans.dart';
import '../core/key/local_key.dart';
import '../core/widgets/drawer.dart';
import '../core/widgets/file_control_widget.dart';
import '../core/widgets/pxHeight.dart';
import 'post_detail.dart';
import '../viewmodel/home_view_model.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo,
        drawer: const DrawerWidget(),
        appBar: buildAppBar(),
        body: context.watch<HomeViewModel>().state == HomeState.BUSY
            ? buildLoadingWidget()
            : context.watch<HomeViewModel>().state == HomeState.ERROR
                ? buildErrorWidget()
                : RefreshIndicator(
                    displacement: 250,
                    strokeWidth: 3,
                    triggerMode: RefreshIndicatorTriggerMode.onEdge,
                    onRefresh: () async {
                      await context.read<HomeViewModel>().fetchJobs(0);
                    },
                    child: buildListView(context)));
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(LocaleKeys.main_title.tr()),
    );
  }

  Center buildErrorWidget() => Center(child: Text(LocaleKeys.internet_error.tr()));

  Center buildLoadingWidget() => const Center(child: CircularProgressIndicator());

  PagedListView buildListView(BuildContext context) {
    return PagedListView<int, Post>(
      pagingController: context.read<HomeViewModel>().pagingController,
      builderDelegate: PagedChildBuilderDelegate<Post>(
        itemBuilder: (context, item, index) => buildListItem(context, item),
      ),
    );
  }

  Widget buildListItem(BuildContext context, Post item) {
    return Container(
        padding: const EdgeInsets.all(5.0),
        /* decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15),
        ),*/
        child: bodyColumn(item, context));
  }
}

Column bodyColumn(Post homePost, BuildContext context) {
  bool isFile = homePost.attributes!.media!.data == null;
  String fileType = "";
  if (!isFile) {
    String images = homePost.attributes!.media!.data![0].attributes!.mime!;
    fileType = images.split("/")[0];
  }
  var x65Height = context.dynamicHeight(0.65);
  var _return = Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 8.0),
        child: Text(
          LocaleKeys.child_name.tr() + homePost.attributes!.baslik!,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      PxHeight(),
      fileControlWidget(fileType, ApplicationConstants.URL + homePost.attributes!.media!.data![0].attributes!.url!, context),
      PxHeight(),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        icon: const FaIcon(FontAwesomeIcons.circleInfo),
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PostDetail(
                                      post: homePost.attributes!,
                                    )),
                          );
                        }),
                  ],
                )),
            Expanded(
                flex: 1,
                child: homePost.attributes!.link != ""
                    ? TextButton(
                        onPressed: () {},
                        child: IconButton(
                            icon: const FaIcon(FontAwesomeIcons.earthAmericas),
                            onPressed: () async {
                              if (await canLaunch(homePost.attributes!.link!)) {
                                await launch(homePost.attributes!.link!);
                              } else {
                                // can't launch url
                              }
                            }),
                      )
                    : Container()),
            Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: () async {
                    try {
                      fileDownload(ApplicationConstants.URL + homePost.attributes!.media!.data![0].attributes!.url!, fileType);
                    } catch (error) {
                      print(error);
                    }
                  },
                  child: const FaIcon(FontAwesomeIcons.download),
                )),
          ],
        ),
      )
    ],
  );
  return _return;
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