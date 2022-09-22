import 'dart:async';
import 'dart:ui';

import 'package:crc_version_1/app_localization.dart';
import 'package:crc_version_1/controller/car_list_controller.dart';
import 'package:crc_version_1/controller/home_controller.dart';
import 'package:crc_version_1/controller/intro_controller.dart';
import 'package:crc_version_1/helper/api.dart';
import 'package:crc_version_1/helper/app.dart';
import 'package:crc_version_1/helper/global.dart';
import 'package:crc_version_1/view/add_car.dart';
import 'package:crc_version_1/view/add_people.dart';
import 'package:crc_version_1/view/calender.dart';
import 'package:crc_version_1/view/login.dart';
import 'package:crc_version_1/view/setting.dart';
import 'package:crc_version_1/widget/background_page.dart';
import 'package:crc_version_1/widget/calender.dart';
import 'package:crc_version_1/widget/custom_button.dart';
import 'package:crc_version_1/widget/logo_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CarsList extends StatefulWidget {

  CarListController carListController = Get.find();
  IntroController introController = Get.find();
  HomeController homeController = Get.find();

  @override
  State<CarsList> createState() => _CarsListState();
}

class _CarsListState extends State<CarsList> {

  CarListController carListController = Get.find();
  IntroController introController = Get.find();
  HomeController homeController = Get.find();
  RxBool visible = false.obs;

  _CarsListState(){
    carListController.update_data();
    carListController.fillYearList();
  }

  @override
  void initState() {
    super.initState();
    carListController.controllerList.addListener(() {
      if (carListController.controllerList.position.userScrollDirection == ScrollDirection.reverse) {
        visible.value = true;
      }
      if(carListController.controllerList.position.pixels == 0){
        visible.value = false;
      }
    });

  }


