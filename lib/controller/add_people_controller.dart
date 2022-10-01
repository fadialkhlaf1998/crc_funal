import 'package:crc_version_1/app_localization.dart';
import 'package:crc_version_1/helper/api.dart';
import 'package:crc_version_1/helper/app.dart';
import 'package:crc_version_1/helper/global.dart';
import 'package:crc_version_1/view/people_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';


class AddPeopleController extends GetxController{

  RxInt currentStep = 0.obs;

  RxList language = ['English', 'Arabic','French','Urdu','Russian'].obs;

  RxList select = [false, false, false,false , false].obs;
  String selectLanguages = '';
  final ImagePicker _picker = ImagePicker();
  TextEditingController username = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  List<File> userImage = <File>[].obs;
  double? companyID;
  RxBool loadingUpload = false.obs;


  @override
  void onInit() {
    super.onInit();
    userImage = <File>[].obs;
    companyID = Global.company_id.toDouble();
  }

  selectLanguage(index) {
    select[index] = !select[index];
  }
  var selectedLangValidate = false.obs;
  var usernameValidate = false.obs;
  var phoneValidate = false.obs;

  save(context)async{
    selectedLangValidate.value = false;
    usernameValidate.value = false;
    phoneValidate.value = false;
    // bool can_add = true;

    for(int i = 0; i < select.length; i++) {
      if (select[i] == true && selectLanguages != '') {
        selectLanguages += ' / ' + language[i];
      } else if (select[i] == true) {
        selectLanguages += language[i];
      }
    }
    print(selectLanguages);
    if(selectLanguages == ''){
      // selectedLangValidate.value = true;
      App.info_msg(context, App_Localization.of(context).translate('you_should_select_language'));
      // return ;
    }
    if( username.text.isEmpty){
      App.info_msg(context, App_Localization.of(context).translate('name_cant_be_empty'));
      // return ;
      usernameValidate.value = true;
    }
    if(mobileNumber.text.isEmpty){
      App.info_msg(context, App_Localization.of(context).translate('phone_cannot_be_empty'));
      // return ;
      phoneValidate.value = true;
    }
    if(!phoneValidate.value && !usernameValidate.value && !selectedLangValidate.value){
      if(userImage.isEmpty){
        final byteData = await rootBundle.load('assets/images/profile_picture.png');
        final file = File('${(await getTemporaryDirectory()).path}/profile_picture.png');
        await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        userImage.add(file);
      }
      loadingUpload.value = true;
      Api.addPerson(username.text, userImage.first, mobileNumber.text, selectLanguages, companyID!).then((value){
        loadingUpload.value = false;
        Get.off(()=>PeopleList());
      });
    }

  }
  forwardStep(context)async{
    if(currentStep.value >= 3){
      selectLanguages = '';
      for(int i = 0; i < select.length; i++) {
        if (select[i] == true && selectLanguages != '') {
          selectLanguages += ' / ' + language[i];
        } else if (select[i] == true) {
          selectLanguages += language[i];
        }
      }
      if(selectLanguages == ''){
          App.info_msg(context, App_Localization.of(context).translate('you_should_select_language'));
      }else{
        currentStep.value += 1;
        loadingUpload.value = true;
        if(userImage.isEmpty){
          final byteData = await rootBundle.load('assets/images/profile_picture.png');
          final file = File('${(await getTemporaryDirectory()).path}/profile_picture.png');
          await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
          userImage.add(file);
        }
        Api.addPerson(username.text, userImage.first, mobileNumber.text, selectLanguages, companyID!).then((value){
          Future.delayed(Duration(milliseconds: 500)).then((value){
            loadingUpload.value = false;
            Get.off(()=>PeopleList());
          });
        });
        }
    }
    else if(currentStep.value == 0){
      if( username.text.isEmpty){
        App.info_msg(context, App_Localization.of(context).translate('name_cant_be_empty'));
      }else{
        currentStep.value +=1;
      }
    }
    else if (currentStep.value == 1){

      currentStep.value +=1;
    }
    else if(currentStep.value == 2){
      if(mobileNumber.text.isEmpty){
        App.info_msg(context, 'Mobile number is necessary');
      }else{
        currentStep.value +=1;
      }
    }
  }

  backwardStep(){
    if(currentStep.value <= 0){

    }else{
      currentStep.value -=1;
    }
  }

  Future selectImage()async{
    _picker.pickImage(source: ImageSource.gallery).then((value){
      userImage.add(File(value!.path));
    });
  }


}