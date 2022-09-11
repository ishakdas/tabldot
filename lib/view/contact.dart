// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key, String? title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      color: Colors.white,
      child: ListView(
        children: [
          Column(
            children: [
              Stack(clipBehavior: Clip.none, alignment: Alignment.bottomCenter, children: [
                Image(
                    height: MediaQuery.of(context).size.height / 3,
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/tabldot-splash.png")),
                Positioned(
                    bottom: -50.0,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.black,
                      child: CircleAvatar(
                        radius: 75,
                        backgroundImage: AssetImage("assets/images/yasa.jpeg"),
                      ),
                    ))
              ]),
              SizedBox(
                height: 45,
              ),
              ListTile(
                title: Center(child: Text('Yasa ÇELİKTAŞ')),
                subtitle: Center(
                    child: Text(
                  'Türkiye Yemek Sanayicileri Dernekleri Federasyonu Genel Sekreterliği',
                  textAlign: TextAlign.center,
                )),
              ),
              ListTile(
                title: Text('Hakkımda'),
                subtitle: Text(
                    '''1958 yalında Adana da doğdu. İlk orta lise eğitimini Adana da tamamlayan Yasa Çeliktaş yüksek öğretimini önce Tarsus Yabancı Diller Yüksek Okulunda sonradan da İstanbul Eğitim Enstitüsü İngilizce bölümünde tamamladı. 
Yaşamının büyük bölümünü önce İngilizce öğretmenliği sonrasında da eğitimcilik ve tüccarlıkla geçiren Yasa Çeliktaş 2003 yılından beri İstanbul Yemek Sanayicileri Derneği , 2005 yalından bu yana da Türkiye Yemek Sanayicileri Dernekleri Federasyonu Genel Sekreterliği görevini yürütüyor.
                  '''),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                title: Text('Tabldot Hakkında'),
                subtitle: Text(
                    '''Bu uygulama özellikle Türkiye de bulunan 5000 in üzeri Toplu Yemek Üreten firmalar için hazırlanmıştır.
Uygulamada mutfak sanayicisini ilgilendiren her türlü uyarı, haber ve reklam yayınlanacaktır.'''),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                title: Text('Sosyal medya'),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: IconButton(
                          icon: FaIcon(FontAwesomeIcons.twitter),
                          onPressed: () async {
                            String url = "https://twitter.com/yasa58";
                            if (await canLaunch(url)) {
                              await launch(url, forceSafariVC: false);
                            }
                          }),
                    ),
                    Expanded(
                      child: IconButton(
                          icon: FaIcon(FontAwesomeIcons.facebook),
                          onPressed: () async {
                            String url = "https://www.facebook.com/yasa.celiktas/";
                            if (await canLaunch(url)) {
                              await launch(url, forceSafariVC: false);
                            }
                          }),
                    ),
                    Expanded(
                      child: IconButton(
                          icon: FaIcon(FontAwesomeIcons.instagram),
                          onPressed: () async {
                            String url = "https://www.instagram.com/yasa.celiktas/";
                            if (await canLaunch(url)) {
                              await launch(url, forceSafariVC: false);
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
