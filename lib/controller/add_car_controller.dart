import 'dart:io';
import 'package:crc_version_1/app_localization.dart';
import 'package:crc_version_1/controller/home_controller.dart';
import 'package:crc_version_1/controller/intro_controller.dart';
import 'package:crc_version_1/helper/api.dart';
import 'package:crc_version_1/helper/app.dart';
import 'package:crc_version_1/helper/global.dart';
import 'package:crc_version_1/model/intro.dart';
import 'package:crc_version_1/view/my_car_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddCarController extends GetxController{

  IntroController introController = Get.find();

  RxInt currentStep = 0.obs;
  TextEditingController search = TextEditingController();
  TextEditingController searchModel = TextEditingController();
  TextEditingController carPrice = TextEditingController();
  TextEditingController carPricePerMonth = TextEditingController();
  RxList<bool>? selectBrandIndex;
  RxList<bool>? selectModelIndex;
  RxList<bool>? selectYearIndex;
  RxList<bool>? selectColorIndex;
  RxList<bool>? selectEmiratesIndex;
  RxInt brandIndex = 0.obs;
  RxInt modelIndex = 0.obs;
  RxDouble pricePerMonth = 0.0.obs;
  List<int> yearModelList = List.filled(10, 0).obs;
  List<String> emirates = ['Dubai', 'Abu Dhabi', 'Ajman', 'Dubai Eye', 'Ras Al Khaimah','Sharjah','Umm Al Quwain'];
  List<String> emiratesPhoto = ['dubai.png', 'Abu_Dhabi.png', 'Ajman.png', 'Dubai_eye.png', 'Ras_Al_Khaimah.png', 'Sharjah.png','Umm_Al_Quwain.png'];
  final ImagePicker _picker = ImagePicker();
  RxList<File> imageList = <File>[].obs;
  RxBool loadingUpload = false.obs;
  RxBool choosePhotoCheck = false.obs;
  RxBool showChoose = false.obs;

  /// Search Lists
  RxList<Brands> tempBrandsList = <Brands>[].obs;
  RxList<Models> tempModelsList = <Models>[].obs;

  /// Variable to send to the server */
  String? yearModelSelect;
  String? colorSelect;
  String? emiratesSelect;
  RxString? brand;
  RxString? model;
  int? brandId;
  int? modelId;
  double? companyId;

  @override
  void onInit() {
    super.onInit();
    tempBrandsList.addAll(introController.brands);

    selectYearIndex = List.filled(10, false).obs;
    selectColorIndex = List.filled(introController.colors.length, false).obs;
    selectEmiratesIndex = List.filled(emirates.length, false).obs;
    companyId = Global.company_id.toDouble();
  }

  selectBrand(index){
    for(int i = 0; i < tempBrandsList.length; i++) {
      tempBrandsList[i].selected.value = false;
    }
    tempBrandsList[index].selected.value = true;
    brand = tempBrandsList[index].title.obs;
    brandIndex.value = introController.brands.indexOf(tempBrandsList[index]);
  }

  selectModel(index){
    for(int i = 0; i < tempModelsList.length; i++) {
      tempModelsList[i].selected.value = false;
    }
    tempModelsList[index].selected.value = true;
    modelIndex.value = introController.brands[brandIndex.value].models.indexOf(tempModelsList[index]);
    model = introController.brands[brandIndex.value].models[modelIndex.value].title.obs;
    selectModelIndex![index] = true;
    ////////
    // for(int i = 0; i < selectModelIndex!.length; i++){
    //   selectModelIndex![i] = false;
    // }
    // selectModelIndex![index] = true;
    // modelIndex.value = index;
    // //modelId.value = model
  }

  fillYearList(){
    int year = DateTime.now().year + 1;
    for(int i = 0; i < 10; i++){
      yearModelList[i] = year;
      year --;
    }
  }

  selectYear(index){
    for(int i =0; i < selectYearIndex!.length; i++){
      selectYearIndex![i] = false;
    }
    selectYearIndex![index] = true;
    yearModelSelect = yearModelList[index].toString();
  }

  selectColor(index){
    for(int i = 0; i < selectColorIndex!.length; i++){
      selectColorIndex![i] = false;
    }
    selectColorIndex![index] = true;
    colorSelect = introController.colors[index].title;
  }

  selectEmirates(index){
    for(int i = 0; i < emirates.length; i++){
      selectEmiratesIndex![i] = false;
    }
    selectEmiratesIndex![index] = true;
    emiratesSelect = emirates[index];
  }

  Future selectImage(context)async{
    _picker.pickMultiImage().then((value){
      if ((value!.length + imageList.length) > 8 && value.isNotEmpty){
        App.info_msg(context, App_Localization.of(context).translate('you_can_not_upload_more_than_eight_photos'));
        int listLength = imageList.length;
        for(int i = 0; i < (8 - listLength); i++){
          print(i);
          imageList.add(File(value[i].path));
        }
      } else if (value.length > 8){
        App.info_msg(context, App_Localization.of(context).translate('you_can_not_upload_more_than_eight_photos'));        for(int i = 0; i < 8; i++){
          imageList.add(File(value[i].path));
        }
      }else{
        for(int i=0;i<value.length;i++){
          imageList.add(File(value[i].path));
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
        imageList.add(File(value.path));
      }
    });
  }

  deleteImageFromList(index){
    imageList.removeAt(index);
  }


  forwardStep(context){
      if(currentStep.value == 0){
        if(brand == null){
          App.info_msg(context, App_Localization.of(context).translate('you_should_select_brand'));
        }else{
          brand!.value = introController.brands[brandIndex.value].title;
          brandId = introController.brands[brandIndex.value].id;
          selectModelIndex = List.filled(introController.brands[brandIndex.value].models.length, false).obs;
          selectModelIndex![0] = true;
          tempModelsList = introController.brands[brandIndex.value].models.obs;
          currentStep.value +=1;
        }
      }
      else if(currentStep.value == 1){
        print(model);
      if(model == null){
          App.info_msg(context, App_Localization.of(context).translate('you_should_select_model'));
        }else{
          model = introController.brands[brandIndex.value].models[modelIndex.value].title.obs;
          modelId = introController.brands[brandIndex.value].models[modelIndex.value].id;
          fillYearList();
          currentStep.value +=1;
        }
      }
      else if(currentStep.value == 2){
        if(yearModelSelect == null){
          App.info_msg(context, App_Localization.of(context).translate('you_should_select_year'));
        }else{
          currentStep.value +=1;
        }
      }
      else if(currentStep.value == 3){
        if(colorSelect == null){
          App.info_msg(context, App_Localization.of(context).translate('you_should_select_color'));
        }else{
          currentStep.value +=1;
        }
      }
      // else if(currentStep.value == 4){
      //   if(emiratesSelect == null){
      //     App.info_msg(context, App_Localization.of(context).translate('you_should_select_emirates'));
      //   }else{
      //     currentStep.value += 1;
      //   }
      // }
      else if(currentStep.value == 4){
        if(imageList.length < 3){
          App.info_msg(context, App_Localization.of(context).translate('you_should_upload_three_photos'));
        }else{
          currentStep.value += 1;
        }
      }
      else if(currentStep.value == 5){
        if(carPrice.text.isEmpty){
          App.info_msg(context, App_Localization.of(context).translate('you_must_enter_the_price'));
        }else{
          /** Upload Information*/
          currentStep.value += 1;
          print(brandIndex.value);
          print('--------------------');
        // introController.brands[brandIndex.value].selected.value = false;
        //  tempModelsList[modelIndex.value].selected.value = false;
          FocusManager.instance.primaryFocus?.unfocus();
          loadingUpload.value = true;
          Api.addCar(brand!.value,brandId.toString(), model!.value, modelId.toString(), yearModelSelect!,colorSelect!,'Dubai',imageList,carPrice.text,companyId!, carPricePerMonth.text).then((value){
            loadingUpload.value = false;
            Get.back();
            // Get.off(()=>MyCarList());
          });
        }
      }
    }

  backwardStep(){
    if(currentStep.value == 0){
      if(tempBrandsList.isEmpty){
        Get.back();
      }else{
        tempBrandsList[brandIndex.value].selected.value = false;
        Get.back();
      }
      if(model != null){
        tempModelsList[modelIndex.value].selected.value = false;
        model = null;
      }
    }else{
      currentStep.value -=1;
    }
  }

  filterSearchBrand(query) {
    for (int i = 0; i < tempBrandsList.length; i++) {
      tempBrandsList[i].selected.value = false;
    }
    List<Brands> dummySearchList = <Brands>[];
    dummySearchList.addAll(introController.brands);
    if (query.isNotEmpty) {
      List<Brands> dummyListData = <Brands>[];
      for (var brand in dummySearchList) {
        if (brand.title.toLowerCase().contains(query)) {
          dummyListData.add(brand);
        }
      }
      tempBrandsList.clear();
      tempBrandsList.addAll(dummyListData);
      print(tempBrandsList.length);

      return;
    } else {
      tempBrandsList.clear();
      tempBrandsList.addAll(introController.brands);
    }
  }

  filterModelSearch(query){
    for (int i = 0; i < tempModelsList.length; i++) {
      tempModelsList[i].selected.value = false;
    }
    List<Models> dummySearchList = <Models>[];
    dummySearchList.addAll(introController.brands[brandIndex.value].models);
    if (query.isNotEmpty) {
      List<Models> dummyListData = <Models>[];
      for (var model in dummySearchList) {
        if (model.title.toLowerCase().contains(query)) {
          dummyListData.add(model);
        }
      }
      tempModelsList.clear();
      tempModelsList.addAll(dummyListData);
      print(tempBrandsList.length);

      return;
    } else {
      tempModelsList.clear();
      tempModelsList.addAll(introController.brands[brandIndex.value].models);
    }
  }

  chooseOption(){
    choosePhotoCheck.value = !choosePhotoCheck.value;
  }

  selectPhotosFromCamera()async{
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    imageList.add(File(photo!.path));
  }

}