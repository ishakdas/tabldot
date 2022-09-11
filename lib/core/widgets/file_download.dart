import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant/enum/file_enum.dart';
import '../key/local_key.dart';

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