    @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return WillPopScope(
      onWillPop: () async {
        if(carListController.openContactList.value == true){
          return carListController.openContactList.value = false;
        }else if (carListController.checkFilterOpen.value == true) {
          return carListController.checkFilterOpen.value = false;
        }else if (carListController.checkSortOpen.value == true){
          return carListController.checkSortOpen.value = false;
        } else if (carListController.isDialOpen.value){
         return carListController.isDialOpen.value = false;
        } else{
          Get.back();
          return carListController.openContactList.value = false;
        }
      },
      child: Scaffold(
        // floatingActionButton: Global.company_id==-1?Center():_floatButton(context),
        body:Obx((){
          return  SafeArea(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                BackgroundPage(),
                _body(context),
                _background(context),
                _filterInterface(context),
                _sortInterface(context),
                _appBar(context),
              //  Global.company_id == -1 ? _guest_msg(context) : Center(),
                Obx((){
                  return AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.fastOutSlowIn,
                    bottom: visible.value ? 10 : -60,
                    child: GestureDetector(
                      onTap: (){
                        carListController.controllerList.animateTo(0, duration: Duration(milliseconds: 1200), curve: Curves.fastOutSlowIn);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: App.primary,
                          shape: BoxShape.circle
                        ),
                        width: 50,
                        height: 50,
                        child: Icon(Icons.home, size: 30,),
                      ),
                    ),
                  );
                })
              ],
            ),
          );
        }),
      ),
    );
  }

  _guest_msg(BuildContext context){
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.07,),
        GestureDetector(
          onTap: (){
            Get.to(()=>LogIn());
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.07,
            decoration: BoxDecoration(
              color: Colors.red,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
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
            child: Center(child: Text(App_Localization.of(context).translate("please_login"),style: TextStyle(color: Colors.white))),
          ),
        )
      ],
    );
  }

  _appBar(context){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
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
                  homeController.
                  carListController.openContactList.value = false;
                  carListController.checkSortOpen.value = false;
                  carListController.checkFilterOpen.value = false;
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back_ios,size: 20,),
              )
          ),
          GestureDetector(
            onTap: (){
              carListController.openContactList.value = false;
              carListController.openFiler();
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: SvgPicture.asset('assets/images/filter.svg',
                      color: carListController.checkFilterOpen.value ? Theme.of(context).primaryColor : Theme.of(context).dividerColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                      App_Localization.of(context).translate('filter'),
                      style: TextStyle(
                        color: carListController.checkFilterOpen.value ? Theme.of(context).primaryColor : Theme.of(context).dividerColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                  ),
                ],
              ),
            ),
          ),
          VerticalDivider(
            indent: 20,
            endIndent: 20,
            thickness: 1,
            color: Theme.of(context).dividerColor,
          ),
          GestureDetector(
            onTap: (){
              carListController.openContactList.value = false;
              carListController.openSort();
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    child: SvgPicture.asset('assets/images/sort.svg',
                      color: carListController.checkSortOpen.value ? Theme.of(context).primaryColor : Theme.of(context).dividerColor),
                  ),
                  const SizedBox(width: 10),
                  Text(
                      App_Localization.of(context).translate('sort'),
                      style: TextStyle(
                          color: carListController.checkSortOpen.value ?
                          Theme.of(context).primaryColor : Theme.of(context).dividerColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15,left: 15),
            child: IconButton(
              onPressed: (){
                carListController.openContactList.value = false;
                carListController.checkSortOpen.value = false;
                carListController.checkFilterOpen.value = false;
                Get.to(()=>Settings());
              },
              icon: const Icon(Icons.menu),
            ),
          )
        ],
      ),
    );
  }

  _background(context){
    return GestureDetector(
      onTap: (){
        carListController.checkSortOpen.value = false;
        carListController.checkFilterOpen.value = false;
      },
      child:  AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        child: carListController.checkFilterOpen.value || carListController.checkSortOpen.value ? Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).dividerColor.withOpacity(0.5),
        ) : const Text(''),
      ),
    );
  }

  _body(context){
    return RefreshIndicator(
      onRefresh: ()async {
        await carListController.getCarsList(
            carListController.yearFilter.value,
            carListController.brandFilter.value,
            carListController.modelFilter.value,
            carListController.colorFilter.value,
            carListController.priceFilter.value,
          carListController.sortFilter.value
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: Global.company_id ==-1 ? 0 : MediaQuery.of(context).size.height * 0.07),
            child:carListController.loading.value
                ? Center(child: Container(child: Lottie.asset('assets/images/Animation.json')))
                : carListController.myCars.isEmpty
                ? Center(child: Text(App_Localization.of(context).translate('no_car')))
                : ListView.builder(
              controller: carListController.controllerList,
                itemCount: carListController.myCars.length,
                itemBuilder:(context, index){
                  return  Padding(
                    padding: EdgeInsets.only(top:index==0&&Global.company_id==-1?MediaQuery.of(context).size.height * 0.07:0),
                    child: Column(
                      children: [
                        Container(
                          width: Get.width * 0.9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Global.company_id == -1 ? LogoContainer(width: 0.2, height: 0.05, logo: 'logo_orange') : _companyInfo(context, index),
                              const SizedBox(height: 10),
                              _carInfo(context,index),
                              const SizedBox(height: 10),
                              Global.company_id == -1
                                  ?
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.2,vertical: 10),
                                child: CustomButton(
                                    width: 0.5,
                                    height: 40,
                                    text: App_Localization.of(context).translate('register_to_see_price'),
                                    onPressed: (){
                                      Get.off(()=>LogIn());
                                    },
                                    color: App.primary,
                                    borderRadius: 5,
                                    borderColor: Colors.white,
                                    borderWidth: 1,
                                    border: false,
                                    textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                    )
                                ),
                              ) : _contactOptions(context,index),
                            ],
                          ),
                        ),
                        Divider(thickness: 1, indent: 20,endIndent: 20,color: Theme.of(context).dividerColor.withOpacity(0.2),height: 25,),
                      ],
                    ),
                  );
                }
            ),
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 400),
            child: carListController.openContactList.value ? _showContactsList(context) : Text('')
          ),
        ],
      ),
    );
  }


  _companyInfo(context, index){
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.1,
            height:  MediaQuery.of(context).size.width * 0.1,
            decoration: BoxDecoration(
               //color: Colors.white,
              // shape: BoxShape.circle,
              //border: Border.all(width: 1,color:Color(0XFF202428).withOpacity(0.2)),
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: NetworkImage(Api.url + 'uploads/' + carListController.myCars[index].companyImage)
              )
            ),
          ),
          const SizedBox(width: 10),
          Text(carListController.myCars[index].company,style: Theme.of(context).textTheme.headline2,),
        ],
      ),
    );
  }

  _carInfo(context,index){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width* 0.9,
              height: MediaQuery.of(context).size.height * 0.24,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(20),
                ),
              child:ImageSlideshow(
                width: double.infinity,
                height: MediaQuery.of(context).size.height*0.2,
                initialPage: 0,
                indicatorColor: Theme.of(context).primaryColor,
                indicatorBackgroundColor: Colors.grey,
                children:
                  carListController.myCars.value[index].images.map((e) => Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(Api.url+"uploads/"+ e.link),
                            fit: BoxFit.cover
                        )
                    ),
                  )).toList()
                ,
                autoPlayInterval: 0,
                isLoop: false,
              ),
            ),

          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
                child: Global.company_id==-1?Text(App_Localization.of(context).translate('daily_rent') + '  ' + "????" + ' ' + App_Localization.of(context).translate('aed'),style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15, fontWeight: FontWeight.bold),)
                    :Text(App_Localization.of(context).translate('daily_rent') + '  ' + carListController.myCars[index].pricPerDay.toString() + ' ' + App_Localization.of(context).translate('aed'),style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15, fontWeight: FontWeight.bold),),
              ),
              carListController.myCars[index].pricePerMonth == null ||  carListController.myCars[index].pricePerMonth == 0 ?
              SizedBox(height: 0,) : Container(
                child: Global.company_id==-1?Text(App_Localization.of(context).translate('rent_per_month') + '  ' + "????" + ' ' + App_Localization.of(context).translate('aed'),style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15, fontWeight: FontWeight.bold),)
                    :Text(App_Localization.of(context).translate('rent_per_month') + '  ' + carListController.myCars[index].pricePerMonth.toString() + ' ' + App_Localization.of(context).translate('aed'),style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15, fontWeight: FontWeight.bold),),
              ),
              Container(
                  width: MediaQuery.of(context).size.width  * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(carListController.myCars[index].brand + ' - ' + carListController.myCars[index].model, maxLines: 2,overflow: TextOverflow.ellipsis,style: Theme.of(context).textTheme.headline2),],)
              ),
              Container(
                child: Text(App_Localization.of(context).translate('year') + ' : ' + carListController.myCars[index].year.toString(),style: Theme.of(context).textTheme.headline3),
              ),

            ],
          ),
        ),

        // Text(),
        // Text(),

      ],
    );
  }

  _contactOptions(context,index) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              if(carListController.myCars[index].avilable == 1){
                carListController.getContactData(carListController.myCars[index].companyId);
                carListController.bookOnWhatsappCheck = false.obs;
                carListController.openContactList.value = true;
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: MediaQuery.of(context).size.width * 0.3 - 5,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color:  App.grey,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.phone,color: App.primary,size: 20,),
                  const SizedBox(width: 5),
                  Text(App_Localization.of(context).translate('phone'),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 13),)
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if(carListController.myCars[index].avilable == 1){
                carListController.getContactData(carListController.myCars[index].companyId);
                carListController.bookOnWhatsappCheck = true.obs;
                carListController.carIndex.value = index;
                carListController.openContactList.value = true;
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3 - 5,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: App.grey,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 23,
                    child: SvgPicture.asset('assets/icons/whatsapp.svg', color: Colors.green,fit: BoxFit.cover,),
                  ),
                  const SizedBox(width: 5,),
                  Text(App_Localization.of(context).translate('whatsapp'), style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 13),)
                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              if(Global.company!=null){
                if(carListController.myCars[index].avilable == 1){
                  Get.to(()=>MyRangeCalender(carListController.myCars[index].id,carListController.myCars[index].pricPerHr, carListController.myCars[index].pricPerDay));
                }
              }else{
                Get.to(()=>LogIn());
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3 - 5,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: App.grey,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 23,
                    child: SvgPicture.asset('assets/icons/reserve.svg', color: App.primary,fit: BoxFit.cover,),
                  ),
                  const SizedBox(width: 5,),
                  Text(App_Localization.of(context).translate('reserve'), style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _filterInterface(context){
    return AnimatedContainer(
      width: MediaQuery.of(context).size.width,
      height: carListController.checkFilterOpen.value ? MediaQuery.of(context).size.height  * 0.6 : 10,
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      duration: Duration(milliseconds: 800),
      curve: Curves.fastOutSlowIn,
      child: SingleChildScrollView(
        child: Column(
          //alignment: Alignment.bottomCenter,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 800),
              curve: Curves.fastOutSlowIn,
              height: carListController.checkFilterOpen.value ? MediaQuery.of(context).size.height  * 0.52 : 10,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height  * 0.1,),
                    _yearFilterMenu(context),
                    const SizedBox(height: 10,),
                    _brandFilterMenu(context),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: carListController.brandFilter.value != '%'
                          ? Column(children: [const SizedBox(height: 10,) ,_modelFilterMenu(context),const SizedBox(height: 10,)],)
                          : Text('')
                    ),
                    _colorFilterMenu(context),
                    const SizedBox(height: 10,),
                    _priceFilterMenu(context),
                  ],
                ),
              ),
            ),
            AnimatedContainer(
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.fastOutSlowIn,
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).dividerColor.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, -1),
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: carListController.checkFilterOpen.value ? MediaQuery.of(context).size.height  * 0.08 : 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){
                            carListController.getFilterResult();
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.height * 0.04,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                App_Localization.of(context).translate('done'),
                                style: TextStyle(
                                    color: Theme.of(context).backgroundColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: IconButton(
                            onPressed: (){
                              carListController.clearFilterValue();
                            },
                            icon: Icon(Icons.delete_outline),
                          ),
                        ),
                      ],
                    ),
                  )
              ),
          ],
        ),
      ),
    );
  }

  _yearFilterMenu(context){
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.fastOutSlowIn,
      width: MediaQuery.of(context).size.width * 0.9,
      height: carListController.yearListOpen.value ? MediaQuery.of(context).size.height * 0.09 : 30,
      child: SingleChildScrollView(
        physics: !carListController.yearListOpen.value ? const NeverScrollableScrollPhysics() :null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: (){
                  carListController.openYearFilterList();
                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(App_Localization.of(context).translate('year'), style: Theme.of(context).textTheme.headline2,),
                      carListController.yearListOpen.value ?  Icon(Icons.keyboard_arrow_up_outlined) : Icon(Icons.keyboard_arrow_down_outlined),
                    ],
                  ),
                )
            ),
            const SizedBox(height: 15),
            Container(
              height: 30,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: carListController.yearModelList.length,
                itemBuilder: (context, index){
                  return Row(
                    children: [
                      Obx((){
                        return  GestureDetector(
                          onTap: (){
                            carListController.chooseYearFilter(index);
                          },
                          child: Container(
                            width: 50,
                            decoration: BoxDecoration(
                                color: !carListController.yearModelListCheck[index] == true
                                    ? Theme.of(context).backgroundColor
                                    : Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.4),width: 1)
                            ),
                            child: Center(
                              child:  Text(
                                carListController.yearModelList[index].toString(),
                                style: TextStyle(
                                    color: carListController.yearModelListCheck[index] == true
                                        ? Colors.white
                                        : Theme.of(context).dividerColor
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      SizedBox(width: 10,),
                    ],
                  );
                },
              )
            ),
          ],
        ),
      ),
    );
  }

  _brandFilterMenu(context){
    return AnimatedContainer(
      duration: Duration(milliseconds: 800),
      curve: Curves.fastOutSlowIn,
      width: MediaQuery.of(context).size.width * 0.9,
      height: carListController.brandListOpen.value ? MediaQuery.of(context).size.height * 0.09 : 30,
      child: SingleChildScrollView(
        physics: !carListController.brandListOpen.value ? const NeverScrollableScrollPhysics() : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: (){
                  carListController.openBrandFilterList();
                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(App_Localization.of(context).translate('brand'), style: Theme.of(context).textTheme.headline2,maxLines: 2,),
                      carListController.brandListOpen.value ?  Icon(Icons.keyboard_arrow_up_outlined) : Icon(Icons.keyboard_arrow_down_outlined),
                    ],
                  ),
                )
            ),
            const SizedBox(height: 15),
            Container(
              height: 30,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: introController.brands.length,
                itemBuilder: (context, index){
                  return Row(
                    children: [
                     Obx((){
                       return  GestureDetector(
                         onTap: (){
                           carListController.chooseBrandFilter(index);
                         },
                         child: Container(
                           //width: 80,
                           padding: EdgeInsets.symmetric(horizontal: 12),
                           decoration: BoxDecoration(
                               color: !carListController.brandListCheck![index] == true
                                   ? Theme.of(context).backgroundColor
                                   : Theme.of(context).primaryColor,
                               borderRadius: BorderRadius.circular(10),
                               border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.4),width: 1)
                           ),
                           child: Center(
                             child: Text(
                               introController.brands[index].title,textAlign: TextAlign.center,
                               style: TextStyle(
                                   color: !carListController.brandListCheck![index] == true
                                       ? Theme.of(context).dividerColor
                                       : Colors.white,
                                   fontSize: 11,fontWeight: FontWeight.bold),),
                           ),
                         ),
                       );
                     }),
                      SizedBox(width: 8,),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _modelFilterMenu(context){
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.fastOutSlowIn,
      width: MediaQuery.of(context).size.width * 0.9,
      height: carListController.carModelListOpen.value ? MediaQuery.of(context).size.height * 0.09 : 30,
      child: SingleChildScrollView(
        physics: !carListController.carModelListOpen.value ? const NeverScrollableScrollPhysics() :null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: (){
                  carListController.openCarModelFilterList();
                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child: Text(App_Localization.of(context).translate('car_model'), style: Theme.of(context).textTheme.headline2,),
                      ),
                      carListController.carModelListOpen.value ?  Icon(Icons.keyboard_arrow_up_outlined) : Icon(Icons.keyboard_arrow_down_outlined),
                    ],
                  ),
                )
            ),
            const SizedBox(height: 15),
            Container(
              height: 30,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: introController.brands[carListController.selectedBrand.value].models.length,
                itemBuilder: (context, index){
                  return Row(
                    children: [
                     Obx((){
                       return  GestureDetector(
                         onTap: (){
                           carListController.chooseModelFilter(index);
                         },
                         child: Container(
                           //width: 90,
                           padding: EdgeInsets.symmetric(horizontal: 10),
                           decoration: BoxDecoration(
                               color: !carListController.modelListCheck![index] == true
                                   ? Theme.of(context).backgroundColor
                               : Theme.of(context).primaryColor,
                               borderRadius: BorderRadius.circular(10),
                               border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.4),width: 1)
                           ),
                           child: Center(
                             child: Text(
                               introController.brands[carListController.selectedBrand.value].models[index].title,textAlign: TextAlign.center,
                               maxLines: 1,
                               overflow: TextOverflow.ellipsis,
                               style: TextStyle(
                                   color: carListController.modelListCheck![index] == true
                                       ? Theme.of(context).dividerColor
                                       : Colors.white,
                                   fontSize: 12,
                                   fontWeight: FontWeight.bold),),
                           ),
                         ),
                       );
                     }),
                      SizedBox(width: 8,),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _colorFilterMenu(context){
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.fastOutSlowIn,
      width: MediaQuery.of(context).size.width * 0.9,
      height: carListController.colorListOpen.value ? MediaQuery.of(context).size.height * 0.09 : 30,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: (){
                  carListController.openColorFilterList();
                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(App_Localization.of(context).translate('color'), style: Theme.of(context).textTheme.headline2,),
                      carListController.colorListOpen.value ?  Icon(Icons.keyboard_arrow_up_outlined) : Icon(Icons.keyboard_arrow_down_outlined),
                    ],
                  ),
                )
            ),
            const SizedBox(height: 15),
            Container(
              height: 30,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: introController.colors.length,
                itemBuilder: (context, index){
                  return Row(
                    children: [
                      Obx((){
                        return GestureDetector(
                          onTap: (){
                            carListController.chooseColorFilter(index);
                          },
                          child: Container(
                            //width: 80,
                            padding: EdgeInsets.symmetric(horizontal: 13),
                            decoration: BoxDecoration(
                                color: !carListController.colorListFilter![index] == true
                                    ? Theme.of(context).backgroundColor
                                    : Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.4),width: 1)
                            ),
                            child: Center(
                              child: Text(
                                introController.colors[index].title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: !carListController.colorListFilter![index] == true
                                        ? Theme.of(context).dividerColor
                                        : Theme.of(context).backgroundColor ,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),),
                            ),
                          ),
                        );
                      }),
                      SizedBox(width: 8,),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _priceFilterMenu(context){
    return Obx((){
      return Container(
        child: Row(
          children: [
            const SizedBox(width: 15,),
            Container(
              child: Text('0',style: Theme.of(context).textTheme.headline3,),
            ),
            Expanded(
              child: Slider(
                value: carListController.myValue!.value,
                min: 0,
                max: carListController.max!.value,
                divisions: 50,
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: Theme.of(context).primaryColor.withOpacity(0.2),
                label: carListController.myValue!.value.round().toString() + ' AED',
                onChanged: (value){
                  setState(() {
                    carListController.myValue!.value = value;
                  });
                },
              ),
            ),
            Container(
              child: Text(carListController.max!.value.round().toString() + ' AED',style: Theme.of(context).textTheme.headline3,),
            ),
            const SizedBox(width: 15,),
          ],
        )
      );
    });
  }

  _sortInterface(context){
    return AnimatedContainer(
      width: MediaQuery.of(context).size.width,
      height: carListController.checkSortOpen.value ? MediaQuery.of(context).size.height  * 0.1 + 100 : 10,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      duration: Duration(milliseconds: 800),
      curve: Curves.fastOutSlowIn,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height  * 0.1,),
            Column(
              children: [
                GestureDetector(
                  onTap: (){
                    carListController.selectSortType(0);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 40,
                    decoration: BoxDecoration(
                      color: carListController.sortFilter.value == "ASC"
                          ? Colors.grey.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        App_Localization.of(context).translate('price_low_to_high'),
                        style: TextStyle(
                            color: carListController.sortFilter.value == 'ASC'
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).dividerColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                GestureDetector(
                  onTap: (){
                    carListController.selectSortType(1);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 40,
                    decoration: BoxDecoration(
                      color:carListController.sortFilter.value != "ASC"
                          ? Colors.grey.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        App_Localization.of(context).translate('price_high_to_low'),
                        style: TextStyle(
                            color: carListController.sortFilter.value != 'ASC'
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).dividerColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _showContactsList(context){
    return GestureDetector(
      onTap: (){
        carListController.openContactList.value = false;
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Color(0XFF202428).withOpacity(0.7),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.65,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: carListController.loadingContact.value
                      ? CircularProgressIndicator()
                      : carListController.companyContactsList.isEmpty
                    ? Text('')
                      : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: carListController.companyContactsList.length,
                      itemBuilder: (context, index){
                        return GestureDetector(
                          onTap: ()async{
                            if(carListController.bookOnWhatsappCheck!.value){
                              await carListController.bookOnWhatsapp(context, index);
                              carListController.trackerRecord(index);
                            }else{
                              carListController.bookOnPhone(index);
                              carListController.trackerRecord(index);
                            }
                          },
                          child: Container(
                              padding: const EdgeInsets.only(bottom: 25),
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Row(
                                    children: [
                                      Global.lang_code == 'en' ? SizedBox(width:  MediaQuery.of(context).size.width * 0.04) : Text(''),
                                      Container(
                                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.17),
                                        width: MediaQuery.of(context).size.width * 0.60,
                                        height: 70,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor,
                                            borderRadius: BorderRadius.circular(25)
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: Global.lang_code == 'en' ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              carListController.companyContactsList[index].name,
                                              maxLines: 2,
                                              style: Theme.of(context).textTheme.headline3,
                                            ),
                                            Text(
                                              carListController.companyContactsList[index].languages,
                                              maxLines: 2,
                                              style: Theme.of(context).textTheme.headline3,
                                            )
                                          ],
                                        ),
                                      ),
                                      Global.lang_code == 'en' ? Text('') : SizedBox(width:  MediaQuery.of(context).size.width * 0.04),
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(width: 1,color: Theme.of(context).backgroundColor.withOpacity(0.3)),
                                        image: DecorationImage(
                                            image: NetworkImage(Api.url + 'uploads/' + carListController.companyContactsList[index].image),
                                            fit: BoxFit.cover
                                        )
                                    ),
                                    width: MediaQuery.of(context).size.width * 0.2,
                                    height: 85,
                                  ),
                                ],
                              )
                          ),
                        );
                      },
                  ),
                )
              ),
            )
          ],
        ),
      ),
    );
  }

  _floatButton(context){
    return  SpeedDial(
      spaceBetweenChildren: 10,
      closeManually: false,
      activeIcon: Icons.close,
      icon: Icons.add,
      backgroundColor: Theme.of(context).primaryColor,
      overlayColor: Theme.of(context).backgroundColor.withOpacity(0.2),
      openCloseDial: carListController.isDialOpen,
      children: [
        SpeedDialChild(
          onTap: (){
            Get.to(()=>AddPeople());
          },
          backgroundColor: App.primary,
          labelBackgroundColor: Theme.of(context).backgroundColor,
          child: Icon(Icons.people,color: Colors.white,),
          label:  'Add people',
         labelWidget: Global.lang_code == 'en' ? _floatButtonText('Add people') : null,
          labelStyle: Theme.of(context).textTheme.headline3,
        ),
        SpeedDialChild(
          onTap: (){
            Get.to(()=>AddCar());
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.directions_car,color: Colors.white,),
         labelWidget:  Global.lang_code == 'en' ? _floatButtonText('Add car') : null,
          labelStyle: Theme.of(context).textTheme.headline3,
          labelBackgroundColor: Theme.of(context).backgroundColor,
        ),
      ],
    );
  }

  _floatButtonText(sentence){
    return Container(
      width: 90,
      height: 30,
      child: Center(
        child: Text(
            sentence,
          style: TextStyle(color: Colors.black,fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).dividerColor.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
    );
  }


}


