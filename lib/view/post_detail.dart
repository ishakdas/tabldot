import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tabldot/core/key/local_key.dart';
import 'package:tabldot/view/order_view.dart';

import '../core/constant/application_constans.dart';
import '../core/model/post.dart';
import '../core/widgets/bottom_button.dart';
import '../core/widgets/file_control_widget.dart';
import '../core/widgets/pxHeight.dart';

class PostDetail extends StatefulWidget {
  const PostDetail({Key? key, required this.post, required this.id, required this.fileType}) : super(key: key);

  final Post post;
  final int id;
  final String fileType;
  @override
  PostDetailState createState() => PostDetailState();
}

class PostDetailState extends State<PostDetail> {
  @override
  Widget build(BuildContext context) {
    bool isFile = widget.post.attributes!.media!.data == null;
    String fileType = "";
    if (!isFile) {
      String images = widget.post.attributes!.media!.data![0].attributes!.mime!;
      fileType = images.split("/")[0];
    }
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 30, 47, 26),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderPage(
                        id: widget.id,
                      )),
            );
          },
          isExtended: true,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          icon: const Icon(FontAwesomeIcons.bagShopping, color: Colors.white),
          label: Text(
            LocaleKeys.order.tr(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          title: Text(widget.post.attributes!.baslik!),
        ),
        body: SingleChildScrollView(
            child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              PxHeight(),
              fileControlWidget(
                  fileType, ApplicationConstants.URL + widget.post.attributes!.media!.data![0].attributes!.url!, context,
                  detail: true),
              BottomButton(
                fileType: fileType,
                homePost: widget.post,
              ),
              PxHeight(),
              if (widget.post.attributes!.aciklama != null)
                Expanded(
                    child: Markdown(
                        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), data: widget.post.attributes!.aciklama!))
            ],
          ),
        )));
  }
}
