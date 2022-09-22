import 'package:crc_version_1/app_localization.dart';
import 'package:crc_version_1/controller/all_orders_controller.dart';
import 'package:crc_version_1/helper/app.dart';
import 'package:crc_version_1/widget/background_page.dart';
import 'package:crc_version_1/widget/logo_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AllOrders extends StatefulWidget {

  String rentType;
  AllOrders(this.rentType);

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  AllOrdersController allOrdersController  = Get.put(AllOrdersController());



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
              Column(
                children: [
                  _header(context),
                  _carList()
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
                color: allOrdersController.rentType.value == 'in' ? App.primary : App.greySettingPage,
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
                    Text(App_Localization.of(context).translate('rent_in'))
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
                color: allOrdersController.rentType.value == 'out' ? App.primary : App.greySettingPage,
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
                      Text(App_Localization.of(context).translate('rent_out'))
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
          color: App.greySettingPage,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],

      ),
      child: Row(
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
                color:  allOrdersController.rentStatus.value == 2 ? App.primary : App.greySettingPage,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text(
                  App_Localization.of(context).translate('all'),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white
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
                color:  allOrdersController.rentStatus.value == 1 ? App.primary : App.greySettingPage,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text(
                  App_Localization.of(context).translate('accepted'),
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white
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
                color:  allOrdersController.rentStatus.value == 0 ? App.primary : App.greySettingPage,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text(
                  App_Localization.of(context).translate('pending'),
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white
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
                color:  allOrdersController.rentStatus.value == -1 ? App.primary : App.greySettingPage,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text(
                  App_Localization.of(context).translate('rejected'),
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  _carList(){
    return Flexible(
      flex: 3,
      child: Container(
        width: Get.width * 0.9,
        padding: EdgeInsets.only(top: 20),
        child: ListView.builder(
          itemCount: 30,
          itemBuilder: (BuildContext context, index){
            return Container(
              height: 30,
           //   color: Colors.black,
             // margin: EdgeInsets.symmetric(vertical: 20),
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
