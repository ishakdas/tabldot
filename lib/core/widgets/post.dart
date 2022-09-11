import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../constant/application_constans.dart';
import '../constant/enum/file_enum.dart';
import '../key/local_key.dart';
import '../model/post.dart';
import 'core_widget.dart';
import 'image_details.dart';
import 'pxHeight.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({required this.post, Key? key}) : super(key: key);
  final Post post;
  @override
  Widget build(BuildContext context) {
    bool isFile = post.attributes!.media!.data == null;
    String imageType = "";
    if (!isFile) {
      String images = post.attributes!.media!.data![0].attributes!.mime!;
      imageType = images.split("/")[0];
    }
    var x65Height = context.dynamicHeight(0.65);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            LocaleKeys.child_name.tr() + post.attributes!.baslik!,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        PxHeight(),
        if (imageType == FileEnum.image.name)
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PostImage(ApplicationConstants.URL + post.attributes!.media!.data![0].attributes!.url!)));
            },
            child: Container(
              constraints: BoxConstraints(minHeight: 1, minWidth: double.infinity, maxHeight: x65Height),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox.fromSize(
                  child: CachedNetworkImage(
                    imageUrl: ApplicationConstants.URL + post.attributes!.media!.data![0].attributes!.url!,
                    placeholder: (context, url) => const SizedBox(width: 15, child: Center(child: CircularProgressIndicator())),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ),
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
                            print("Pressed");
                          }),
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () {},
                    child: IconButton(
                        icon: const FaIcon(FontAwesomeIcons.earthAmericas),
                        onPressed: () {
                          print("Pressed");
                        }),
                  )),
              Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () async {
                      try {
                        _saveNetworkVideo(post.attributes!.media!.data![0].attributes!.url!);
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
  }

  void _saveNetworkVideo(String s) async {
    String path = s;
    GallerySaver.saveVideo(path).then((bool? success) {
      print('Video is saved');
    });
  }
}
