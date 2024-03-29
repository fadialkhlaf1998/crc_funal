import 'dart:ui';

import 'package:crc_version_1/app_localization.dart';
import 'package:crc_version_1/controller/all_orders_controller.dart';
import 'package:crc_version_1/helper/api.dart';
import 'package:crc_version_1/helper/app.dart';
import 'package:crc_version_1/helper/global.dart';
import 'package:crc_version_1/helper/myTheme.dart';
import 'package:crc_version_1/model/company.dart';
import 'package:crc_version_1/widget/background_page.dart';
import 'package:crc_version_1/widget/logo_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AllOrders extends StatefulWidget {

  String rentType;
  AllOrders(this.rentType);

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  AllOrdersController allOrdersController  = Get.put(AllOrdersController());

  _AllOrdersState(){
    {
      allOrdersController.refreshData();
    }
  }

  @override
  void initState() {
    super.initState();
    allOrdersController.rentType.value = widget.rentType;
  }

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
            children: [
              allOrdersController.fake.value?Center():Center(),
              BackgroundPage(),
              allOrdersController.loading.value
                  ?Container(
                width: Get.width,
                height: Get.height*0.8,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
                  :Column(
                children: [
                  _header(context),
                  allOrdersController.rentType.value=="in"
                      ?_carListIn(allOrdersController.rentStatus.value == 2?Global.company!.customerOrders.all:allOrdersController.rentStatus.value == 1?Global.company!.customerOrders.accepted:allOrdersController.rentStatus.value == 0?Global.company!.customerOrders.pending:Global.company!.customerOrders.rejected)
                      :_carListOut(allOrdersController.rentStatus.value == 2?Global.company!.myOrders.all:allOrdersController.rentStatus.value == 1?Global.company!.myOrders.accepted:allOrdersController.rentStatus.value == 0?Global.company!.myOrders.pending:Global.company!.myOrders.rejected)
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  _header(context){
    return Container(
      width: Get.width,
      height: Get.height * 0.05+50+50+55 ,
      // color:Colors.red,
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 80,
                child: IconButton(
                  onPressed: (){
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
              ),
              LogoContainer(width: 0.3, height: 0.05, logo: 'logo_white'),
              Container(
                width: 80,
                child: IconButton(
                  onPressed: (){
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back_ios,color: Colors.transparent,),
                ),
              ),
            ],
          ),
          _rentInOut(context),
          _rentStatus(),
        ],
      ),
    );
  }
  String getFormate(DateTime dateTime){
    final f = new DateFormat('yyyy-MM-dd hh:mm');
    return f.format(dateTime);
  }
  _rentInOut(context){
    return Container(
      margin: EdgeInsets.only(top: 15),
      width: Get.width * 0.9,
      height: 50,
      child: Row(
        children: [
          GestureDetector(
            onTap: (){
              allOrdersController.rentType.value = 'in';
              allOrdersController.rentStatus.value = 2;
            },
            child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
                width: Get.width * 0.45,
                height: 50,
                decoration: BoxDecoration(
                  color: allOrdersController.rentType.value == 'in' ? App.primary :  MyTheme.isDarkTheme.value?App.greySettingPage:Colors.white,
                  borderRadius: Global.lang_code == 'en'
                      ? BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    topLeft: Radius.circular(15),
                  )
                  : BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/rent-in.svg',
                        color: Theme.of(context).dividerColor,
                      ),
                      const SizedBox(width: 5),
                      Text(App_Localization.of(context).translate('customers_order'),style: TextStyle(color:  MyTheme.isDarkTheme.value?Colors.white:Colors.black),)
                    ],
                  ),
                )
            ),
          ),
          GestureDetector(
            onTap: (){
              allOrdersController.rentType.value = 'out';
              allOrdersController.rentStatus.value = 2;
            },
            child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
                width: Get.width * 0.45,
                height: 50,
                decoration: BoxDecoration(
                  color: allOrdersController.rentType.value == 'out' ? App.primary : MyTheme.isDarkTheme.value? App.greySettingPage:Colors.white,
                  borderRadius: Global.lang_code == 'en'
                      ? BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    topRight: Radius.circular(15),
                  )
                  : BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    topLeft: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon(Icons.car_crash),
                      SvgPicture.asset(
                          'assets/icons/rent-out.svg',
                        color: Theme.of(context).dividerColor,
                      ),
                      const SizedBox(width: 5),
                      Text(App_Localization.of(context).translate('my_order'),style: TextStyle(color:  MyTheme.isDarkTheme.value?Colors.white:Colors.black))
                    ],
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
  _rentStatus(){
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: Get.width * 0.9,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: MyTheme.isDarkTheme.value? App.greySettingPage:Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],

      ),
      child: allOrdersController.rentType.value=="in"?
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
              allOrdersController.rentStatus.value = 2;
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 400),
              curve: Curves.fastOutSlowIn,
              width: Get.width * 0.22,
              height: 50,
              decoration: BoxDecoration(
                  color:  allOrdersController.rentStatus.value == 2 ? App.primary : MyTheme.isDarkTheme.value? App.greySettingPage:Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text(
                  App_Localization.of(context).translate('all'),
                  style: TextStyle(
                      fontSize: 14,
                      color: MyTheme.isDarkTheme.value? Colors.white:App.greySettingPage
                  ),
                ),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 400),
            child: (allOrdersController.rentStatus.value == 2 || allOrdersController.rentStatus.value == 1 ) ? Text('') : VerticalDivider(width: 0,thickness: 1,indent: 5,endIndent: 5,),
          ),
          GestureDetector(
            onTap: (){
              allOrdersController.rentStatus.value = 1;
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              width: Get.width * 0.22,
              height: 50,
              decoration: BoxDecoration(
                  color:  allOrdersController.rentStatus.value == 1 ? App.primary : MyTheme.isDarkTheme.value? App.greySettingPage:Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text(
                  App_Localization.of(context).translate('accepted'),
                  style: TextStyle(
                      fontSize: 14,
                      color: MyTheme.isDarkTheme.value? Colors.white:App.greySettingPage
                  ),
                ),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 400),
            child: (allOrdersController.rentStatus.value == 1 || allOrdersController.rentStatus.value == 0 ) ? Text('') : VerticalDivider(width: 0,thickness: 1,indent: 5,endIndent: 5,),
          ),
          GestureDetector(
            onTap: (){
              allOrdersController.rentStatus.value = 0;
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              width: Get.width * 0.22,
              height: 50,
              decoration: BoxDecoration(
                  color:  allOrdersController.rentStatus.value == 0 ? App.primary : MyTheme.isDarkTheme.value? App.greySettingPage:Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text(
                  App_Localization.of(context).translate('pending'),
                  style: TextStyle(
                      fontSize: 14,
                      color: MyTheme.isDarkTheme.value? Colors.white:App.greySettingPage
                  ),
                ),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 400),
            child: (allOrdersController.rentStatus.value == 0 || allOrdersController.rentStatus.value == -1 ) ? Text('') : VerticalDivider(width: 0,thickness: 1,indent: 5,endIndent: 5,),
          ),
          GestureDetector(
            onTap: (){
              allOrdersController.rentStatus.value = -1;
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              width: Get.width * 0.22,
              height: 50,
              decoration: BoxDecoration(
                  color:  allOrdersController.rentStatus.value == -1 ? App.primary : MyTheme.isDarkTheme.value? App.greySettingPage:Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text(
                  App_Localization.of(context).translate('rejected'),
                  style: TextStyle(
                      fontSize: 14,
                      color: MyTheme.isDarkTheme.value? Colors.white:App.greySettingPage
                  ),
                ),
              ),
            ),
          )
        ],
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
              allOrdersController.rentStatus.value = 2;
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 400),
              curve: Curves.fastOutSlowIn,
              width: Get.width * 0.22,
              height: 50,
              decoration: BoxDecoration(
                  color:  allOrdersController.rentStatus.value == 2 ? App.primary : MyTheme.isDarkTheme.value? App.greySettingPage:Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text(
                  App_Localization.of(context).translate('all'),
                  style: TextStyle(
                      fontSize: 14,
                      color: MyTheme.isDarkTheme.value? Colors.white:App.greySettingPage
                  ),
                ),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 400),
            child: (allOrdersController.rentStatus.value == 2 || allOrdersController.rentStatus.value == 1 ) ? Text('') : VerticalDivider(width: 0,thickness: 1,indent: 5,endIndent: 5,),
          ),
          GestureDetector(
            onTap: (){
              allOrdersController.rentStatus.value = 1;
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              width: Get.width * 0.22,
              height: 50,
              decoration: BoxDecoration(
                  color:  allOrdersController.rentStatus.value == 1 ? App.primary : MyTheme.isDarkTheme.value? App.greySettingPage:Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text(
                  App_Localization.of(context).translate('accepted'),
                  style: TextStyle(
                      fontSize: 14,
                      color: MyTheme.isDarkTheme.value? Colors.white:App.greySettingPage
                  ),
                ),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 400),
            child: (allOrdersController.rentStatus.value == 1 || allOrdersController.rentStatus.value == 0 ) ? Text('') : VerticalDivider(width: 0,thickness: 1,indent: 5,endIndent: 5,),
          ),
          GestureDetector(
            onTap: (){
              allOrdersController.rentStatus.value = 0;
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              width: Get.width * 0.22,
              height: 50,
              decoration: BoxDecoration(
                  color:  allOrdersController.rentStatus.value == 0 ? App.primary : MyTheme.isDarkTheme.value? App.greySettingPage:Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text(
                  App_Localization.of(context).translate('in_review'),
                  style: TextStyle(
                      fontSize: 14,
                      color: MyTheme.isDarkTheme.value? Colors.white:App.greySettingPage
                  ),
                ),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 400),
            child: (allOrdersController.rentStatus.value == 0 || allOrdersController.rentStatus.value == -1 ) ? Text('') : VerticalDivider(width: 0,thickness: 1,indent: 5,endIndent: 5,),
          ),
          GestureDetector(
            onTap: (){
              allOrdersController.rentStatus.value = -1;
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              width: Get.width * 0.22,
              height: 50,
              decoration: BoxDecoration(
                  color:  allOrdersController.rentStatus.value == -1 ? App.primary : MyTheme.isDarkTheme.value? App.greySettingPage:Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text(
                  App_Localization.of(context).translate('rejected'),
                  style: TextStyle(
                      fontSize: 14,
                      color: MyTheme.isDarkTheme.value? Colors.white:App.greySettingPage
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _carListOut(List<Accepted> list){
    return Flexible(
      flex: 7,
      child: Container(
        width: Get.width * 0.9,
        padding: EdgeInsets.only(top: 20),
        child: RefreshIndicator(
          onRefresh: ()async{
            Global.company = await Api.login(Global.loginInfo!.email, Global.loginInfo!.pass);
            allOrdersController.refreshData();
            allOrdersController.fake.value = !allOrdersController.fake.value;
          },
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, index){
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Container(
                  width: Get.width * 0.9,
                  height: Get.width * 0.9/2.3,
                  // color: Colors.black,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            margin: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                image: DecorationImage(
                                    image: NetworkImage(Api.imageUrl+list[index].toCompnayImage),
                                    fit: BoxFit.contain
                                )
                            ),
                          ),
                          SizedBox(width: 10,),
                          Text(list[index].toCompnayTitle,style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black),),
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            width: Get.width * 0.9,
                            height: Get.width * 0.9/2.3 - 50,
                            decoration: BoxDecoration(
                              color: MyTheme.isDarkTheme.value?App.greySettingPage:Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex:1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: Global.lang_code == "en"?BorderRadius.only(bottomLeft: Radius.circular(10),topLeft: Radius.circular(10)):BorderRadius.only(bottomRight: Radius.circular(10),topRight: Radius.circular(10)),
                                        image: DecorationImage(
                                            image: NetworkImage(Api.imageUrl+list[index].image),
                                            fit: BoxFit.cover
                                        )
                                    ),

                                  ),
                                ),
                                Expanded(
                                  flex:2,
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(list[index].title,style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontWeight: FontWeight.bold,),maxLines: 1,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(list[index].total.toStringAsFixed(2)+" "+App_Localization.of(context).translate("aed"),style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontWeight: FontWeight.normal,),maxLines: 1,),
                                              list[index].state == 1 && list[index].current.difference(list[index].logtime).inDays.abs() >=3
                                                  ?list[index].review_count == 0?GestureDetector(
                                                onTap: (){
                                                  _showReviewDialog(list[index].fromCompnay,list[index].toCompany,list[index].carId,list[index].id,index);
                                                },
                                                child: Container(
                                                padding: EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        // App.primary_gradient,
                                                        App.primary,
                                                        App.primary,
                                                      ],
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter
                                                    )
                                                ),
                                                child: Center(
                                                    child:Text(App_Localization.of(context).translate("review"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,),maxLines: 1,),
                                                ),
                                              ),
                                                  ):Container(
                                                padding: EdgeInsets.all(3),

                                                child: Center(
                                                  child:Text(App_Localization.of(context).translate("reviewed"),style: TextStyle(color: App.primary,fontWeight: FontWeight.normal,),maxLines: 1,),
                                                ),
                                              ):Center()
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(App_Localization.of(context).translate("from")+": ",style: TextStyle(color: App.primary,fontWeight: FontWeight.bold,),maxLines: 1,),
                                              Text(getFormate(list[index].from),style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontWeight: FontWeight.normal,fontSize: 12),maxLines: 1,),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(App_Localization.of(context).translate("to")+": ",style: TextStyle(color: App.primary,fontWeight: FontWeight.bold,),maxLines: 1,),
                                              Text(getFormate(list[index].to),style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontWeight: FontWeight.normal,fontSize: 12),maxLines: 1,),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                              bottom: 7,
                              right: Global.lang_code=="en"?10:null,
                              left: Global.lang_code=="ar"?10:null,
                              child: list[index].state == -1
                                  ?Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 8,
                                    child: Icon(Icons.close,color: Colors.white,size: 14,),
                                  ),
                                  SizedBox(width: 5,),
                                  Text(App_Localization.of(context).translate("rejected"),style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontWeight: FontWeight.normal,fontSize: 11,),maxLines: 1,),
                                ],
                              )
                                  :list[index].state == 0?Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.orange,
                                    radius: 8,
                                    child: Icon(Icons.history_toggle_off_sharp,color: Colors.white,size: 14,),
                                  ),
                                  SizedBox(width: 5,),
                                  Text(App_Localization.of(context).translate("in_review"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 11,),maxLines: 1,),
                                ],
                              ):Row(
                                children: [
                                  Icon(Icons.check_circle,color: Colors.green,size: 18,),
                                  SizedBox(width: 5,),
                                  Text(App_Localization.of(context).translate("accepted"),style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontWeight: FontWeight.normal,fontSize: 11,),maxLines: 1,),
                                ],
                              )
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  _carListIn(List<Accepted> list){
    return Flexible(
      flex: 7,
      child: Container(
        width: Get.width * 0.9,
        padding: EdgeInsets.only(top: 20),

        child: RefreshIndicator(
          onRefresh: ()async{
            Global.company = await Api.login(Global.loginInfo!.email, Global.loginInfo!.pass);
            allOrdersController.refreshData();
            allOrdersController.fake.value = !allOrdersController.fake.value;
          },
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, index){
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Container(
                  width: Get.width * 0.9,
                  height: Get.width * 0.9/2.3,
                  // color: Colors.black,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            margin: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                image: DecorationImage(
                                    image: NetworkImage(Api.imageUrl+list[index].fromCompnayImage),
                                    fit: BoxFit.contain
                                )
                            ),
                          ),
                          SizedBox(width: 10,),
                          Text(list[index].fromCompnayTitle,style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black),),
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            width: Get.width * 0.9,
                            height: Get.width * 0.9/2.3 - 50,
                            decoration: BoxDecoration(
                              color: MyTheme.isDarkTheme.value?App.greySettingPage:Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex:1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: Global.lang_code == "en"?BorderRadius.only(bottomLeft: Radius.circular(10),topLeft: Radius.circular(10)):BorderRadius.only(bottomRight: Radius.circular(10),topRight: Radius.circular(10)),
                                        image: DecorationImage(
                                            image: NetworkImage(Api.imageUrl+list[index].image),
                                            fit: BoxFit.cover
                                        )
                                    ),
                                    child: list[index].state == 0?Container(
                                      decoration: BoxDecoration(
                                        borderRadius: Global.lang_code == "en"?BorderRadius.only(bottomLeft: Radius.circular(10),topLeft: Radius.circular(10)):BorderRadius.only(bottomRight: Radius.circular(10),topRight: Radius.circular(10)),
                                        color: Colors.grey.withOpacity(0.5),
                                      ),
                                      child:Center(
                                        child:  Container(
                                          // height: 40,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: (){
                                                    allOrdersController.updateState(context,-1,list[index].id);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(

                                                        color: Colors.red.withOpacity(0.4),
                                                        borderRadius: Global.lang_code == "en"?
                                                        BorderRadius.only(bottomLeft: Radius.circular(10),topLeft: Radius.circular(10))
                                                            :BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10))
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundColor: Colors.red,
                                                          radius: 8,
                                                          child: Icon(Icons.close,color: Colors.white,size: 14,),
                                                        ),
                                                        SizedBox(height: 5,),
                                                        Text(App_Localization.of(context).translate("reject"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 11,),maxLines: 1,),


                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: (){
                                                    allOrdersController.updateState(context,1,list[index].id);
                                                  },
                                                  child: Container(
                                                    color: Colors.green.withOpacity(0.4),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(Icons.check_circle,color: Colors.green,size: 18,),
                                                        SizedBox(height: 2.7,),
                                                        Text(App_Localization.of(context).translate("accept"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 11,),maxLines: 1,),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ):Center(),
                                  ),
                                ),
                                Expanded(
                                  flex:2,
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(list[index].title,style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontWeight: FontWeight.bold,),maxLines: 1,),
                                          Text(list[index].total.toStringAsFixed(0)+" "+App_Localization.of(context).translate("aed")
                                            +(list[index].note.isEmpty?"":" | "+App_Localization.of(context).translate("offer")+" "+list[index].note+App_Localization.of(context).translate("aed"))
                                            ,style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontWeight: FontWeight.normal,),maxLines: 1,),
                                          Row(
                                            children: [
                                              Text(App_Localization.of(context).translate("from")+": ",style: TextStyle(color: App.primary,fontWeight: FontWeight.bold,),maxLines: 1,),
                                              Text(getFormate(list[index].from),style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontWeight: FontWeight.normal,fontSize: 12),maxLines: 1,),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(App_Localization.of(context).translate("to")+": ",style: TextStyle(color: App.primary,fontWeight: FontWeight.bold,),maxLines: 1,),
                                              Text(getFormate(list[index].to),style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontWeight: FontWeight.normal,fontSize: 12),maxLines: 1,),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                              bottom: 7,
                              right: Global.lang_code=="en"?10:null,
                              left: Global.lang_code=="ar"?10:null,
                              child: list[index].state == -1
                                  ?Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 8,
                                    child: Icon(Icons.close,color: Colors.white,size: 14,),
                                  ),
                                  SizedBox(width: 5,),
                                  Text(App_Localization.of(context).translate("rejected"),style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontWeight: FontWeight.normal,fontSize: 11,),maxLines: 1,),
                                ],
                              )
                                  :list[index].state == 0?Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.orange,
                                    radius: 8,
                                    child: Icon(Icons.history_toggle_off_sharp,color: Colors.white,size: 14,),
                                  ),
                                  SizedBox(width: 5,),
                                  Text(App_Localization.of(context).translate("pending"),style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontWeight: FontWeight.normal,fontSize: 11,),maxLines: 1,),
                                ],
                              ):Row(
                                children: [
                                  Icon(Icons.check_circle,color: Colors.green,size: 18,),
                                  SizedBox(width: 5,),
                                  Text(App_Localization.of(context).translate("accepted"),style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontWeight: FontWeight.normal,fontSize: 11,),maxLines: 1,),
                                ],
                              )
                          ),
                          // Positioned(
                          //     top: 7,
                          //     right: Global.lang_code=="en"?10:null,
                          //     left: Global.lang_code=="ar"?10:null,
                          //     child: list[index].note.isEmpty?Center():GestureDetector(
                          //         onTap: (){
                          //           showAlertDialog(context,list[index].fromCompnayTitle,list[index].note);
                          //         },
                          //         child: Icon(Icons.notifications_active_outlined,color: App.primary_gradient,))
                          // ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  showAlertDialog(BuildContext context,String company,String msg) {
