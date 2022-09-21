import 'dart:io';

import 'package:crc_version_1/controller/intro_controller.dart';
import 'package:crc_version_1/helper/api.dart';
import 'package:crc_version_1/helper/app.dart';
import 'package:crc_version_1/helper/global.dart';
import 'package:crc_version_1/model/car.dart';
import 'package:crc_version_1/model/person_for_company.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CarListController extends GetxController{

  IntroController introController = Get.find();
  RxList<PersonForCompany> companyContactsList = <PersonForCompany>[].obs;
  final controllerList = ScrollController();



  var brand="%".obs;
  var model="%".obs;
  var year="%".obs;
  var color="%".obs;
  var price="999999999999999".obs;
  var sort="ASC".obs;
  RxList<Car> myCars = <Car>[].obs;
  List<Object> myCompany = <Object>[].obs;
  RxBool loading = false.obs;
  RxBool checkFilterOpen = false.obs;
  RxBool checkSortOpen = false.obs;
  RxBool yearListOpen = false.obs;
  RxBool brandListOpen = false.obs;
  RxBool carModelListOpen = false.obs;
  RxBool colorListOpen = false.obs;
  RxList<int> yearModelList = List.filled(10, 0).obs;
  RxList<bool> yearModelListCheck = List.filled(10, false).obs;
  RxList<bool>? brandListCheck;
  RxList<bool>? modelListCheck;
  RxList<bool>? colorListFilter;
  RxDouble? myValue;
  RxInt? minLabel;
  RxInt? maxLabel;
  RxInt? divisionsLabel;
  RxInt selectedBrand = (-1).obs;
  RxDouble? max;
  RxBool contactInfo = false.obs;
  /// Filter Variable */
  RxString brandFilter = '%'.obs;
  RxString modelFilter = '%'.obs;
  RxString yearFilter = '%'.obs;
  RxString colorFilter = '%'.obs;
  RxString priceFilter = "9999999999999".obs;
  RxString sortFilter = 'ASC'.obs;
  RxBool loadingContact = false.obs;
  final isDialOpen = ValueNotifier(false);
  RxBool? bookOnWhatsappCheck;
  RxBool openContactList = false.obs;
  RxInt sortCheckValue = 0.obs;
  RxInt carIndex = 0.obs;


  @override
  void onInit() {
    super.onInit();
    max = 5000.0.obs;
    minLabel = 0.obs;
    myValue = 5000.0.obs;
    brandListCheck = List.filled(introController.brands.length, false).obs;
    colorListFilter = List.filled(introController.colors.length, false).obs;
    getCarsList(year.value,brand.value,model.value,color.value,price.value,sort.value);
  }

  getContactData(int id){
    loadingContact.value = true;
    Api.check_internet().then((internet){
      if(internet){
        companyContactsList.clear();
        Api.getCompanyContactInfo(id).then((value){
          companyContactsList.addAll(value);
          loadingContact.value = false;
        });
      }else{
        loadingContact.value = false;
      }
    });
  }

  updateCarList(){
      loading.value = true;
      Api.check_internet().then((value) async{
        if(value){
          myCars.clear();
          loading.value = true;
          await Api.filter('%', '%', '%', '%', '999999999999', 'ASC').then((value){
            myCars.addAll(value);
          });
          loading.value = false;
        }else{

        }
      });

  }

  fillYearList(){
    int year = DateTime.now().year + 1;
    for(int i = 0; i < 10; i++){
      yearModelList[i] = year;
      year --;
    }
  }

  getCarsList(String year, String brand,String model, String color, String price, String sort) async{
    Future.delayed(const Duration(milliseconds: 500),(){
      loading.value = true;
      Api.check_internet().then((value) async{
        if(value){
          myCars.clear();
          loading.value = true;
          await Api.filter(year, brand, model, color, price, sort).then((value){
            myCars.addAll(value);
          });
          loading.value = false;
        }else{

        }
      });
    });
  }

  update_data(){
    Api.check_internet().then((value) async{
      if(value){
        loading.value = true;
        print(brand.value);
        print(model.value);
        print(year.value);
        await Api.filter(year.value, brand.value, model.value, color.value, price.value, sort.value).then((value){
          print('**************');
          print(value.length);
          myCars.value=value;
        });
        loading.value = false;
      }else{

      }
    });
  }

  openFiler(){
    checkFilterOpen.value = !checkFilterOpen.value;
    if(checkSortOpen.value == true){
      checkSortOpen.value = false;
    }
  }

  openSort(){
    checkSortOpen.value = !checkSortOpen.value;
    if(checkFilterOpen.value == true){
      checkFilterOpen.value = false;
    }
  }

  openYearFilterList(){
    yearListOpen.value = !yearListOpen.value;
  }
  openBrandFilterList(){
    brandListOpen.value = !brandListOpen.value;
  }
  openCarModelFilterList(){
    carModelListOpen.value = !carModelListOpen.value;
  }
  openColorFilterList(){
    colorListOpen.value = !colorListOpen.value;
  }

  chooseYearFilter(index){
    if(yearModelListCheck[index] == true){
      yearModelListCheck[index] = false;
      yearFilter.value = '%';
    }else{
      for(int i = 0; i < yearModelList.length; i++){
        yearModelListCheck[i] = false;
      }
      yearModelListCheck[index] = true;
      yearFilter.value = yearModelList[index].toString();
    }

  }

  chooseBrandFilter(index){
    if(brandListCheck![index] == true){
      brandListCheck![index] = false;
      brandFilter.value = '%';
    }else{
      selectedBrand.value = index;
      modelListCheck = List.filled(introController.brands[index].models.length, false).obs;
      for(int i = 0; i < brandListCheck!.length; i++){
        brandListCheck![i] = false;
      }
      brandListCheck![index] = true;
      brandFilter.value = introController.brands[index].title;
      carModelListOpen.value = true;
    }

  }

  chooseModelFilter(index){
    if(modelListCheck![index] == true){
      modelListCheck![index] = false;
      modelFilter.value = '%';
    }else{
      for(int i = 0; i < modelListCheck!.length; i++){
        modelListCheck![i] = false;
      }
      modelListCheck![index] = true;
      modelFilter.value = introController.brands[selectedBrand.value].models[index].title;
    }

  }

  chooseColorFilter(index){
    if(colorListFilter![index] == true){
      colorListFilter![index] = false;
      colorFilter.value = '%';
    }else{
      for(int i = 0; i < colorListFilter!.length; i++){
        colorListFilter![i] = false;
      }
      colorListFilter![index] = true;
      colorFilter.value = introController.colors[index].title;    }
  }

  clearFilterValue(){
    brandFilter.value  = "%";
    modelFilter.value  = "%";
    yearFilter.value  = "%";
    colorFilter.value  = "%";
    brand.value = "%";
    model.value = "%";
    sortCheckValue.value = 0;
    priceFilter.value  = "99999999999";
    myValue!.value = 5000.0;
    sortFilter.value  = "ASC";
    brandListCheck = List.filled(introController.brands.length, false).obs;
    yearModelListCheck = List.filled(yearModelList.length, false).obs;
    colorListFilter = List.filled(introController.colors.length, false).obs;
    yearListOpen.value = false;
    brandListOpen.value = false;
    colorListOpen.value = false;
    checkFilterOpen.value = false;
    getCarsList(yearFilter.value, brandFilter.value, modelFilter.value, colorFilter.value, priceFilter.value, sortFilter.value);
  }

  getFilterResult(){
    checkFilterOpen.value = false;
    sortCheckValue.value = 0;
    getCarsList(yearFilter.value, brandFilter.value, modelFilter.value, colorFilter.value, myValue!.value.toString(), sortFilter.value);

  }

  selectSortType(value){
    if(sortFilter.value == 'ASC' && value == 1){
      sortFilter.value = 'DES';
      checkSortOpen.value = false;
      sortCheckValue.value = 0;
      if(brandFilter.value != '%' || modelFilter.value != '%'){
        getCarsList(yearFilter.value, brandFilter.value, modelFilter.value, colorFilter.value, myValue!.value.toString(), sortFilter.value);
      }else{
        getCarsList(yearFilter.value, brand.value, model.value, colorFilter.value, myValue!.value.toString(), sortFilter.value);
      }
    }else if(sortFilter.value != 'ASC' && value == 0){
      sortFilter.value = 'ASC';
      sortCheckValue.value = 1;
      checkSortOpen.value = false;
      if(brandFilter.value != '%' || modelFilter.value != '%'){
        getCarsList(yearFilter.value, brandFilter.value, modelFilter.value, colorFilter.value, myValue!.value.toString(), sortFilter.value);
      }else{
        getCarsList(yearFilter.value, brand.value, model.value, colorFilter.value, myValue!.value.toString(), sortFilter.value);
      }
    }
  }

  bookOnWhatsapp(context, index)async{
    String message = "Hi I Need Car ${myCars[carIndex.value].title} ${myCars[carIndex.value].year}";
    if (Platform.isAndroid){
      if(await canLaunch("https://wa.me/${companyContactsList[index].phone}/?text=${Uri.parse(message)}")){
        await launch("https://wa.me/${companyContactsList[index].phone}/?text=${Uri.parse(message)}");
      }else{
        App.error_msg(context, 'can\'t open Whatsapp');
      }
    }else if(Platform.isIOS){
      if(await canLaunch("https://api.whatsapp.com/send?phone=${companyContactsList[index].phone.toString()}=${Uri.parse(message)}")){
        await launch( "https://api.whatsapp.com/send?phone=${companyContactsList[index].phone.toString()}=${Uri.parse(message)}");
      }else{
        App.error_msg(context, 'can\'t open Whatsapp');
      }
    }
  }

  bookOnPhone(index)async{
    if(Platform.isAndroid){
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: companyContactsList[index].phone,
      );
      await launch(launchUri.toString());

    }else if (Platform.isIOS){
      launch("tel://${companyContactsList[index].phone}");
    }
  }

  trackerRecord(index){
    Api.check_internet().then((internet){
      if (internet){
        Api.tracker(Global.company_id.toString(), myCars[index].companyId.toString());
      }else{

      }
    });
  }

  // openBookList(index,id){
  //   Future.delayed(Duration(milliseconds: 500),(){
  //     Api.check_internet().then((internet){
  //       if(internet){
  //         Api.getCompanyContactInfo(id).then((value)async{
  //           if(value.isNotEmpty){
  //             companyContactsList.clear();
  //             companyContactsList.addAll(value);
  //           }else{
  //           }
  //         });
  //       }else{
  //       }
  //     });
  //   });
  //   myCars[index].bookOption.value = !myCars[index].bookOption.value;
  // }



}