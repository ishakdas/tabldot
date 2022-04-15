import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../core/constant/application_constans.dart';
import '../core/model/post.dart';
import '../core/widgets/file_control_widget.dart';
import '../core/widgets/pxHeight.dart';

class PostDetail extends StatefulWidget {
  const PostDetail({Key? key, required this.post}) : super(key: key);

  final PostAttributes post;

  @override
  PostDetailState createState() => PostDetailState();
}

class PostDetailState extends State<PostDetail> {
  @override
  Widget build(BuildContext context) {
    bool isFile = widget.post.media!.data == null;
    String fileType = "";
    if (!isFile) {
      String images = widget.post.media!.data![0].attributes!.mime!;
      fileType = images.split("/")[0];
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.post.baslik!),
        ),
        body: SingleChildScrollView(
            child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              PxHeight(),
              fileControlWidget(fileType, ApplicationConstants.URL + widget.post.media!.data![0].attributes!.url!, context),
              PxHeight(),
              Expanded(
                  child: Markdown(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), data: widget.post.aciklama!))
            ],
          ),
        )));
  }
}
