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
    return Flexible(
      flex: 1,
      child: Container(
        width: Get.width,
        height: Get.height * 0.25,
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
      width: Get.width,
      height: 50,
      child: Row(
        children: [
          GestureDetector(
            onTap: (){
              allOrdersController.rentType.value = 'in';
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              width: Get.width * 0.5,
              height: 50,
              decoration: BoxDecoration(
                color: allOrdersController.rentType.value == 'in' ? App.primary :  MyTheme.isDarkTheme.value?App.greySettingPage:Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
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
                    Icon(Icons.car_crash),
                    const SizedBox(width: 5),
                    Text(App_Localization.of(context).translate('rent_in'),style: TextStyle(color:  MyTheme.isDarkTheme.value?Colors.white:Colors.black),)
                  ],
                ),
              )
            ),
          ),
          GestureDetector(
            onTap: (){
              allOrdersController.rentType.value = 'out';
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              width: Get.width * 0.5,
              height: 50,
              decoration: BoxDecoration(
                color: allOrdersController.rentType.value == 'out' ? App.primary : MyTheme.isDarkTheme.value? App.greySettingPage:Colors.white,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25),
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
                      Icon(Icons.car_crash),
                      const SizedBox(width: 5),
                      Text(App_Localization.of(context).translate('rent_out'),style: TextStyle(color:  MyTheme.isDarkTheme.value?Colors.white:Colors.black))
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
      flex: 3,
      child: Container(
        width: Get.width * 0.9,
        padding: EdgeInsets.only(top: 20),
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
                                        Text(list[index].total.toStringAsFixed(2)+" "+App_Localization.of(context).translate("aed"),style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontWeight: FontWeight.normal,),maxLines: 1,),
                                        Row(
                                          children: [
                                            Text(App_Localization.of(context).translate("from")+": ",style: TextStyle(color: App.primary,fontWeight: FontWeight.bold,),maxLines: 1,),
                                            Text(getFormate(list[index].from),style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontWeight: FontWeight.normal,fontSize: 12),maxLines: 1,),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(App_Localization.of(context).translate("to")+": ",style: TextStyle(color: App.primary,fontWeight: FontWeight.bold,),maxLines: 1,),
                                            Text(getFormate(list[index].from),style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontWeight: FontWeight.normal,fontSize: 12),maxLines: 1,),
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
                                Text(App_Localization.of(context).translate("in_review"),style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontWeight: FontWeight.normal,fontSize: 11,),maxLines: 1,),
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
    );
  }
  _carListIn(List<Accepted> list){
    return Flexible(
      flex: 3,
      child: Container(
        width: Get.width * 0.9,
        padding: EdgeInsets.only(top: 20),
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
                                        height: 40,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
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

                                            Column(
                                              children: [
                                                Icon(Icons.check_circle,color: Colors.green,size: 18,),
                                                SizedBox(height: 2.7,),
                                                Text(App_Localization.of(context).translate("accept"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 11,),maxLines: 1,),
                                              ],
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
                                        Text(list[index].total.toStringAsFixed(2)+" "+App_Localization.of(context).translate("aed"),style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontWeight: FontWeight.normal,),maxLines: 1,),
                                        Row(
                                          children: [
                                            Text(App_Localization.of(context).translate("from")+": ",style: TextStyle(color: App.primary,fontWeight: FontWeight.bold,),maxLines: 1,),
                                            Text(getFormate(list[index].from),style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontWeight: FontWeight.normal,fontSize: 12),maxLines: 1,),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(App_Localization.of(context).translate("to")+": ",style: TextStyle(color: App.primary,fontWeight: FontWeight.bold,),maxLines: 1,),
                                            Text(getFormate(list[index].from),style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontWeight: FontWeight.normal,fontSize: 12),maxLines: 1,),
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
    );
  }

  _carCard(){
    return Container(

    );
  }

}
