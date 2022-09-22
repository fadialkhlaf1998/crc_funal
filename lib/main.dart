import 'package:crc_version_1/app_localization.dart';
import 'package:crc_version_1/helper/global.dart';
import 'package:crc_version_1/helper/myTheme.dart';
import 'package:crc_version_1/helper/store.dart';
import 'package:crc_version_1/model/intro.dart';
import 'package:crc_version_1/view/intro.dart';
import 'package:crc_version_1/view/calender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static void set_local(BuildContext context , Locale locale){
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.set_locale(locale);
  }

  static void set_theme(BuildContext context){
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.set_dark();
  }

  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void set_locale(Locale locale){
    setState(() {
      _locale=locale;
    });
  }

  void set_dark(){
    setState(() {
      myTheme.value.myTheme;
    });
  }

  @override
  void initState() {
    Store.loadTheme().then((value) {
      MyTheme.isDarkTheme.value = !value;
    });
    super.initState();
    Global.load_language().then((language) {
      setState(() {
        _locale= Locale(language);
      });
      Get.updateLocale(Locale(language));
    });

  }
  Rx<MyTheme> myTheme = MyTheme().obs;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        themeMode: myTheme.value.myTheme,
        theme: MyTheme.lightTheme,
        darkTheme: MyTheme.darkTheme,
        locale: _locale,
        supportedLocales: [Locale('en', ''), Locale('ar', '')],
        localizationsDelegates: const [
          App_Localization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (local, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == local!.languageCode) {
              Global.lang_code=supportedLocale.languageCode;
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        debugShowCheckedModeBanner: false,
        home: IntroView()
    );
  }
}
