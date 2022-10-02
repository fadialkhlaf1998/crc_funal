import 'package:crc_version_1/app_localization.dart';
import 'package:crc_version_1/controller/edit_car_controller.dart';
import 'package:crc_version_1/controller/intro_controller.dart';
import 'package:crc_version_1/controller/my_car_list_controller.dart';
import 'package:crc_version_1/helper/api.dart';
import 'package:crc_version_1/helper/app.dart';
import 'package:crc_version_1/helper/global.dart';
import 'package:crc_version_1/widget/logo_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class EditCar extends StatelessWidget {

  EditCarController editCarController = Get.put(EditCarController());
  MyCarListController myCarListController = Get.find();
  IntroController introController = Get.find();


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Obx((){
      return Scaffold(
        body: SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              editCarController.imagePage.value == false
              ? SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.09,bottom: MediaQuery.of(context).size.height * 0.13),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            _header(context),
                            const SizedBox(height: 30),
                            _body(context),
                          ],
                        ),
                      ],
                    ),
                ),
              )
              : SingleChildScrollView(
                child: _editImageList(context),
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
              editCarController.showChoose.value?_chooseImage(context):Center(),
              editCarController.loading.value == false
                  ? Text('')
                  :  WillPopScope(
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
                      Text(App_Localization.of(context).translate('saving_your_car_information'),
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

  _chooseImage(BuildContext context){
    return SafeArea(
      child: GestureDetector(
        onTap: (){
          //todo
          editCarController.showChoose.value = false;
        },
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 180,
                child: Center(
                  child: Container(
                      width: 150,
                      height: 65,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: ()async{
                                //todo camera
                                editCarController.addCamera(context);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt,size: 35,color: App.primary,),
                                  Text(App_Localization.of(context).translate("camera"),style: TextStyle(color: App.primary,fontSize: 11,fontWeight: FontWeight.bold),)
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: ()async{
                                //todo gallery
                                editCarController.addImage(context);
                              },
                              child:Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.photo,size: 35,color: App.primary,),
                                  Text(App_Localization.of(context).translate("gallery"),style: TextStyle(color: App.primary,fontSize: 11,fontWeight: FontWeight.bold),)
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
                    editCarController.goBack();
                    //Get.back();
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
    return Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.width * 0.2,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:  NetworkImage(editCarController.image!.value)
                )
              ),
            ),
            Column(
              children: [
                Container(
                  child: Text(editCarController.brand!.value,style: Theme.of(context).textTheme.headline2,),
                ),
                Container(
                  child: Text(
                    editCarController.model!.value + ' / '+ editCarController.year!.value,
                    style: Theme.of(context).textTheme.headline3,),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
            editCarController.saveInfo(context);
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

  _body(context){
    return Obx((){
      return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _brand(context),
            _model(context),
            _year(context),
            _color(context),
            _price(context),
            _rentMonth(context),
           // _location(context),
            _image(context)
          ],
        ),
      );
    });

  }

  _brand(context){
    return Column(
        children: [
          Container(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(App_Localization.of(context).translate('brand'),style: Theme.of(context).textTheme.bodyText1),
                Text(editCarController.brand!.value,
                    style: TextStyle(fontSize: 15,color: Colors.grey)
                ),
              ],
            ),
          ),
          Divider(thickness: 1,color: Theme.of(context).dividerColor.withOpacity(0.2),height: 10,)
        ],
      );

  }
  _model(context){
    return Column(
      children: [
        Container(
          height: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(App_Localization.of(context).translate('car_model'),style: Theme.of(context).textTheme.bodyText1),
              Text(editCarController.model!.value,
                  style: TextStyle(fontSize: 15,color: Colors.grey)
              ),
            ],
          ),
        ),
        Divider(thickness: 1,color: Theme.of(context).dividerColor.withOpacity(0.2),height: 10,)
      ],
    );
  }
  _year(context){
    return Column(
      children: [
        Container(
          height: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(App_Localization.of(context).translate('year'),style: Theme.of(context).textTheme.bodyText1),
              Text(editCarController.year!.value,
                  style: TextStyle(fontSize: 15,color: Colors.grey)
              ),
            ],
          ),
        ),
        Divider(thickness: 1,color: Theme.of(context).dividerColor.withOpacity(0.2),height: 10,)
      ],
    );
  }
  _color(context){
    return Column(
      children: [
        Container(
          height: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(App_Localization.of(context).translate('color'),style: Theme.of(context).textTheme.bodyText1),
              Text(editCarController.color!.value,
                  style: TextStyle(fontSize: 15,color: Colors.grey)
              ),
            ],
          ),
        ),
        Divider(thickness: 1,color: Theme.of(context).dividerColor.withOpacity(0.2),height: 10,)
      ],
    );
  }
  _price(context){
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            editCarController.editPrice();
          },
          child: Container(
            //duration: Duration(milliseconds: 500),
            color: Colors.transparent,
            height:  40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(App_Localization.of(context).translate('daily_rent'),style: Theme.of(context).textTheme.bodyText1),
                Row(
                  children: [
                    Text(editCarController.price!.value,
                        style: TextStyle(fontSize: 15,color: Colors.grey)
                    ),
                    SizedBox(width: 5),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      child: !editCarController.editPriceOpenList.value ? Icon(Icons.arrow_forward_ios,size: 15) :Icon(Icons.keyboard_arrow_down,size: 23),
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
          height: !editCarController.editPriceOpenList.value ? 0 : MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.7,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),
                SizedBox(
                  height: 45,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: editCarController.editingController,
                    style:  TextStyle(color: Theme.of(context).dividerColor),
                    decoration: InputDecoration(
                        labelText: App_Localization.of(context).translate('enter_new_price'),
                        labelStyle: TextStyle(color: Theme.of(context).dividerColor),
                        suffixIcon: GestureDetector(
                          onTap: (){
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            editCarController.getNewPrice();
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
  _rentMonth(context){
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            editCarController.editPricePerMonth();
          },
          child: Container(
            //duration: Duration(milliseconds: 500),
            color: Colors.transparent,
            height:  40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(App_Localization.of(context).translate('rent_per_month'),style: Theme.of(context).textTheme.bodyText1),
                Row(
                  children: [
                    Text(editCarController.pricePerMonth!.value,
                        style: TextStyle(fontSize: 15,color: Colors.grey)
                    ),
                    SizedBox(width: 5),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      child: !editCarController.editPricePerMonthOpenList.value ? Icon(Icons.arrow_forward_ios,size: 15) :Icon(Icons.keyboard_arrow_down,size: 23),
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
          height: !editCarController.editPricePerMonthOpenList.value ? 0 : MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.7,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),
                SizedBox(
                  height: 45,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: editCarController.editingMonthlyRentController,
                    style:  TextStyle(color: Theme.of(context).dividerColor),
                    decoration: InputDecoration(
                        labelText: App_Localization.of(context).translate('enter_new_price'),
                        labelStyle: TextStyle(color: Theme.of(context).dividerColor),
                        suffixIcon: GestureDetector(
                            onTap: (){
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              editCarController.getNewPricePerMonth();
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
  _location(context){
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            editCarController.editLocation();
          },
          child: Container(
            color: Colors.transparent,
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(App_Localization.of(context).translate('location'),style: Theme.of(context).textTheme.bodyText1),
                Row(
                  children: [
                    Text(editCarController.location!.value,
                        style: TextStyle(fontSize: 15,color: Colors.grey)
                    ),
                    SizedBox(width: 5),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 800),
                      child: !editCarController.editLocationOpenList.value ? Icon(Icons.arrow_forward_ios,size: 15) :Icon(Icons.keyboard_arrow_down,size: 23),
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
          height: !editCarController.editLocationOpenList.value ? 0 : MediaQuery.of(context).size.height * 0.15,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20,),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: editCarController.emirates.length,
                    itemBuilder: (context,index){
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              editCarController.getNewLocation(index);
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.33,
                                  height: MediaQuery.of(context).size.height * 0.1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: AssetImage('assets/emirates/${editCarController.emiratesPhoto[index]}'),
                                        fit: BoxFit.cover,
                                      )
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.33,
                                  height: MediaQuery.of(context).size.height * 0.1,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Text(
                                  Global.lang_code == 'en' ? editCarController.emirates[index] : editCarController.emiratesArabic[index],
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: editCarController.emiratesCheck[index] == true
                                          ? Theme.of(context).primaryColor
                                      : Colors.white,
                                      fontWeight:  editCarController.emiratesCheck[index] == true ? FontWeight.bold : null,
                                      fontSize:  editCarController.emiratesCheck[index] == true ? 15 : 13),
                                )
                              ],
                            ),
                          ),
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

  _image(context){
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            editCarController.imagePage.value = true;
          },
          child: Container(
            color: Colors.transparent,
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(App_Localization.of(context).translate('images'),style: Theme.of(context).textTheme.bodyText1),
                Row(
                  children: [
                    Text((editCarController.imageList.length + editCarController.newImageList.length).toString(),style: TextStyle(fontSize: 15,color: Colors.grey)),
                    const SizedBox(width: 10,),
                    const Icon(Icons.arrow_forward_ios,size: 18),
                  ],
                ),
              ],
            ),
          ),
        ),
        Divider(thickness: 1,color: Theme.of(context).dividerColor.withOpacity(0.2),height: 10,)
      ],
    );
  }

  _editImageList(context){
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.15),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: editCarController.imageList.length,
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: (){

                  },
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height * 0.1,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(Api.url + 'uploads/' + editCarController.imageList[index].path)
                                  )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: GestureDetector(
                                onTap: (){
                                  editCarController.removeImage(index);
                                },
                                child: const Icon(Icons.delete,size: 22),
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(thickness: 1,color: Theme.of(context).dividerColor.withOpacity(0.2),height: 20,)
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: editCarController.newImageList.length,
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: (){

                  },
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height * 0.1,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(editCarController.newImageList[index])
                                  )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: GestureDetector(
                                onTap: (){
                                  editCarController.removeNewImage(index);
                                },
                                child: const Icon(Icons.delete,size: 22),
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(thickness: 1,color: Theme.of(context).dividerColor.withOpacity(0.2),height: 20,)
                    ],
                  ),
                );
              },
            ),
          ),
          GestureDetector(
              onTap: () async{
               editCarController.chooseOption();
              },
              child: Container(
                width: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedContainer(
                        duration: Duration(milliseconds: 350),
                        width:  50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: editCarController.choosePhotoCheck.value
                              ? BorderRadiusDirectional.circular(0)
                              :  BorderRadiusDirectional.circular(10),
                          color: Theme.of(context).primaryColor,
                        ),
                        child:  AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: editCarController.choosePhotoCheck.value ?  Icon(Icons.close, color: Colors.white,) : Icon(Icons.add, color: Colors.white,),
                        )
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: editCarController.choosePhotoCheck.value
                          ?  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Global.lang_code == 'en'
                              ? GestureDetector(
                            onTap: (){
                              if((editCarController.imageList.length + editCarController.newImageList.length) == 8){
                                App.info_msg(context, App_Localization.of(context).translate('you_can_upload_just_eight_photos'));
                              }else {
                                editCarController.selectPhotosFromCamera();
                              }
                            },
                            child: Container(
                              width:  60,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(25),
                                    topLeft: Radius.circular(25)
                                ),
                                color: Theme.of(context).primaryColor,
                              ),
                              child:const Icon(Icons.camera, color: Colors.white,),
                            ),
                          )
                              : GestureDetector(
                            onTap: (){
                              if((editCarController.imageList.length + editCarController.newImageList.length) == 8){
                                App.info_msg(context, App_Localization.of(context).translate('you_can_upload_just_eight_photos'));
                              }else{
                                editCarController.selectImage(context);
                              }
                            },
                            child: Container(
                              width: 60,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(25),
                                    topRight: Radius.circular(25)
                                ),
                                color: Theme.of(context).primaryColor,
                              ),
                              child:  Icon(Icons.photo, color: Colors.white,),
                            ),
                          ),
                          Global.lang_code == 'en'
                              ? GestureDetector(
                            onTap: (){
                              if((editCarController.imageList.length + editCarController.newImageList.length) == 8){
                                App.info_msg(context, App_Localization.of(context).translate('you_can_upload_just_eight_photos'));
                              }else{
                                editCarController.selectImage(context);
                              }
                            },
                            child: Container(
                              width: 60,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(25),
                                    topRight: Radius.circular(25)
                                ),
                                color: Theme.of(context).primaryColor,
                              ),
                              child:  Icon(Icons.photo, color: Colors.white,),
                            ),
                          )
                              : GestureDetector(
                            onTap: (){
                              if((editCarController.imageList.length + editCarController.newImageList.length) == 8){
                                App.info_msg(context, App_Localization.of(context).translate('you_can_upload_just_eight_photos'));
                              }else {
                                editCarController.selectPhotosFromCamera();
                              }
                            },
                            child: Container(
                              width:  60,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(25),
                                    topLeft: Radius.circular(25)
                                ),
                                color: Theme.of(context).primaryColor,
                              ),
                              child:const Icon(Icons.camera, color: Colors.white,),
                            ),
                          )
                        ],
                      )
                          : Text(''),
                    ),
                  ],
                ),
              )
          ),
          // GestureDetector(
          //   onTap: (){
          //     // editCarController.addImage(context);
          //    editCarController.showChoose.value = true;
          //   },
          //   child: Container(
          //     width: MediaQuery.of(context).size.width * 0.45,
          //     height: MediaQuery.of(context).size.width * 0.12,
          //     decoration: BoxDecoration(
          //       color: Theme.of(context).primaryColor,
          //       borderRadius: BorderRadius.circular(10)
          //     ),
          //     child: Center(
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //         children: [
          //           Icon(Icons.add,color: Colors.white,size: 35),
          //           Text(App_Localization.of(context).translate("add_image"),style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold, color: Colors.white),),
          //           Icon(Icons.add,color: Colors.transparent,size: 35),
          //         ],
          //       )
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }


}
