import 'dart:io';

import 'package:crc_version_1/app_localization.dart';
import 'package:crc_version_1/controller/add_people_controller.dart';
import 'package:crc_version_1/helper/myTheme.dart';
import 'package:crc_version_1/widget/logo_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AddPeople extends StatelessWidget {

  AddPeopleController addPeopleController = Get.put(AddPeopleController());
  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Obx(() {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _personPhoto(context) ,
                        SizedBox(height: 20,),
                        _personName(context) ,
                        _personMobile(context) ,
                        _personLanguage(context),
                        SizedBox(height: 60,),
                      ],
                    ),
                  ),
                ),
                Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,),
                Obx(() => MediaQuery.of(context).viewInsets.bottom>0?Center():Positioned(
                    child:  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).dividerColor.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: const Offset(0, -2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.6,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: TextButton(
                            onPressed: () async {
                              addPeopleController.save(context);
                            },
                            child: Text(
                              addPeopleController.currentStep.value < 3 ? App_Localization.of(context).translate('save') : App_Localization.of(context).translate('save') ,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),bottom: 0),),
                _header(context),
                addPeopleController.loadingUpload.value
                    ? WillPopScope(
                    onWillPop: ()async => false,
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
                        Text('Saving your person information',
                            style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Theme.of(context).backgroundColor)),
                      ],
                    )
                ) : Text(''),
              ],
            ),
          ),
        ),
      );
    });
  }

  _header(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        color: Theme
            .of(context)
            .backgroundColor,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 80,
                child: IconButton(
                  onPressed: () {
                    addPeopleController.currentStep.value == 0
                        ? Get.back()
                        : addPeopleController.backwardStep();
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
              ),
              LogoContainer(width: 0.35, height: 0.07, logo: 'logo_orange'),

              SizedBox(width: 80),
            ],
          ),
          // _stepper(context),
        ],
      ),
    );
  }

  _stepper(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(width: 20),
          CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.person, color: Theme.of(context).backgroundColor),
          ),
          Expanded(child: Divider(
              color: addPeopleController.currentStep.value < 1 ? Theme.of(context).dividerColor : Theme.of(context).primaryColor, indent: 5, endIndent: 5, thickness: 1),),
          CircleAvatar(
            backgroundColor: addPeopleController.currentStep.value < 1 ? Theme.of(context).dividerColor : Theme.of(context).primaryColor,
            child: Icon(Icons.image, color: Theme.of(context).backgroundColor),
          ),
          Expanded(child: Divider(
              color: addPeopleController.currentStep.value < 2 ? Theme
                  .of(context)
                  .dividerColor : Theme
                  .of(context)
                  .primaryColor, indent: 5, endIndent: 5, thickness: 1),),
          CircleAvatar(
            backgroundColor: addPeopleController.currentStep.value < 2 ? Theme.of(context).dividerColor : Theme.of(context).primaryColor,
            child: Icon(Icons.call, color: Theme.of(context).backgroundColor),
          ),
          Expanded(child: Divider(
              color: addPeopleController.currentStep.value < 3 ? Theme
                  .of(context)
                  .dividerColor : Theme
                  .of(context)
                  .primaryColor, indent: 5, endIndent: 5, thickness: 1),),
          CircleAvatar(
            backgroundColor: addPeopleController.currentStep.value < 3 ? Theme.of(context).dividerColor : Theme.of(context).primaryColor,
            child: Icon(Icons.language, color: Theme.of(context).backgroundColor,),
          ),
          SizedBox(width: 20),
        ],
      ),
    );
  }
  //
  // _body(context) {
  //   return Container(
  //     height: MediaQuery.of(context).size.height*0.9 - MediaQuery.of(context).padding.top ,
  //     child:
  //   );
  // }

  _personName(context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      child: Form(
        // key: formGlobalKey,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 40,
              child: TextFormField(
                style: Theme.of(context).textTheme.headline3,
                controller: addPeopleController.username,
                validator: (name) {
                  if (name!.isEmpty) {
                    return App_Localization.of(context).translate(
                        'username_cannot_be_empty');
                  }
                  return null;
                },
                decoration: InputDecoration(
                  errorStyle: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1,
                        color: addPeopleController.usernameValidate.value ? Colors.red : Theme.of(context).dividerColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1,
                          color: addPeopleController.usernameValidate.value ? Colors.red : Theme.of(context).dividerColor)
                  ),
                  labelStyle: Theme
                      .of(context)
                      .textTheme
                      .bodyText2,
                  labelText: App_Localization.of(context).translate(
                      'staff_name'),
                  // hintText: App_Localization.of(context).translate(
                  //     'enter_your_username'),
                  hintStyle: Theme
                      .of(context)
                      .textTheme
                      .headline4,
                ),
                keyboardType: TextInputType.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _personMobile(context){
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Form(
        key: formGlobalKey,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 40,
              child: TextFormField(
                style: Theme.of(context).textTheme.headline3,
                controller: addPeopleController.mobileNumber,
                maxLength: 10,
                validator: (mobile) {
                  if (mobile!.isEmpty) {
                    return App_Localization.of(context).translate(
                        'mobile_number_is_required');
                  }
                  return null;
                },
                decoration: InputDecoration(
                  counterText: "",
                  errorStyle: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1,
                        color: addPeopleController.phoneValidate.value ? Colors.red : Theme.of(context).dividerColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1,
                          color: addPeopleController.phoneValidate.value ? Colors.red : Theme.of(context).dividerColor)
                  ),
                  labelStyle: Theme.of(context).textTheme.bodyText2,
                  labelText: App_Localization.of(context).translate('mobile_number'),
                  // hintText: App_Localization.of(context).translate('enter_your_mobile_number'),
                  hintStyle: Theme.of(context).textTheme.headline4,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _personPhoto(context){
    return Obx((){
      return Container(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 100),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: (){
                  addPeopleController.selectImage();
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 1000),
                  child: addPeopleController.userImage.length == 0  ?
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 40,color: Theme.of(context).backgroundColor,),
                          ],
                        ),
                        Text(App_Localization.of(context).translate('add_photo'), style: TextStyle(color: Theme.of(context).backgroundColor,fontSize: 13,fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                      : Stack(
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Center(
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(addPeopleController.userImage.first),
                                        )
                                    ),
                                  ),
                                ),
                                addPeopleController.userImage.isNotEmpty ?

                                Positioned(
                                    right: 10,
                                    bottom: 0,
                                    child: GestureDetector(onTap: (){addPeopleController.userImage.clear();},child: Icon(Icons.delete, color: Theme.of(context).dividerColor))) : Text(''),
                                
                              ],
                            )
                          ),

                        ],
                      ),
                ),
              ),

            ],
          ),
        ),
      );
    });
  }

  _personLanguage(context){
    return Container(
      padding: const EdgeInsets.only(top: 20),
      // height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width*0.9,
            child: Row(
              children: [
                Text(App_Localization.of(context).translate("select_languages")+" :",style: Theme.of(context).textTheme.bodyText1,),
              ],
            ),
          ),
          SizedBox(height: 20,),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: addPeopleController.language.length,
            itemBuilder: (context, index){
              return GestureDetector(
                onTap: (){
                  addPeopleController.selectLanguage(index);
                },
                child: Container(
                  color: Colors.transparent,
                  // height: 45,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 20, left: 20),
                            child: Text(addPeopleController.language[index].toString(), style: Theme.of(context).textTheme.bodyText1,),
                          ),
                         Obx((){
                           return  Padding(
                             padding:EdgeInsets.only(right: 20, left: 20),
                             child: addPeopleController.select[index] ? Icon(Icons.check, color: Theme.of(context).primaryColor,) : Text(''),
                           );
                         }),
                        ],
                      ),
                      Divider(thickness: 1, color: addPeopleController.selectedLangValidate.value ? Colors.red : Theme.of(context).dividerColor.withOpacity(0.2),indent: 22,endIndent: 22,),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }


}
