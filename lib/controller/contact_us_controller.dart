
import 'dart:io';

import 'package:crc_version_1/helper/app.dart';
import 'package:crc_version_1/helper/global.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsController extends GetxController{

  RxBool phoneButton = false.obs;
  RxBool whatsappButton = false.obs;


  pressPhoneButton(context){
    phoneButton.value = true;
    Future.delayed(Duration(milliseconds: 700)).then((value) async{
      if(Platform.isAndroid){
        final Uri launchUri = Uri(
          scheme: 'tel',
          path: Global.vip_phone_number,
        );
        await launch(launchUri.toString());
        Future.delayed(Duration(milliseconds: 400)).then((value) { phoneButton.value = false;});


      }else if (Platform.isIOS){
        launch("tel://${Global.vip_phone_number}");
        Future.delayed(Duration(milliseconds: 400)).then((value) { phoneButton.value = false;});
      }

    });

  }

  pressWhatsAppButton(context){
    whatsappButton.value = true;
    String message = "";
    Future.delayed(Duration(milliseconds: 700)).then((value) async{
      await launch("https://api.whatsapp.com/send?phone=${Global.vip_phone_number}=${Uri.parse(message)}");
      Future.delayed(Duration(milliseconds: 400)).then((value) { whatsappButton.value = false;});
      // if (Platform.isAndroid){
      //   if(await canLaunch("https://wa.me/${Global.vip_phone_number}/?text=${Uri.parse(message)}")){
      //     await launch("https://wa.me/${Global.vip_phone_number}/?text=${Uri.parse(message)}");
      //     Future.delayed(Duration(milliseconds: 400)).then((value) { whatsappButton.value = false;});
      //
      //   }else{
      //     App.error_msg(context, 'can\'t open Whatsapp');
      //   }
      // }else if(Platform.isIOS) {
      //   if (await canLaunch("https://api.whatsapp.com/send?phone=${Global.vip_phone_number}=${Uri.parse(message)}")) {
      //     await launch("https://api.whatsapp.com/send?phone=${Global.vip_phone_number}=${Uri.parse(message)}");
      //     Future.delayed(Duration(milliseconds: 400)).then((value) { whatsappButton.value = false;});
      //   } else {
      //     App.error_msg(context, 'can\'t open Whatsapp');
      //     whatsappButton.value = false;
      //   }
      // }
    });
  }

}