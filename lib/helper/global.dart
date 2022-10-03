import 'dart:io';
import 'package:crc_version_1/model/company.dart';
import 'package:crc_version_1/model/login_info.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global{
  static String lang_code="en";
  static int company_id = -1;
  static bool remember_pass=false;
  static LoginInfo? loginInfo;
  static String remember_password="non";
  static RxString companyImage = ''.obs;
  static String companyTitle = '';
  static String vip_phone_number = '+971551073649';
  static Company? company;

  static save_language(String locale){
    SharedPreferences.getInstance().then((prefs){
      prefs.setString("lang", locale);
    });
  }


  static Future<String> load_language()async{
    try{
      SharedPreferences prefs= await SharedPreferences.getInstance();
      String lang=prefs.getString("lang")??'def';
      if(lang!="def"){
        Global.lang_code=lang;
      }else{
        Global.lang_code="en";
      }
      return Global.lang_code;
    }catch(e){

      return "en";
    }

  }
}