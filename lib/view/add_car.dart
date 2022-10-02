import 'dart:io';
import 'package:crc_version_1/app_localization.dart';
import 'package:crc_version_1/controller/add_car_controller.dart';
import 'package:crc_version_1/controller/intro_controller.dart';
import 'package:crc_version_1/helper/app.dart';
import 'package:crc_version_1/helper/global.dart';
import 'package:crc_version_1/helper/myTheme.dart';
import 'package:crc_version_1/widget/logo_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AddCar extends StatelessWidget {

  AddCarController addCarController = Get.put(AddCarController());
  final formGlobalKey = GlobalKey<FormState>();
  IntroController introController = Get.find();
  ScrollController _scrollController = ScrollController();

  AddCar(){
    addCarController.tempBrandsList[addCarController.brandIndex.value ].selected.value = false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Obx((){
      return Scaffold(
        body: GestureDetector(
          onTap: (){
            
          },
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: _header(context),
                    ),
                    Expanded(
                      flex: 3,
                      child:GestureDetector(
                        onTap: (){
                          print('***********');
                          FocusScope.of(context).unfocus();
                        },
                        child: _body(context),
                      )

                    ),
                  ],
                ),
                addCarController.loadingUpload.value
                    ? WillPopScope(
                  onWillPop: ()async => false,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                color: Theme.of(context).dividerColor.withOpacity(0.9),
                                child: _loading(context),
                              ),
                              Text(App_Localization.of(context).translate('saving_your_car_information'),
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
      height: MediaQuery.of(context).size.height * 0.22,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2), // changes position of shadow
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
                    addCarController.backwardStep();
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
              ),
              LogoContainer(width: 0.35, height: 0.07, logo: 'logo_orange'),
              SizedBox(width: 80),
            ],
          ),
          _stepper(context),
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
            child: SvgPicture.asset('assets/icons/add_brand.svg',color: Theme.of(context).backgroundColor,width: 30,height: 30,),
          ),
          Expanded(child: Divider(
              color: addCarController.currentStep.value < 1 ? Theme.of(context).dividerColor : Theme.of(context).primaryColor, indent: 1, endIndent: 1, thickness: 1),),
          CircleAvatar(
            backgroundColor: addCarController.currentStep.value < 1 ? Theme.of(context).dividerColor : Theme.of(context).primaryColor,
            child: SvgPicture.asset('assets/icons/add_model.svg',color: Theme.of(context).backgroundColor,width: 35,height: 35,),
          ),
          Expanded(child: Divider(
              color: addCarController.currentStep.value < 2 ? Theme
                  .of(context)
                  .dividerColor : Theme
                  .of(context)
                  .primaryColor, indent: 1, endIndent: 1, thickness: 1),),
          CircleAvatar(
            backgroundColor: addCarController.currentStep.value < 2 ? Theme.of(context).dividerColor : Theme.of(context).primaryColor,
            child: SvgPicture.asset('assets/icons/add_year.svg',color: Theme.of(context).backgroundColor,width: 35,height: 35,),
          ),
          Expanded(child: Divider(
              color: addCarController.currentStep.value < 3 ? Theme
                  .of(context)
                  .dividerColor : Theme
                  .of(context)
                  .primaryColor, indent: 1, endIndent: 1, thickness: 1),),
          CircleAvatar(
            backgroundColor: addCarController.currentStep.value < 3 ? Theme.of(context).dividerColor : Theme.of(context).primaryColor,
            child: SvgPicture.asset('assets/icons/add_color.svg',color: Theme.of(context).backgroundColor,width: 35,height: 35,),
          ),
          // Expanded(child: Divider(
          //     color: addCarController.currentStep.value < 4 ? Theme
          //         .of(context)
          //         .dividerColor : Theme
          //         .of(context)
          //         .primaryColor, indent: 1, endIndent: 1, thickness: 1),),
          // CircleAvatar(
          //   backgroundColor: addCarController.currentStep.value < 4 ? Theme.of(context).dividerColor : Theme.of(context).primaryColor,
          //   child: SvgPicture.asset('assets/icons/add_location.svg',color: Theme.of(context).backgroundColor,width: 40,height: 40,),
          // ),
          Expanded(child: Divider(
              color: addCarController.currentStep.value < 5 ? Theme
                  .of(context)
                  .dividerColor : Theme
                  .of(context)
                  .primaryColor, indent: 1, endIndent: 1, thickness: 1),),
          CircleAvatar(
            backgroundColor: addCarController.currentStep.value < 4 ? Theme.of(context).dividerColor : Theme.of(context).primaryColor,
            child: SvgPicture.asset('assets/icons/add_photo.svg',color: Theme.of(context).backgroundColor,width: 30,height: 30,),
          ),
          Expanded(child: Divider(
              color: addCarController.currentStep.value < 6 ? Theme
                  .of(context)
                  .dividerColor : Theme
                  .of(context)
                  .primaryColor, indent: 1, endIndent: 1, thickness: 1),),
          CircleAvatar(
            backgroundColor: addCarController.currentStep.value < 5 ? Theme.of(context).dividerColor : Theme.of(context).primaryColor,
            child: SvgPicture.asset('assets/icons/add_price.svg',color: Theme.of(context).backgroundColor,width: 35,height: 35,),
          ),
          SizedBox(width: 20),
        ],
      ),
    );
  }

  _body(context) {
    return Container(
      height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height * 0.22 - 24,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 6,
            child:addCarController.currentStep.value == 0 ? _brandList(context)
                : addCarController.currentStep.value == 1 ? _modelList(context)
                : addCarController.currentStep.value == 2 ? _yearModel(context)
                : addCarController.currentStep.value == 3 ?  _color(context)
                : addCarController.currentStep.value == 4 ?  _carImage(context)
                : _carPrice(context)
          ),
            // MediaQuery.of(context).viewInsets.bottom == 0
            //     ? Expanded(
            //   flex: 1,
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: Theme.of(context).backgroundColor,
            //       boxShadow: [
            //         BoxShadow(
            //           color: Theme.of(context).dividerColor.withOpacity(0.1),
            //           spreadRadius: 1,
            //           blurRadius: 5,
            //           offset: Offset(0, -1), // changes position of shadow
            //         ),
            //       ],
            //     ),
            //     child: Center(
            //       child:  Container(
            //         height: 50,
            //         width: MediaQuery.of(context).size.width * 0.6,
            //         decoration: BoxDecoration(
            //             color: Theme.of(context).primaryColor,
            //             borderRadius: BorderRadius.circular(5)),
            //         child: TextButton(
            //           onPressed: () async {
            //             addCarController.forwardStep(context);
            //           },
            //           child: Text(
            //             addCarController.currentStep.value >= 6 ? App_Localization.of(context).translate('save') : App_Localization.of(context).translate('next') ,
            //             style: const TextStyle(
            //                 color: Colors.white,
            //                 fontSize: 25,
            //                 fontWeight: FontWeight.bold),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // )
            //     :
          addCarController.currentStep.value > 3
              ? Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).dividerColor.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, -1), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(
                  child:  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: TextButton(
                      onPressed: () async {
                        addCarController.forwardStep(context);
                      },
                      child: Text(
                        addCarController.currentStep.value >= 5 ? App_Localization.of(context).translate('save') : App_Localization.of(context).translate('next') ,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            )
              : Text('')
        ],
      ),
    );
  }

  _brandList(context){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                onChanged: (value){
                  addCarController.filterSearchBrand(value);
                },
                controller: addCarController.search,
                autofocus: false,
                style:  TextStyle(color: Theme.of(context).dividerColor),
                decoration: InputDecoration(
                  hintText: App_Localization.of(context).translate('search'),
                  prefixIcon: Icon(Icons.search,color: Theme.of(context).dividerColor),
                  contentPadding: const EdgeInsets.all(5),
                  hintStyle: TextStyle(color: Theme.of(context).dividerColor,fontSize: 14),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  focusColor: Colors.grey.withOpacity(0.5),
                  hoverColor: Colors.grey.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(height: 10),
            addCarController.tempBrandsList.isEmpty 
            ? Text(App_Localization.of(context).translate('no_results_matched'))
             : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: addCarController.tempBrandsList.length,// introController.brands.length,
              itemBuilder: (context, index){
                return Column(
                  children: [
                    Obx((){
                      return  GestureDetector(
                        onTap: (){
                          addCarController.selectBrand(index);
                          addCarController.forwardStep(context);
                        },
                        child:  Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          color: Colors.transparent,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    child:  Image.network(addCarController.tempBrandsList[index].image),
                                  ),
                                  const SizedBox(width: 20),
                                  Text(addCarController.tempBrandsList[index].title,style: Theme.of(context).textTheme.bodyText1,),
                                ],
                              ),
                              addCarController.tempBrandsList[index].selected.value ? Icon(Icons.check,color: Theme.of(context).primaryColor,) : Text(''),
                            ],
                          ),
                        ),
                      );
                    }),
                    Divider(thickness: 1,color: Theme.of(context).dividerColor.withOpacity(0.2),indent: 25,endIndent: 25,)
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _modelList(context){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                onChanged: (value){
                  addCarController.filterModelSearch(value);
                },
                controller: addCarController.searchModel,
                autofocus: false,
                style: TextStyle(color: Theme.of(context).dividerColor),
                decoration: InputDecoration(
                  hintText: App_Localization.of(context).translate('search'),
                  prefixIcon: Icon(Icons.search,color: Theme.of(context).dividerColor),
                  contentPadding: EdgeInsets.all(5),
                  hintStyle: TextStyle(fontSize: 14,color: Theme.of(context).dividerColor),
                  filled: true,
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  focusColor: Colors.grey.withOpacity(0.5),
                  hoverColor: Colors.grey.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(height: 10),
            addCarController.tempModelsList.isEmpty
                ? Text(App_Localization.of(context).translate('no_results_matched'))
            : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:  addCarController.tempModelsList.length,
              itemBuilder: (context, index){
                return Column(
                  children: [
                    Obx((){
                      return  GestureDetector(
                        onTap: (){
                          addCarController.selectModel(index);
                          addCarController.forwardStep(context);
                        },
                        child:  Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          color: Colors.transparent,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(addCarController.tempModelsList[index].title,style: Theme.of(context).textTheme.bodyText1,),
                                ],
                              ),
                              addCarController.tempModelsList[index].selected.value ? Icon(Icons.check,color: Theme.of(context).primaryColor,) : Text(''),
                            ],
                          ),
                        ),
                      );
                    }),
                    Divider(thickness: 1,color: Theme.of(context).dividerColor.withOpacity(0.2),indent: 25,endIndent: 25,height: 25,)
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _yearModel(context){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount:  10,
              itemBuilder: (context, index){
                return Column(
                  children: [
                    Obx((){
                      return  GestureDetector(
                        onTap: (){
                          addCarController.selectYear(index);
                          addCarController.forwardStep(context);
                        },
                        child:  Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          color: Colors.transparent,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(addCarController.yearModelList[index].toString(),style: Theme.of(context).textTheme.bodyText1,),
                                ],
                              ),
                              addCarController.selectYearIndex![index] ? Icon(Icons.check,color: Theme.of(context).primaryColor,) : Text(''),
                            ],
                          ),
                        ),
                      );
                    }),
                    Divider(thickness: 1,color: Theme.of(context).dividerColor.withOpacity(0.2),indent: 25,endIndent: 25,height: 30,)
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _color(context){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:  introController.colors.length,
              itemBuilder: (context, index){
                return Column(
                  children: [
                    Obx((){
                      return  GestureDetector(
                        onTap: (){
                          addCarController.selectColor(index);
                          addCarController.forwardStep(context);
                        },
                        child:  Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          color: Colors.transparent,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(introController.colors[index].title,style: Theme.of(context).textTheme.bodyText1,),
                                ],
                              ),
                              addCarController.selectColorIndex![index] ? Icon(Icons.check,color: Theme.of(context).primaryColor,) : Text(''),
                            ],
                          ),
                        ),
                      );
                    }),
                    Divider(thickness: 1,color: Theme.of(context).dividerColor.withOpacity(0.2),indent: 25,endIndent: 25,height: 30,)
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _location(context){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount:  addCarController.emirates.length,
              itemBuilder: (context, index){
                return Column(
                  children: [
                    Obx((){
                      return  GestureDetector(
                        onTap: (){
                          addCarController.selectEmirates(index);
                          addCarController.forwardStep(context);
                        },
                        child:  Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: addCarController.selectEmiratesIndex![index] ? Theme.of(context).primaryColor.withOpacity(0.2) :Colors.grey.withOpacity(0.1) ,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height * 0.1,
                                    width:  MediaQuery.of(context).size.width * 0.3,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                      ),
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image:AssetImage('assets/emirates/${addCarController.emiratesPhoto[index]}'),
                                      )
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Text(addCarController.emirates[index],style: Theme.of(context).textTheme.bodyText1,),
                                ],
                              ),
                              addCarController.selectEmiratesIndex![index] ?
                              Padding(
                                padding: EdgeInsets.only(right: 10,left: 10),
                                child: Icon(Icons.check,color: Theme.of(context).primaryColor,),
                              ) : Text(''),
                            ],
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 20,),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _carImage(context){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            const SizedBox(height: 20,),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: addCarController.imageList.length,
              itemBuilder: (context, int index){
                return Column(
                  children: [
                   Container(
                     width: MediaQuery.of(context).size.width* 0.9,
                     child:  Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Container(
                           width: MediaQuery.of(context).size.width * 0.4,
                           height: MediaQuery.of(context).size.height * 0.12,
                           decoration: BoxDecoration(
                             color: Theme.of(context).primaryColor,
                             borderRadius: BorderRadius.circular(10),
                             image: DecorationImage(
                               fit: BoxFit.cover,
                               image: FileImage(File(addCarController.imageList[index].path)),
                             )
                           ),
                         ),
                         IconButton(
                           onPressed: (){
                             addCarController.deleteImageFromList(index);
                           },
                           icon: Icon(Icons.delete),
                         ),
                       ],
                     ),
                   ),
                    Divider(thickness: 1,color: Theme.of(context).dividerColor.withOpacity(0.2),indent: 25,endIndent: 25,)
                  ],
                );
              },
            ),
            GestureDetector(
                onTap: () async{
                    addCarController.chooseOption();
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
                            borderRadius: addCarController.choosePhotoCheck.value
                                ? BorderRadiusDirectional.circular(0)
                            :  BorderRadiusDirectional.circular(10),
                            color: Theme.of(context).primaryColor,
                          ),
                          child:  AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: addCarController.choosePhotoCheck.value ?  Icon(Icons.close, color: Colors.white,) : Icon(Icons.add, color: Colors.white,),
                          )
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        child: addCarController.choosePhotoCheck.value
                            ?  Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Global.lang_code == 'en'
                                    ? GestureDetector(
                                  onTap: (){
                                    if(addCarController.imageList.length == 8){
                                      App.info_msg(context, App_Localization.of(context).translate('you_can_upload_just_eight_photos'));
                                    }else {
                                      addCarController.selectPhotosFromCamera();
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
                                    if(addCarController.imageList.length == 8){
                                      App.info_msg(context, App_Localization.of(context).translate('you_can_upload_just_eight_photos'));
                                    }else{
                                      addCarController.selectImage(context);
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
                                    if(addCarController.imageList.length == 8){
                                      App.info_msg(context, App_Localization.of(context).translate('you_can_upload_just_eight_photos'));
                                    }else{
                                      addCarController.selectImage(context);
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
                                    if(addCarController.imageList.length == 8){
                                      App.info_msg(context, App_Localization.of(context).translate('you_can_upload_just_eight_photos'));
                                    }else {
                                      addCarController.selectPhotosFromCamera();
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
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  _carPrice(context){
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Form(
        key: formGlobalKey,
        child: Column(
          children: [
            Text(App_Localization.of(context).translate('choose_the_rent_per_day'),style: Theme.of(context).textTheme.headline2,),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 80,
              child: TextFormField(
                style: Theme.of(context).textTheme.headline3,
                controller: addCarController.carPrice,
                validator: (price) {
                  if (price!.isEmpty) {
                    return App_Localization.of(context).translate(
                        'mobile_number_is_required');
                  }
                  return null;
                },
                decoration: InputDecoration(
                  errorStyle: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Theme.of(context).dividerColor),
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Theme.of(context).dividerColor)
                  ),
                  labelStyle: Theme.of(context).textTheme.bodyText2,
                  labelText: '* ' + App_Localization.of(context).translate('price') + ' ('+ App_Localization.of(context).translate('required') + ') ',
                  hintText: App_Localization.of(context).translate('enter_the_price_you_went'),
                  hintStyle: Theme.of(context).textTheme.headline4,
                  //suffixText: App_Localization.of(context).translate('aed'),
                  suffixIcon: GestureDetector(
                    onTap: (){
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                    child: Icon(Icons.check),
                  ),
                  suffixStyle: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold)
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 50),
            // Text(App_Localization.of(context).translate('enter_the_rent_per_month'),style: Theme.of(context).textTheme.headline2,),
            // Container(
            //   width: MediaQuery.of(context).size.width * 0.9,
            //   height: 80,
            //   child: TextFormField(
            //     style: Theme.of(context).textTheme.headline3,
            //     controller: addCarController.carPricePerMonth,
            //     validator: (price) {
            //       if (price!.isEmpty) {
            //         return App_Localization.of(context).translate(
            //             'mobile_number_is_required');
            //       }
            //       return null;
            //     },
            //     decoration: InputDecoration(
            //         errorStyle: const TextStyle(
            //             color: Colors.red, fontWeight: FontWeight.bold),
            //         focusedBorder: UnderlineInputBorder(
            //           borderSide: BorderSide(width: 1, color: Theme.of(context).dividerColor),
            //         ),
            //         enabledBorder: UnderlineInputBorder(
            //             borderSide: BorderSide(width: 1, color: Theme.of(context).dividerColor)
            //         ),
            //         labelStyle: Theme.of(context).textTheme.bodyText2,
            //         labelText: "* "+App_Localization.of(context).translate('rent_per_month')+ ' (' + App_Localization.of(context).translate('required') + ')',
            //         hintText: App_Localization.of(context).translate('enter_the_rent_per_month') ,
            //         hintStyle: Theme.of(context).textTheme.headline4,
            //         //suffixText: App_Localization.of(context).translate('aed'),
            //         suffixIcon: GestureDetector(
            //           onTap: (){
            //             FocusScopeNode currentFocus = FocusScope.of(context);
            //             if (!currentFocus.hasPrimaryFocus) {
            //               currentFocus.unfocus();
            //             }
            //           },
            //           child: Icon(Icons.check),
            //         ),
            //         suffixStyle: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold)
            //     ),
            //     keyboardType: TextInputType.number,
            //   ),
            // ),
          ],
        ),
      ),
    );

  }

  _loading(context){
    return Container(
      child: Lottie.asset('assets/images/data.json'),
    );
  }

  _choosePhotoOption(){

  }

  showAlertDialog(BuildContext context) {

    Widget closeButton = TextButton(
      child: Text("Close",style: Theme.of(context).textTheme.headline3,),
      onPressed: () {
        Get.back();
      },
    );
    AlertDialog alert = AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: Theme.of(context).backgroundColor,
      shape: const RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(
              Radius.circular(10.0))),
      content: Builder(
        builder: (context) {
          return Container(
            height: 70,
            width: 100,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: (){

                    },
                    icon: Icon(Icons.camera,size: 50,),
                  ),
                  SizedBox(width: 50,),
                  IconButton(
                    onPressed: (){

                    },
                    icon: Icon(Icons.photo,size: 50,),
                  )
                ],
              ),
            ),
          );
        },
      ),
      actions: [
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