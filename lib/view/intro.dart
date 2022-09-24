import 'package:crc_version_1/controller/intro_controller.dart';
import 'package:crc_version_1/helper/global.dart';
import 'package:crc_version_1/helper/myTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class IntroView extends StatelessWidget {

  IntroController introController = Get.put(IntroController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: SafeArea(
        child: Center(
          // physics: NeverScrollableScrollPhysics(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top,
            child: Image.asset("assets/images/intro.gif",fit: BoxFit.cover,),

            // child: Column(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     _header(context),
            //     _carImage(context),
            //     _title(context),
            //   ],
            // ),
          ),
        ),
      ),
    );
  }

  _header(context){
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Global.lang_code == 'en'
              ? Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
            child: MyTheme.isDarkTheme.value
              ? Image.asset('assets/images/logo_dark.png', fit: BoxFit.cover,)
              : Image.asset('assets/images/logo_light.png',fit: BoxFit.cover), )
              : Image.asset('assets/images/lines.png', fit: BoxFit.cover,),
        ),
        Expanded(
          flex: 1,
          child: Global.lang_code == 'en'
              ? Image.asset('assets/images/lines.png', fit: BoxFit.cover,)
              : Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
            child: MyTheme.isDarkTheme.value
              ? Image.asset('assets/images/logo_dark.png', fit: BoxFit.cover)
              : Image.asset('assets/images/logo_light.png', fit: BoxFit.cover),
          )
        ),

      ],
    );
  }
  _carImage(context){
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Image.asset('assets/images/car.png', fit: BoxFit.cover),
    );
  }
  _title(context){
    return Container(
      height: MediaQuery.of(context).size.height * 0.45-MediaQuery.of(context).padding.top,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Global.lang_code == 'en'
              ? Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Image.asset('assets/images/english_title.png',fit: BoxFit.contain,),
              )
              :  Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: MediaQuery.of(context).size.height * 0.4,
            child: MyTheme.isDarkTheme.value
                ? Image.asset('assets/images/arabic_title_light.png',fit: BoxFit.contain)
                : Image.asset('assets/images/arabic_title.png',fit: BoxFit.contain,),
          ),
          Global.lang_code == 'en'
              ? Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: MediaQuery.of(context).size.height * 0.4,
                child: MyTheme.isDarkTheme.value
                    ? Image.asset('assets/images/arabic_title_light.png',fit: BoxFit.contain)
                    : Image.asset('assets/images/arabic_title.png',fit: BoxFit.contain,),
              )
              :  Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Image.asset('assets/images/english_title.png',fit: BoxFit.contain,),
          ),
        ],
      ),
    );
  }

}
