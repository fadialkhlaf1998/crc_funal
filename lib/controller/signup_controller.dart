

import 'package:crc_version_1/app_localization.dart';
import 'package:crc_version_1/helper/api.dart';
import 'package:crc_version_1/helper/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController{

  TextEditingController companyName = TextEditingController();
  TextEditingController contactPersonPhone = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  var pickUpValidate = false.obs;
  RxString pickEmirate ="non".obs;
  List<String> pickUpEmirates = ['Dubai', 'Abu Dhabi', 'Ajman', 'Dubai Eye', 'Ras Al Khaimah','Sharjah','Umm Al Quwain'];
  RxString contactPhoneCode = ''.obs;
  RxString phoneCode = ''.obs;
  RxBool validateContactNumber = false.obs;
  RxBool validatePhone = false.obs;
  RxBool checkOpenDialog = false.obs;


  register(context) async {
int count =0 ;
    if(contactPersonPhone.text.isEmpty){
      validateContactNumber.value = true;
      count++;
    }
    if(companyName.text.isEmpty){
      count++;
    }
    if(phoneNumber.text.isEmpty){
      validatePhone.value = true;
      count++;
    }
    if (pickEmirate.value == "non"){
      pickUpValidate.value = true;
      count++;
    }
    if(count == 0){
      validateContactNumber.value = false;
      validatePhone.value = false;
      pickUpValidate.value = false;
      Api.check_internet().then((value){
        if(value){
          Api.register(companyName.text, contactPersonPhone.text, contactPhoneCode.value, phoneNumber.text, phoneCode.value, pickEmirate.value).then((value){
            if(value){
              /// todo
              print('Successfully');
              clearField();
              checkOpenDialog.value = true;
            }else{
              //// todo
              print('problem');
            }
          });
        }else{
          /// todo
          /// no internet
        }
      });
    }
  }

  clearField(){
    companyName.clear();
    contactPersonPhone.clear();
    phoneNumber.clear();
  }



}