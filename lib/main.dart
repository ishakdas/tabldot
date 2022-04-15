import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:piyasaekrani/firebase_options.dart';
import 'package:piyasaekrani/view/home_view.dart';
import 'package:piyasaekrani/view/theme.dart';
import 'package:piyasaekrani/viewmodel/home_view_model.dart';
import 'package:provider/provider.dart';

import 'core/constant/localization/app_constant.dart';
import 'core/notification/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  notificationConfigure();
  runApp(
    EasyLocalization(
      supportedLocales: AppConstant.SUPPORTED_LOCALE,
      path: AppConstant.LANG_PATH,
      fallbackLocale: const Locale('tr', 'TR'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => HomeViewModel(),
        child: MaterialApp(
            theme: ThemeClass.lightTheme,
            darkTheme: ThemeClass.darkTheme,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: HomeView()));
  }
}
