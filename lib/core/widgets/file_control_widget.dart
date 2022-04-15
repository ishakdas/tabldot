import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:piyasaekrani/core/widgets/core_widget.dart';
import 'package:piyasaekrani/core/widgets/scale_route.dart';

import '../../view/video_player.dart';
import '../constant/enum/file_enum.dart';
import 'image_details.dart';

Widget fileControlWidget(String fileType, String url, BuildContext context) {
  var x65Height = context.dynamicHeight(0.65);
  if (fileType == FileEnum.image.name) {
    return InkWell(
      onTap: () {
        Navigator.push(context, ScaleRoute(page: PostImage(url)));
      },
      child: Container(
        constraints: BoxConstraints(minHeight: 1, minWidth: double.infinity, maxHeight: x65Height),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: SizedBox.fromSize(
            child: CachedNetworkImage(
              imageUrl: url,
              placeholder: (context, url) => const SizedBox(width: 15, child: Center(child: CircularProgressIndicator())),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  } else if (fileType == FileEnum.video.name) {
    return Container(
        constraints: BoxConstraints(minHeight: 1, minWidth: double.infinity, maxHeight: x65Height),
        child: VideoApp(
          url: url,
        ));
  } else {
    return Container(
      constraints: BoxConstraints(minHeight: 1, minWidth: double.infinity, maxHeight: x65Height),
      child: const Center(child: FaIcon(FontAwesomeIcons.fileContract, size: 70)),
    );
  }
}
