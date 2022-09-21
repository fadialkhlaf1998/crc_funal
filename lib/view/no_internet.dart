import 'package:crc_version_1/app_localization.dart';
import 'package:crc_version_1/helper/api.dart';
import 'package:crc_version_1/helper/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NoInternet extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage("assets/images/no_internet.png"),
            //   fit: BoxFit.cover
            // )

          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.2,),
              Icon(Icons.wifi_off,size: 100,color: Colors.white,),
              Column(
                children: [
                  Text("oops",style: App.textBlod(Colors.white, 32),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("no_internet",style: App.textNormal(Colors.white, 20),),
                  ),
                ],
              ),
              GestureDetector(
                onTap: (){
                  Api.check_internet().then((value) {
                    if(value){
                      Get.back();
                    }
                  });
                },
                // elevation: 2,
                // color: Colors.white,
                child:Text("reload",style: App.textBlod(App.primary, 16),),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.2,),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
            ],
          ),
        ),
      ),
    );
  }

}