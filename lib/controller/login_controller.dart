import 'dart:io';
import 'package:crc_version_1/app_localization.dart';
import 'package:crc_version_1/helper/api.dart';
import 'package:crc_version_1/helper/app.dart';
import 'package:crc_version_1/helper/global.dart';
import 'package:crc_version_1/helper/store.dart';
import 'package:crc_version_1/model/company.dart';
import 'package:crc_version_1/view/home.dart';
import 'package:crc_version_1/view/no_internet.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginController extends GetxController{
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  RxList<Accepted> myOrdersRejected = <Accepted>[].obs;
  RxList<Accepted> myOrdersPending = <Accepted>[].obs;
  RxList<Accepted> myOrdersAccepted = <Accepted>[].obs;
  RxList<Accepted> customerOrdersRejected = <Accepted>[].obs;
  RxList<Accepted> customersOrdersPending = <Accepted>[].obs;
  RxList<Accepted> customersOrdersAccepted = <Accepted>[].obs;

  var loading = false.obs;
  var submited = false.obs;
  var sign_up_option = false.obs;
  RxBool showPassword = false.obs;

  submite(BuildContext context){
    loading.value = true;
    Api.check_internet().then((internet) {
      if(internet){
        if(username.text.isNotEmpty && password.text.isNotEmpty){
          submited.value=true;
          Api.login(username.text, password.text).then((company) {
            if(company.id!=-1){
              Global.loginInfo!.email=username.text;
              Global.loginInfo!.pass=password.text;
              myOrdersRejected.addAll(company.myOrders.rejected);
              myOrdersPending.addAll(company.myOrders.pending);
              myOrdersAccepted.addAll(company.myOrders.accepted);
              customerOrdersRejected.addAll(company.customerOrders.rejected);
              customersOrdersPending.addAll(company.customerOrders.pending);
              customersOrdersAccepted.addAll(company.customerOrders.accepted);
              Store.Save_login();
              Global.company_id=company.id;
              Global.companyImage.value = company.profileImage;
              Global.companyTitle = company.title;
              Global.company = company;
              Get.offAll(()=>Home());
            }else if (company.id == -1){
              ///Wrong email pr password
              loading.value = false;
              App.error_msg(context, App_Localization.of(context).translate('wrong_email_password'));
            }
          }).catchError((err){
            print(err);
            loading.value=false;
          });
        }else{
          submited.value=true;
        }
      }else{
        Get.to(()=>NoInternet())!.then((value) {
          submite(context);
        });
      }
    });
  }


  phoneButton() async{
    if(Platform.isAndroid){
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: Global.vip_phone_number,
      );
      await launch(launchUri.toString());
    }else if (Platform.isIOS){
      launch("tel://${Global.vip_phone_number}");
    }

  }

  whatsAppButton(context)async{
    String message = "Hello\n\nI want to join to Car Rental Club (CRC)\n\nThanks";
    if (Platform.isAndroid){
      if(await canLaunch("https://wa.me/${Global.vip_phone_number}/?text=${Uri.parse(message)}")){
        await launch("https://wa.me/${Global.vip_phone_number}/?text=${Uri.parse(message)}");

      }else{
        App.error_msg(context, App_Localization.of(context).translate('not_open_whatsapp'));
      }
    }else if(Platform.isIOS) {
      if (await canLaunch("https://api.whatsapp.com/send?phone=${Global.vip_phone_number}=${Uri.parse(message)}")) {
        await launch("https://api.whatsapp.com/send?phone=${Global.vip_phone_number}=${Uri.parse(message)}");
      } else {
        App.error_msg(context, App_Localization.of(context).translate('not_open_whatsapp'));
      }
    }
  }


}