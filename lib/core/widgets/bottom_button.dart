import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tabldot/view/post_detail.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant/application_constans.dart';
import '../model/post.dart';
import 'file_download.dart';

class BottomButton extends StatelessWidget {
  const BottomButton({Key? key, required this.fileType, required this.homePost}) : super(key: key);

  final String fileType;
  final Post homePost;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (homePost.attributes?.aciklama != null)
                    IconButton(
                        icon: const FaIcon(FontAwesomeIcons.circleInfo),
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PostDetail(
                                      post: homePost,
                                      id: homePost.id!,
                                      fileType: fileType,
                                    )),
                          );
                        }),
                ],
              )),
          Expanded(
              flex: 1,
              child: homePost.attributes!.telefon != ""
                  ? TextButton(
                      onPressed: () {},
                      child: IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.phone,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            await FlutterPhoneDirectCaller.callNumber(homePost.attributes!.telefon!);
                          }),
                    )
                  : Container()),
          Expanded(
              flex: 1,
              child: homePost.attributes!.link != null
                  ? TextButton(
                      onPressed: () {},
                      child: IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.earthAmericas,
                            color: Colors.white,
                          ),
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
                child: const FaIcon(
                  FontAwesomeIcons.download,
                  color: Colors.white,
                ),
              )),
        ],
      ),
    );
  }
}
