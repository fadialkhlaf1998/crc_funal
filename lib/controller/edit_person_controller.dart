import 'dart:developer';
import 'dart:io';
import 'package:crc_version_1/app_localization.dart';
import 'package:crc_version_1/controller/add_people_controller.dart';
import 'package:crc_version_1/controller/people_list_controller.dart';
import 'package:crc_version_1/helper/api.dart';
import 'package:crc_version_1/helper/app.dart';
import 'package:crc_version_1/helper/global.dart';
import 'package:crc_version_1/view/people_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class EditPersonController extends GetxController{
  
  PeopleListController peopleListController = Get.find();
  AddPeopleController addPeopleController = Get.put(AddPeopleController());

  RxInt personIndex = 0.obs;
  RxBool editNameList = false.obs;
  RxBool editNumberList = false.obs;
  RxBool editLanguageList = false.obs;
  TextEditingController? editingNameController;
  TextEditingController? editingNumberController;
  List allLanguages = [];
  List staticLanguages = [];
  RxList myLanguage = [].obs;
  final ImagePicker _picker = ImagePicker();
  RxList<File> personImage = <File>[].obs;
  RxInt checkImageChange = 0.obs;

  String selectedPhoneCode = '';
  RxList<bool>? languageCheck;
  RxBool loading = false.obs;
  RxBool initLoading = false.obs;

  /// Edit Variable
  RxString? name;
  RxString? phone;
  RxString? languages;
  RxList<File> newImage = <File>[].obs;
  int personId = -1;
  PhoneNumber? phoneNumber;

  @override
  void onInit() async{
    super.onInit();
    initLoading.value = true;
    personIndex.value = peopleListController.currentIndex!.value;
    print('INIT');
    print(peopleListController.myPeopleList[personIndex.value].phone);

    phoneNumber =  await PhoneNumber.getRegionInfoFromPhoneNumber(peopleListController.myPeopleList[personIndex.value].phone);
    // print(phoneNumber!.phoneNumber!+"*-*-*-*-*-*");
    name = peopleListController.myPeopleList[personIndex.value].name.obs;
    phone = peopleListController.myPeopleList[personIndex.value].phone.obs;
    myLanguage = peopleListController.myPeopleList[personIndex.value].languages.split(' / ').obs;
    languages = myLanguage.join(' / ').obs;
    personId = peopleListController.myPeopleList[personIndex.value].id;
    personImage.add(File(peopleListController.myPeopleList[personIndex.value].image));
    editingNameController = TextEditingController(text: name!.value);
    selectedPhoneCode = phoneNumber!.dialCode!;
    editingNumberController = TextEditingController(text: phoneNumber!.phoneNumber!.split(selectedPhoneCode)[1]);
    staticLanguages = addPeopleController.language;
    allLanguages = addPeopleController.language;

    print(selectedPhoneCode);
    // if(Global.lang_code == 'en'){
    //
    // }else{
    //   allLanguages = addPeopleController.languageArabic;
    // }
    languageCheck = List.filled(allLanguages.length, false).obs;
   // myLanguage.value = peopleListController.myPeopleList[personIndex.value].languages.split(' / ');
    for(int i = 0; i < staticLanguages.length; i++){
      if (myLanguage.contains(staticLanguages[i])){
        languageCheck![i] = true;
      }
    }
    initLoading.value = false;
  }

  editName(){
    editNameList.value = !editNameList.value;
  }
  editNumber(){
    editNumberList.value = !editNumberList.value;
  }
  editLanguage(){
    editLanguageList.value = !editLanguageList.value;
  }

  getNewName(v){
    name!.value = v;
  }

  getNewPhone(v){
    phone!.value = v;
  }

  getNewLanguages(){
    languages = myLanguage.join(' / ').obs;
  }

  changePersonImage(){
    _picker.pickImage(source: ImageSource.gallery).then((value){
      if(value != null){
        checkImageChange.value = 1;
        if(newImage.isEmpty){
          newImage.add(File(value.path));
        }else if(newImage.isNotEmpty){
          newImage[0] = File(value.path);
        }
      }else{

      }
    });
  }

  deletePersonImage(){
    checkImageChange.value = 2;
    if(newImage.isEmpty){
      newImage.add(File('assets/images/profile_picture.png'));
      Get.back();
    }else if (newImage.isNotEmpty){
      newImage[0] = File('assets/images/profile_picture.png');
      Get.back();
    }


  }

  changeLanguage(context, index){
    if(languageCheck![index] == false){
      languageCheck![index] = true;
      myLanguage.add(staticLanguages[index]);
      print(myLanguage.length);
      for(int i = 0 ; i < myLanguage.length; i++ ){
        print(myLanguage[i]);
      }
    }else if(languageCheck![index] == true){
      int count = 0;
      for (int i = 0; i < languageCheck!.length; i++){
        if (languageCheck![i] == true){
          count++;
        }
      }
      if (count == 1){
        App.info_msg(context, App_Localization.of(context).translate('there_must_be_at_least_one_language'));
      }else{
        languageCheck![index] = false;
        myLanguage.removeAt(myLanguage.indexOf(staticLanguages[index]));
        print(myLanguage.length);
        for(int i = 0 ; i < myLanguage.length; i++){
          print('-' + myLanguage[i] + '-');
        }
      }
    }

    if(myLanguage.isEmpty){
      languages = ''.obs;
    }else{
      languages = myLanguage.join(' / ').obs;
    }

  }

  savePersonInformation(context){
    if (editingNameController!.text.isEmpty){
      App.info_msg(context, App_Localization.of(context).translate('name_cant_be_empty'));
    }else if (editingNumberController!.text.isEmpty){
      App.info_msg(context, App_Localization.of(context).translate('number_cant_be_empty'));
    }else{
      loading.value = true;
      Api.check_internet().then((internet){
        if(internet){
          if(newImage.isNotEmpty){
            personImage[0] = File(newImage[0].path);
          }
          Api.updatePersonInformation(
              name!.value,
              phone!.value,
              languages!.value,
              Global.company_id.toString(),
              personId.toString(),
              personImage[0],
              checkImageChange.value
          ).then((value){
            if(value == true){
              loading.value = false;
              Get.back();
              peopleListController.getInfo(Global.company_id);
            }else{
              loading.value = false;
            }
          });
        }else{
          loading.value = false;
        }
      });
    }
  }


}