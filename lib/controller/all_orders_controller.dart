

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
  RxInt rate = 1.obs;
  RxBool loading = false.obs;
  RxBool fake = false.obs;
  RxBool reviewValidate = false.obs;
  RxBool reviewloading = false.obs;
  TextEditingController review = TextEditingController();

  refreshData(){
    Global.company!.myOrders.all.clear();
    Global.company!.myOrders.all.addAll(Global.company!.myOrders.accepted);
    Global.company!.myOrders.all.addAll(Global.company!.myOrders.rejected);
    Global.company!.myOrders.all.addAll(Global.company!.myOrders.pending);

    Global.company!.customerOrders.all.clear();
    Global.company!.customerOrders.all.addAll(Global.company!.customerOrders.accepted);
    Global.company!.customerOrders.all.addAll(Global.company!.customerOrders.rejected);
    Global.company!.customerOrders.all.addAll(Global.company!.customerOrders.pending);
    rate.value = 1;
    review.clear();
    reviewValidate.value = false;
  }

  updateState(BuildContext context,int state,int id)async{
    loading.value = true;
    bool internet = await Api.check_internet();
    print('internet');
    print(internet);
    if(internet){
      bool succ = await Api.orderState(state,id);
      print("succ");
      print(succ);
      if(succ){

        Global.company = await Api.login(Global.loginInfo!.email, Global.loginInfo!.pass);
        print("Global.company!.id");
        print(Global.company!.id);
        // App.sucss_msg(context, App_Localization.of(context).translate('order_state_changes_successfully'));
        // Get.showSnackbar(GetSnackBar(backgroundColor: App.greySettingPage,title: App_Localization.of(context).translate("rent_in"),message: App_Localization.of(context).translate('order_state_changes_successfully'),));
        refreshData();
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

  addReview(BuildContext context,int from , int to , int car,int order_id,int index)async{
    // reviewValidate.value = true;
    reviewValidate.value = false;
    reviewloading.value = true;
    bool succ = await Api.addReview(review.text, rate.value,
        from, to, car, order_id);
    reviewloading.value = false;
    if(succ){
      App.sucss_msg(context, App_Localization.of(context).translate("thank_u_review"));
      Global.company!.myOrders.accepted[index].review_count = 1;
      loading.value = !loading.value;
      loading.value = !loading.value;
      refreshData();
      Get.back();
    }else{
      App.error_msg(context, App_Localization.of(context).translate("something_went_wrong"));
    }
  }

}