import 'package:crc_version_1/controller/car_list_controller.dart';
import 'package:crc_version_1/controller/intro_controller.dart';
import 'package:crc_version_1/model/intro.dart';
import 'package:crc_version_1/model/search_suggestion.dart';
import 'package:crc_version_1/view/cars_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomeController extends GetxController{

  IntroController introController = Get.find();
  CarListController carListController = Get.put(CarListController());
  TextEditingController editingController = TextEditingController();



  RxList<Brands> brands = <Brands>[].obs;
  RxList<Colors> colors = <Colors>[].obs;
  RxList<Brands> tempBrandsList = <Brands>[].obs;
  RxList<Models> tempModelsList = <Models>[].obs;
  RxList<SearchSuggestion> searchSuggestion = <SearchSuggestion>[].obs;

  RxBool modelOption = false.obs;
  RxInt modelsLength = 0.obs;
  RxInt brandIndex = 0.obs;
  RxString brandName = '%'.obs;
  RxString modelName = '%'.obs;
  RxInt? brandId;

  @override
  void onInit() {
    super.onInit();
    get_data();
  }
  get_data(){
    brands=introController.brands.obs;
    tempBrandsList.addAll(brands);
    colors=introController.colors.obs;
    searchSuggestion=introController.searchSuggestion.obs;
  }

  chooseBrand(index){
    // for(int i = 0; i < tempBrandsList.length; i++) {
    //   tempBrandsList[i].selected.value = false;
    // }
    // tempBrandsList[index].selected.value = true;
    FocusManager.instance.primaryFocus?.unfocus();
    brandName.value = tempBrandsList[index].title;
    brandIndex.value = brands.indexOf(tempBrandsList[index]);
    tempModelsList = brands[brands.indexOf(tempBrandsList[index])].models.obs;
    carListController.modelListCheck = List.filled(tempModelsList.length, false).obs;
    carListController.selectedBrand.value = index;
    modelOption.value = true;
    carListController.brandListOpen.value = true;
    carListController.brandFilter = brandName;
    for(int i = 0; i < carListController.brandListCheck!.length; i++){
      carListController.brandListCheck![i] = false;
    }
    carListController.brandListCheck![index] = true;
    carListController.myValue!.value = 5000;

  }

  getAll(){
    FocusManager.instance.primaryFocus?.unfocus();
    brandName.value= "%";
    modelName.value= "%";
    tempBrandsList[brandIndex.value].selected.value = false;
     carListController.brand = brandName;
     carListController.model = modelName;
    for(int i = 0; i < carListController.brandListCheck!.length; i++){
      carListController.brandListCheck![i] = false;
    }
    carListController.brandListOpen.value = false;
    carListController.myValue!.value = 5000;
    Get.to(()=>CarsList(false));
  }


  getAllModels(){
    FocusManager.instance.primaryFocus?.unfocus();
    modelName.value= "%";
    carListController.brand = brandName;
    carListController.model = modelName;
    for(int i = 0; i < carListController.modelListCheck!.length; i++){
      carListController.modelListCheck![i] = false;
    }
    carListController.myValue!.value = 5000;
    Get.to(()=>CarsList(false));
  }

  goToBrandMenu(){
    FocusManager.instance.primaryFocus?.unfocus();

    modelOption.value = false;
    tempBrandsList[brandIndex.value].selected.value = false;
    editingController.text = '';
  }

  chooseModel(index){
    FocusManager.instance.primaryFocus?.unfocus();
    carListController.brand = brandName;
    carListController.model.value = brands[brandIndex.value].models[index].title;
    for(int i = 0; i < carListController.modelListCheck!.length; i++){
      carListController.modelListCheck![index] = false;
    }
    carListController.modelListCheck![index] = true;
    carListController.modelFilter.value = brands[brandIndex.value].models[index].title;
    carListController.myValue!.value = 5000;
    Get.to(()=>CarsList(false));
  }

  filterSearchResults(String query) {
    if(modelOption.value == false){
      List<Brands> dummySearchList = <Brands>[];
      dummySearchList.addAll(brands);
      if(query.isNotEmpty) {
        List<Brands> dummyListData = <Brands>[];
        for (var brand in dummySearchList) {
          if(brand.title.toLowerCase().contains(query)) {
            dummyListData.add(brand);
          }
        }
        tempBrandsList.clear();
        tempBrandsList.addAll(dummyListData);
        return;
      } else {
        tempBrandsList.clear();
        tempBrandsList.addAll(brands);

      }
    }
    else if(modelOption.value == true){
      List<Models> dummySearchList = <Models>[];
      dummySearchList.addAll(brands[brandIndex.value].models);
      print('///////////');
      print(brands[brandIndex.value].models.length);
      if(query.isNotEmpty) {
        List<Models> dummyListData = <Models>[];
        for (var model in dummySearchList) {
          if(model.title.toLowerCase().contains(query)) {
            dummyListData.add(model);
          }
        }
        tempModelsList.clear();
        tempModelsList.addAll(dummyListData);
        return;
      } else {
        print('empty');
        print(brands[brandIndex.value].models.length);
        tempModelsList.clear();
        tempModelsList.addAll(brands[brandIndex.value].models);

      }
    }

  }

}