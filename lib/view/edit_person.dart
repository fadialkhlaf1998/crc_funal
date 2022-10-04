import 'dart:io';

import 'package:crc_version_1/app_localization.dart';
import 'package:crc_version_1/controller/edit_person_controller.dart';
import 'package:crc_version_1/controller/people_list_controller.dart';
import 'package:crc_version_1/helper/api.dart';
import 'package:crc_version_1/helper/app.dart';
import 'package:crc_version_1/helper/global.dart';
import 'package:crc_version_1/helper/myTheme.dart';
import 'package:crc_version_1/widget/logo_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:lottie/lottie.dart';


class EditPerson extends StatelessWidget {

  PeopleListController peopleListController = Get.find();
  EditPersonController editPersonController = Get.put(EditPersonController());


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Obx((){
      return Scaffold(
        body: SafeArea(
          child: editPersonController.initLoading.value?Center(child: CircularProgressIndicator(),):Stack(
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.13),
                  child: Column(
                    children: [
                      _header(context),
                      const SizedBox(height: 30),
                      _body(context),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _appBar(context),
                  AnimatedSwitcher(
                    duration:const Duration(milliseconds: 100),
                    child: MediaQuery.of(context).viewInsets.bottom == 0 ? _footer(context) : Text(''),
                  ),
                ],
              ),
              editPersonController.loading.value == false
                  ? Text('')
                  :  WillPopScope(
                  onWillPop: () async => false,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: Theme.of(context).dividerColor.withOpacity(0.9),
                        child: Container(
                          child: Lottie.asset('assets/images/data.json'),
                        ),
                      ),
                      Text(App_Localization.of(context).translate('saving_person_information'),
                          style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Theme.of(context).backgroundColor)),
                    ],
                  )
              )
            ],
          ),
        ),
      );
    });
  }


  _appBar(context){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
              padding: const EdgeInsets.only(right: 5,left: 5),
              child: IconButton(
                onPressed: (){
                  //editController.goBack();
                  Get.back();
                  // editCarController.editPriceOpenList.value = false;
                  // editCarController.editImageList.value = false;
                },
                icon: const Icon(Icons.arrow_back_ios,size: 20,),
              )
          ),
          LogoContainer(width: 0.35, height: 0.07, logo: 'logo_orange'),
          SizedBox(width: 50,)
        ],
      ),
    );

  }

  _header(context){
    return Obx((){
      return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.09),
        height: MediaQuery.of(context).size.height * 0.15,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                GestureDetector(
                    onTap: (){
                      showAlertDialog(context);
                    },
                    child: editPersonController.checkImageChange.value == 2
                        ? Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1,color: Theme.of(context).dividerColor.withOpacity(0.1)),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(editPersonController.newImage[0].path)
                          )
                      ),
                    )
                        : editPersonController.checkImageChange.value == 1
                        ? Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1,color: Theme.of(context).dividerColor.withOpacity(0.1)),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(editPersonController.newImage[0].path))
                          )
                      ),
                    )
                        : Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1,color: Theme.of(context).dividerColor.withOpacity(0.1)),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(Api.url +'uploads/'+ editPersonController.personImage[0].path)
                          )
                      ),
                    )
                ),
                GestureDetector(
                  onTap: (){
                    editPersonController.changePersonImage();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.07,
                    height: MediaQuery.of(context).size.width * 0.07,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.edit,color: Colors.white,size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Container(
              width: MediaQuery.of(context).size.width* 0.2,
              child:  Text(
                editPersonController.name!.value,
                maxLines: 4,
                style: Theme.of(context).textTheme.headline2,
              ),
            )
          ],
        ),
      );
    });
  }

  _name(context){
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            editPersonController.editName();
          },
          child: Container(
            color: Colors.transparent,
            height:  40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(App_Localization.of(context).translate('name'),style: Theme.of(context).textTheme.bodyText1),
                Row(
                  children: [
                    Container(
                      width: 150,
                      child:  Text(editPersonController.name!.value,
                          maxLines: 1,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 15,color: Colors.grey)
                      ),
                    ),
                    const SizedBox(width: 5),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      child: !editPersonController.editNameList.value ? Icon(Icons.arrow_forward_ios,size: 15) :Icon(Icons.keyboard_arrow_down,size: 23),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 500),
          height: !editPersonController.editNameList.value  ? 0 : MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.7,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),
                SizedBox(
                  height: 45,
                  child: TextField(
                    onChanged: (value){
                      editPersonController.getNewName(value);
                    },
                    controller: editPersonController.editingNameController,
                    style:  TextStyle(color: Theme.of(context).dividerColor),
                    decoration: InputDecoration(
                        labelText: App_Localization.of(context).translate('enter_new_name'),
                        labelStyle: TextStyle(color: Theme.of(context).dividerColor),
                        suffixIcon: GestureDetector(
                            onTap: (){
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              editPersonController.getNewName(editPersonController.editingNameController!.text);
                            },
                            child: Icon(Icons.check,color: Theme.of(context).primaryColor,)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 1,color: Theme.of(context).primaryColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 1,color: Theme.of(context).dividerColor.withOpacity(0.5)),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),)),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(thickness: 1,color: Theme.of(context).dividerColor.withOpacity(0.2),height: 10,)
      ],
    );
  }
  _personMobile(context){

    return Column(
      children: [
        GestureDetector(
          onTap: (){
            editPersonController.editNumber();
          },
          child: Container(
            color: Colors.transparent,
            height:  40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(App_Localization.of(context).translate('mobile_number'),style: Theme.of(context).textTheme.bodyText1),
                Row(
                  children: [
                    Container(
                      width: 150,
                      child: Text(editPersonController.phone!.value,
                          maxLines: 1,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 15,color: Colors.grey)
                      ),
                    ),
                    SizedBox(width: 5),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      child: !editPersonController.editNumberList.value ? Icon(Icons.arrow_forward_ios,size: 15) :Icon(Icons.keyboard_arrow_down,size: 23),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 500),
          height: !editPersonController.editNumberList.value  ? 0 : MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.7,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),
                SizedBox(
                  height: 45,
                  child: IntlPhoneField(
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Theme.of(context).dividerColor),
                    controller:  editPersonController.editingNumberController,
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
                      // errorText:   editPersonController.phoneValidate.value  ? App_Localization.of(context).translate('phone_cannot_be_empty') : null,
                      hintText: App_Localization.of(context).translate('enter_phone_number'),
                      hintStyle:  TextStyle(
                        color: App.grey,
                        fontSize: 14,
                      ),

                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color:   Theme.of(context).dividerColor.withOpacity(0.5))
                      ),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color:    Theme.of(context).dividerColor.withOpacity(0.5))
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color:    Theme.of(context).dividerColor.withOpacity(0.5))
                      ),
                    ),
                    initialCountryCode: 'AE',
                    disableLengthCheck: true,
                    dropdownIcon: Icon(Icons.arrow_drop_down_outlined,color:  Theme.of(context).dividerColor.withOpacity(0.5)),
                    dropdownTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14
                    ),
                    flagsButtonMargin: const EdgeInsets.symmetric(horizontal: 10),
                    showDropdownIcon: true,
                    dropdownIconPosition: IconPosition.trailing,
                    onChanged: (phone) {
                      int max = countries.firstWhere((element) => element.code == phone.countryISOCode).maxLength;
                      if(  editPersonController.editingNumberController!.text.length > max){
                        editPersonController.editingNumberController!.text =   editPersonController.editingNumberController!.text.substring(0,max);
                      }
                      editPersonController.selectedPhoneCode = phone.countryCode;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(thickness: 1,color: Theme.of(context).dividerColor.withOpacity(0.2),height: 10,)
      ],
    );
  }

  _mobileNumber(context){

    return Column(
      children: [
        GestureDetector(
          onTap: (){
            editPersonController.editNumber();
          },
          child: Container(
            color: Colors.transparent,
            height:  40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(App_Localization.of(context).translate('mobile_number'),style: Theme.of(context).textTheme.bodyText1),
                Row(
                  children: [
                    Container(
                      width: 150,
                      child: Text(editPersonController.phone!.value,
                          maxLines: 1,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 15,color: Colors.grey)
                      ),
                    ),
                    SizedBox(width: 5),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      child: !editPersonController.editNumberList.value ? Icon(Icons.arrow_forward_ios,size: 15) :Icon(Icons.keyboard_arrow_down,size: 23),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 500),
          height: !editPersonController.editNumberList.value  ? 0 : MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.7,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),
                SizedBox(
                  height: 45,
                  child: IntlPhoneField(
                    textAlign: TextAlign.start,
                    // initialValue: PhoneNumber(),
                    style: TextStyle(color: Theme.of(context).dividerColor),
                    controller:  editPersonController.editingNumberController,
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
                      // errorText:   editPersonController.phoneValidate.value  ? App_Localization.of(context).translate('phone_cannot_be_empty') : null,
                      hintText: App_Localization.of(context).translate('enter_phone_number'),
                      hintStyle:  TextStyle(
                        color: App.grey,
                        fontSize: 14,
                      ),

                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color:   Theme.of(context).dividerColor.withOpacity(0.5))
                      ),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color:    Theme.of(context).dividerColor.withOpacity(0.5))
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color:    Theme.of(context).dividerColor.withOpacity(0.5))
                      ),
                    ),
                    initialCountryCode: 'AE',
                    disableLengthCheck: true,
                    dropdownIcon: Icon(Icons.arrow_drop_down_outlined,color:  Theme.of(context).dividerColor.withOpacity(0.5)),
                    dropdownTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14
                    ),
                    flagsButtonMargin: const EdgeInsets.symmetric(horizontal: 10),
                    showDropdownIcon: true,
                    dropdownIconPosition: IconPosition.trailing,
                    onChanged: (phone) {
                      int max = countries.firstWhere((element) => element.code == phone.countryISOCode).maxLength;
                      if(  editPersonController.editingNumberController!.text.length > max){
                        editPersonController.editingNumberController!.text =   editPersonController.editingNumberController!.text.substring(0,max);
                      }
                      editPersonController.selectedPhoneCode = phone.countryCode;
                      editPersonController.phone!.value = editPersonController.selectedPhoneCode + editPersonController.editingNumberController!.text;
                      print(editPersonController.phone!.value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(thickness: 1,color: Theme.of(context).dividerColor.withOpacity(0.2),height: 10,)
      ],
    );
  }

  _language(context){
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            editPersonController.editLanguage();
            editPersonController.getNewLanguages();
          },
          child: Container(
            color: Colors.transparent,
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(App_Localization.of(context).translate('language'),style: Theme.of(context).textTheme.bodyText1),
                Row(
                  children: [
                    Text(editPersonController.myLanguage.length.toString(),
                        style: const TextStyle(fontSize: 15,color: Colors.grey)
                    ),

                    const SizedBox(width: 5),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 800),
                      child: !editPersonController.editLanguageList.value ? Icon(Icons.arrow_forward_ios,size: 15) :Icon(Icons.keyboard_arrow_down,size: 23),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          curve: Curves.fastOutSlowIn,
          duration: const Duration(milliseconds: 500),
          height: !editPersonController.editLanguageList.value? 0 : MediaQuery.of(context).size.height * 0.1,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20,),
                Container(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: editPersonController.allLanguages.length,
                    itemBuilder: (context,index){
                      return Row(
                        children: [
                        Obx((){
                          return   GestureDetector(
                            onTap: (){
                              editPersonController.changeLanguage(context, index);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1, color: Theme.of(context).dividerColor.withOpacity(0.4)),
                              ),
                              child:  Center(
                                child: Text(
                                  editPersonController.allLanguages[index],
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: editPersonController.languageCheck![index] == true
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).dividerColor,
                                      fontWeight: editPersonController.languageCheck![index] == true ? FontWeight.bold : null,
                                      fontSize:  editPersonController.languageCheck![index] == true ? 17 : 15),
                                ),
                              ),
                            ),
                          );
                        }),
                          const SizedBox(width: 20),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(thickness: 1,color: Theme.of(context).dividerColor.withOpacity(0.2),height: 10,)
      ],
    );
  }

  _body(context){
    return Obx((){
      return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           _name(context),
            _mobileNumber(context),
            _language(context),
          ],
        ),
      );
    });
  }

  _footer(context){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.13,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).dividerColor.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2)
          ),
        ],
      ),
      child: Center(
        child: GestureDetector(
          onTap: (){
           editPersonController.savePersonInformation(context);
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: 50,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Center(
              child: Text(
                App_Localization.of(context).translate('save'),
                style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget closeButton = TextButton(
      child: Text(App_Localization.of(context).translate('close'),style: Theme.of(context).textTheme.headline3,),
      onPressed: () {
        Get.back();
      },
    );
    Widget editButton = TextButton(
      child: Text(App_Localization.of(context).translate('delete'),style: Theme.of(context).textTheme.headline3,),
      onPressed: () {
        editPersonController.deletePersonImage();
      },
    );
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).backgroundColor,
      content: editPersonController.checkImageChange.value == 2
          ? Obx((){
              return  Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                    border: Border.all(width: 1,color: Theme.of(context).dividerColor.withOpacity(0.1)),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(editPersonController.newImage[0].path)
                    )
                ),
              );
            })
          : editPersonController.checkImageChange.value == 1
          ? Obx((){
        return  Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
              border: Border.all(width: 1,color: Theme.of(context).dividerColor.withOpacity(0.1)),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(File(editPersonController.newImage[0].path))
              )
          ),
        );
      })
          : Obx((){
        return Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
              border: Border.all(width: 1,color: Theme.of(context).dividerColor.withOpacity(0.1)),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(Api.url +'uploads/'+ editPersonController.personImage[0].path)
              )
          ),
        );
      }),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        editButton,
        closeButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



}