// set up the button
    Widget cancelButton = TextButton(
      child: Text(App_Localization.of(context).translate("close"),
        style: TextStyle(color: App.grey),),
      onPressed: () {
        Get.back();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
          company + " " + App_Localization.of(context).translate("say")),
      content: Column(
        children: [
          Text(msg)
        ],
      ),
      actions: [
        cancelButton
      ],
    );
  }

    Future<void> _showReviewDialog(int fromCompanyId , int toCompanyId , int carId,int orderId,int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(App_Localization.of(context).translate("review"),style: TextStyle(color: Colors.white,fontSize: 20),),
          backgroundColor: App.greySettingPage,
          content: SingleChildScrollView(
            child: Obx(() => allOrdersController.reviewloading.value?
                Center(child: CircularProgressIndicator(),)
                :ListBody(
              children: <Widget>[
                Text(App_Localization.of(context).translate("we_need_review"),style: TextStyle(color: Colors.white,fontSize: 12),),
                SizedBox(height: 10,),
                TextField(
                    controller: allOrdersController.review,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: allOrdersController.reviewValidate.value?Colors.red:Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: allOrdersController.reviewValidate.value?Colors.red:Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: allOrdersController.reviewValidate.value?Colors.red:Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RatingBar.builder(
                      initialRating: allOrdersController.rate.value.toDouble(),
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                        allOrdersController.rate.value = rating.toInt();
                      },
                    )
                  ],
                )
              ],
            ),)
          ),
          actions: <Widget>[
            TextButton(
              child: Text(App_Localization.of(context).translate("close")),
              onPressed: () {
                allOrdersController.reviewValidate.value = false;
                allOrdersController.review.clear();
                allOrdersController.rate.value = 1;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(App_Localization.of(context).translate("send")),
              onPressed: () {
                allOrdersController.addReview(context,fromCompanyId, toCompanyId, carId,orderId,index);
              },
            ),

          ],
        );
      },
    );
  }
  _carCard(){
    return Container(

    );
  }

}
