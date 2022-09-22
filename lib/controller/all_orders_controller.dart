

import 'package:crc_version_1/app_localization.dart';
import 'package:crc_version_1/helper/api.dart';
import 'package:crc_version_1/helper/app.dart';
import 'package:crc_version_1/helper/global.dart';
import 'package:crc_version_1/view/no_internet.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AllOrdersController extends GetxController{

  RxString rentType = ''.obs;
  RxInt rentStatus = 2.obs;
  RxBool loading = false.obs;

  refreshData(){
    Global.company!.myOrders.all.clear();
    Global.company!.myOrders.all.addAll(Global.company!.myOrders.accepted);
    Global.company!.myOrders.all.addAll(Global.company!.myOrders.rejected);
    Global.company!.myOrders.all.addAll(Global.company!.myOrders.pending);

    Global.company!.customerOrders.all.clear();
    Global.company!.customerOrders.all.addAll(Global.company!.customerOrders.accepted);
    Global.company!.customerOrders.all.addAll(Global.company!.customerOrders.rejected);
    Global.company!.customerOrders.all.addAll(Global.company!.customerOrders.pending);

  }

  updateState(BuildContext context,int state,int id)async{
    loading.value = true;
    bool internet = await Api.check_internet();
    if(internet){
      bool succ = await Api.orderState(state,id);
      if(succ){
        App.sucss_msg(context, App_Localization.of(context).translate('order_state_changes_successfully'));
        Global.company = await Api.login(Global.company!.username, Global.company!.password);
        loading.value = false;
      }else{
        loading.value = false;
        App.error_msg(context, App_Localization.of(context).translate('something_went_wrong'));
      }
    }else{
      Get.to(()=>NoInternet())!.then((value) {
        updateState(context,state,id);
      });
    }
  }

}