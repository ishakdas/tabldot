import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../key/local_key.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SizedBox(
        width: double.maxFinite,
        child: ListView(
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text(
                "Yasa Çeliktaş",
                style: TextStyle(color: Colors.black),
              ),
              accountEmail: Text(
                "yasa@yasaceliktas.com",
                style: TextStyle(color: Colors.black),
              ),
              decoration: BoxDecoration(color: Colors.transparent),
              currentAccountPicture: CircleAvatar(
                backgroundImage: ExactAssetImage('assets/images/tabldot-splash.png'),
              ),
            ),
            ListTile(
                leading: const Icon(FontAwesomeIcons.share),
                title: Text(LocaleKeys.shareApp.tr()),
                onTap: () {
                  Share.share('Web Sitemizi ziyaret edin: https://piyasaekrani.org');
                  Navigator.pop(context);
                }),
            ListTile(
                leading: const Icon(FontAwesomeIcons.whatsappSquare),
                title: Text(LocaleKeys.openContact.tr()),
                onTap: () {
                  openwhatsapp(context);
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}

openwhatsapp(BuildContext context) async {
  var whatsapp = "+905335995500";
  var whatsappURlAndroid = "whatsapp://send?phone=" + whatsapp + "&text=Yasa Çeliktaş";
  var whatappURLIos = "https://wa.me/$whatsapp?text=${Uri.parse("Yasa Çeliktaş")}";
  if (Platform.isIOS) {
    // for iOS phone only
    if (await canLaunch(whatappURLIos)) {
      await launch(whatappURLIos, forceSafariVC: false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("whatsapp no installed")));
    }
  } else {
    // android , web
    if (await canLaunch(whatsappURlAndroid)) {
      await launch(whatsappURlAndroid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("whatsapp no installed")));
    }
  }
}
