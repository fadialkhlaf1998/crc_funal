import 'dart:io';
import 'package:crc_version_1/app_localization.dart';
import 'package:crc_version_1/controller/intro_controller.dart';
import 'package:crc_version_1/controller/my_car_list_controller.dart';
import 'package:crc_version_1/helper/api.dart';
import 'package:crc_version_1/helper/app.dart';
import 'package:crc_version_1/helper/global.dart';
import 'package:crc_version_1/model/intro.dart';
import 'package:crc_version_1/view/my_car_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditCarController extends GetxController{

  IntroController introController = Get.find();
  MyCarListController myCarListController = Get.find();

  RxString? brand;
  RxString? model;
  RxString? year;
  RxString? color;
  RxString? price;
  RxString? pricePerMonth;
  RxString? carId;
  RxString? modelId;
  RxString? brandId;
  RxString? available;
  RxString? location;
  RxInt? brandIndex;
  int companyId = -1;
  RxBool imagePage = false.obs;
  RxBool loading = false.obs;
  RxBool showChoose = false.obs;

  RxList<File> imageList = <File>[].obs;
  RxList<File> newImageList = <File>[].obs;

  List<String> emirates = ['Dubai','Abu Dhabi','Ajman','Dubai Eye','Ras Al Khaimah','Sharjah','Umm Al Quwain'];

  List<String> emiratesArabic = ['دبي','أبو ظبي','عجمان','عين دبي','رأس الخيمة','الشارقة','أم القويين'];

  List<String> emiratesPhoto = ['dubai.png', 'Abu_Dhabi.png', 'Ajman.png', 'Dubai_eye.png', 'Ras_Al_Khaimah.png', 'Sharjah.png','Umm_Al_Quwain.png'];
  RxList<bool> emiratesCheck =  List.filled(7, false).obs;

  RxList<Brands> brands = <Brands>[].obs;
  RxString? image;
  RxBool editPriceOpenList = false.obs;
  RxBool editPricePerMonthOpenList = false.obs;
  RxBool editLocationOpenList = false.obs;
  RxBool editImageList = false.obs;
  TextEditingController? editingController;
  TextEditingController? editingMonthlyRentController;
  final ImagePicker _picker = ImagePicker();


  @override
  void onInit() {
   brands = introController.brands.obs;
   brand = myCarListController.brand;
   model = myCarListController.model;
   year = myCarListController.year;
   color = myCarListController.color;
   price = myCarListController.price;
   pricePerMonth = myCarListController.pricePerMonth;
   carId = myCarListController.carId;
   brandId = myCarListController.brandId;
   modelId = myCarListController.modelId;
   available = myCarListController.available;
   editingController = TextEditingController(text: price!.value);
   editingMonthlyRentController = TextEditingController(text: pricePerMonth!.value);
   location = myCarListController.location;

   for(int  i = 0; i < myCarListController.carImages.length; i++){
     imageList.add(File(myCarListController.carImages[i].link));
   }

   for(int i = 0; i < emirates.length; i++){
     if(emirates[i] == location!.value){
       emiratesCheck[i] = true;
     }
   }

   for(int i = 0; i < brands.length; i++){
     if(brands[i].title == brand!.value){
       image = brands[i].image.obs;
     }
   }
  }


  editPrice(){
    editPriceOpenList.value = !editPriceOpenList.value;
  }

  editPricePerMonth(){
    editPricePerMonthOpenList.value = !editPricePerMonthOpenList.value;
  }

  editLocation(){
    editLocationOpenList.value = !editLocationOpenList.value;
  }

  getNewPrice(){
    price!.value = editingController!.text;
  }

  getNewPricePerMonth(){
    pricePerMonth!.value = editingMonthlyRentController!.text;
  }

  getNewLocation(index){
    if(Global.lang_code == 'en'){
      location!.value = emirates[index];
    }else{
      location!.value = emiratesArabic[index];
    }
    for(int i = 0; i < emiratesCheck.length; i++){
      emiratesCheck[i] = false;
    }
    emiratesCheck[index] = true;
  }

  removeImage(index){
    imageList.removeAt(index);
  }

  removeNewImage(index){
    newImageList.removeAt(index);
  }

  Future addImage(context)async{
      _picker.pickMultiImage().then((value){
        showChoose.value=false;
       if (value!.length > 8){
          App.info_msg(context, 'You can\'t upload more than 8 photos');
        }else if ((value.length + imageList.length + newImageList.length) > 8){
          App.info_msg(context, 'You can\'t upload more than 8 photos');
        }else{
          for(int i = 0; i<value.length; i++){
            newImageList.add(File(value[i].path));
          }
        }
      });
    }
  Future addCamera(context)async{
    _picker.pickImage(source: ImageSource.camera).then((value){
      showChoose.value=false;
      if (value==null){
        App.info_msg(context, 'some thing went wrong');
      }else{
        newImageList.add(File(value.path));
      }
    });
  }
  saveInfo(context){
     if(imagePage.value == true){
       imagePage.value = false;
     }else{
       loading.value = true;
       Api.updateCarInfo(
           brand!.value,
           brandId!.value,
           model!.value,
           modelId!.value,
           year!.value,
           color!.value,
           location!.value,
           imageList,
           newImageList,
           editingController!.text.toString(),
           Global.company_id.toDouble(),
           carId!.value,
           available!.value,
           editingMonthlyRentController!.text.toString()
       ).then((value){
             if(value == true){
               print('Update successfully');
               loading.value = false;
               Get.back();
               myCarListController.getCarList(Global.company_id);
             }else{
               print('Error Update');
               loading.value = false;
               App.error_msg(context, App_Localization.of(context).translate('something_went_wrong'));
             }
           });
     }

    }

  goBack(){
    if(imagePage.value == true){
      imagePage.value = false;
    }else{
      editLocationOpenList.value = false;
      editPriceOpenList.value = false;
      Get.back();
    }
  }


}