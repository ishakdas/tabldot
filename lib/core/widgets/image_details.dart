import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:photo_view/photo_view.dart';

import '../key/local_key.dart';

class PostImage extends StatefulWidget {
  PostImage(this.url, {Key? key}) : super(key: key);
  String url;
  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> {
  PhotoViewController? controller;
  double? scaleCopy;
  @override
  void initState() {
    super.initState();
    controller = PhotoViewController()..outputStateStream.listen(listener);
  }

  void listener(PhotoViewControllerValue value) {
    setState(() {
      scaleCopy = value.scale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.cloudArrowDown,
              color: Colors.white,
            ),
            onPressed: () async {
              try {
                // Saved with this method.
                bool success = false;
                success = (await GallerySaver.saveImage(widget.url))!;

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
            },
          )
        ],
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      backgroundColor: Colors.black45,
      body: Container(
        child: PhotoView(
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 1.8,
            initialScale: PhotoViewComputedScale.contained * 1.1,
            controller: controller,
            imageProvider: NetworkImage(widget.url)),
      ),
    );
  }
}
