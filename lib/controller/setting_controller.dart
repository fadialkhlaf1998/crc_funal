
import 'dart:io';

import 'package:crc_version_1/app_localization.dart';
import 'package:crc_version_1/controller/car_list_controller.dart';
import 'package:crc_version_1/helper/api.dart';
import 'package:crc_version_1/helper/app.dart';
import 'package:crc_version_1/helper/global.dart';
import 'package:crc_version_1/helper/myTheme.dart';
import 'package:crc_version_1/helper/store.dart';
import 'package:crc_version_1/main.dart';
import 'package:crc_version_1/view/login.dart';
import 'package:crc_version_1/view/no_internet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SettingController extends GetxController{

  CarListController carListController = Get.put(CarListController());

  Rx<MyTheme> myTheme = MyTheme().obs;
  final isDialOpen = ValueNotifier(false);
  final ImagePicker _picker = ImagePicker();
  var currentLanguage = 'English'.obs;
  RxList<File> companyImage = <File>[].obs;
  RxBool imageLoading = false.obs;
  RxBool loading = false.obs;
  RxBool openLanguagesList = false.obs;
  RxList<bool> languagesCheck = [Global.lang_code == 'en' ? true : false,Global.lang_code == 'en' ? false : true].obs;



  @override
  void onInit() {
    super.onInit();
    if(Global.lang_code == "en"){
      currentLanguage.value = 'English';
    }else{
      currentLanguage.value = 'العربية';
    }
  }

  List languages = [
    {
      "name" : "English",
      "id" : "en"
    },
    {
      "name" : "العربية",
      "id" : "ar"
    }
  ];


  changeMode(BuildContext context){
    myTheme.value.toggleTheme();
    MyApp.set_theme(context);
  }

  logout(){
    Store.logout();
    Get.offAll(()=>LogIn());
  }

  goToCarList(){
    // carListController.updateCarList();
    Get.back();
  }


  changeLanguage(BuildContext context, String language){
    MyApp.set_local(context,Locale(language));
    Get.updateLocale(Locale(language));
    Global.save_language(language);
    Global.load_language();

  }

  updateImage(){
    _picker.pickImage(source: ImageSource.gallery).then((value1) {
      if(value1 != null){
        imageLoading.value = true;
        Api.check_internet().then((internet){
          if(internet){
            Api.updateCompanyImage(Global.company_id.toString(),value1.path).then((value){
              if(value){
                Api.login(Global.loginInfo!.email, Global.loginInfo!.pass).then((value){
                  Global.companyImage.value = value.profileImage;
                  Global.company = value;
                  imageLoading.value = false;
                });
                print('Success');
              }else{
                print('Field');
              }
            });
          }else{
            Get.to(()=>NoInternet());
          }
        });
      }
    });

  }

  Future<void> showMyDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(App_Localization.of(context).translate("confirm")),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(App_Localization.of(context).translate("confirm_text")),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(App_Localization.of(context).translate("yes")),
              onPressed: () {
                deletAccount(context);
              },
            ),
            TextButton(
              child: Text(App_Localization.of(context).translate("no")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  deletAccount(BuildContext context)async{
    loading.value = true;
    bool internet = await Api.check_internet();
    if(internet){
      bool succ = await Api.delectAccount(Global.company!.sub_admin_id);
      loading.value = false;
      if(succ){
        logout();
      }else{
        App.error_msg(context, App_Localization.of(context).translate("something_went_wrong"));
      }
    }else{
      loading.value = false;
      Get.to(()=>NoInternet());
    }
  }

}