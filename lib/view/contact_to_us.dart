import 'package:crc_version_1/controller/contact_us_controller.dart';
import 'package:crc_version_1/helper/api.dart';
import 'package:crc_version_1/helper/global.dart';
import 'package:crc_version_1/helper/myTheme.dart';
import 'package:crc_version_1/widget/logo_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ContactToUs extends StatelessWidget {

  ContactUsController contactUsController = Get.put(ContactUsController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            _body(context),
            _app_bar(context),
          ],
        ),
      ),
    );
  }


  _app_bar(context){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2), // changes position of shadow
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
                  Get.back();
                },
                icon: Icon(Icons.arrow_back_ios,size: 20,),
              )
          ),
          LogoContainer(width: 0.35, height: 0.07, logo: 'logo_orange'),
          const SizedBox(width: 40),
        ],
      ),
    );
  }


  _body(context){
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.width * 0.3,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(width: 1,color: Color(0XFF202428),),
              image:  DecorationImage(
                fit: BoxFit.contain,
                image: NetworkImage(Api.imageUrl+Global.companyImage.value.replaceAll("http://127.0.0.1:3004/", Api.url))
              )
            ),
          ),
          SizedBox(height: 7),
          Text('Vip RentalCar',style: Theme.of(context).textTheme.headline2),
          SizedBox(height: 80),
          Obx((){
            return GestureDetector(
              onTap: (){
                contactUsController.pressPhoneButton(context);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 350),
                width: contactUsController.phoneButton.value ? 60 :  MediaQuery.of(context).size.width * 0.6,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Color(0XFF202428).withOpacity(0.3),),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0XFF202428).withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(1, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 50),
                      child: contactUsController.phoneButton.value ?  CircularProgressIndicator(color: Colors.black,) :  Image.asset('assets/icons/phone.gif',height: 50,width: 45,),
                    ),

                    SizedBox(width: contactUsController.phoneButton.value ? 0 : 10 ),
                    AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: contactUsController.phoneButton.value ? 0 :  150,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text('+971 55 345 1555',style: TextStyle(color: Color(0XFF202428),fontSize: 15,fontWeight: FontWeight.bold)),
                        )
                    ),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: 20,),
          Obx((){
            return GestureDetector(
              onTap: (){
                contactUsController.pressWhatsAppButton(context);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 350),
                width: contactUsController.whatsappButton.value ? 60 :  MediaQuery.of(context).size.width * 0.6 ,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Color(0XFF202428).withOpacity(0.3),),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0XFF202428).withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(1, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 50),
                      child: contactUsController.whatsappButton.value ?  CircularProgressIndicator(color: Colors.black,) :  Image.asset('assets/icons/whatsapp.gif',height: 50,width: 45,),
                    ),
                    SizedBox(width: contactUsController.whatsappButton.value ? 0 : 10 ),
                    AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: contactUsController.whatsappButton.value ? 0 :  150,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text('+971 55 345 1555',style: TextStyle(color: Color(0XFF202428),fontSize: 15,fontWeight: FontWeight.bold)),
                        )
                    ),
                  ],
                ),
              ),
            );
          })
        ],
      )
    );
  }




}
