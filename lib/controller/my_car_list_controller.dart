import 'package:crc_version_1/helper/api.dart';
import 'package:crc_version_1/helper/global.dart';
import 'package:crc_version_1/model/car.dart';
import 'package:crc_version_1/view/edit_car.dart';
import 'package:get/get.dart';
import 'package:crc_version_1/model/my_car.dart';

class MyCarListController extends GetxController{



  RxBool checkFilterOpen = false.obs;
  RxBool checkSortOpen = false.obs;
  RxBool yearListOpen = false.obs;
  int companyId = -1;
  RxList<MyCar> myCarList = <MyCar>[].obs;
  RxBool loading = false.obs;
  RxList<MyCar> tempCarList = <MyCar>[].obs;


  /// Filter Variable */
  RxString brandFilter = '%'.obs;
  RxString modelFilter = '%'.obs;
  RxString yearFilter = '%'.obs;
  RxString colorFilter = '%'.obs;
  RxString priceFilter = '%'.obs;
  RxString sortFilter = 'ASC'.obs;

  /// Edit Variable */
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
  RxList<myImage> carImages = <myImage>[].obs;



  @override
  void onInit() {
    super.onInit();
    companyId = Global.company_id;
    getCarList(companyId);
    tempCarList.addAll(myCarList);
  }

  getCarList(int companyId){
    myCarList.clear();
    tempCarList.clear();
    loading.value = true;
      Api.check_internet().then((internet)async{
        if(internet){
          //loading.value = true;
          Api.getMyCarsList(companyId).then((value)async{
            myCarList.addAll(value);
            tempCarList.addAll(value);
            loading.value = false;
          });
        }else{
          loading.value = false;
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

  changeAvailability(index){
    int carId = tempCarList[index].id;
    if(tempCarList[index].availableSwitch.value == true){
      tempCarList[index].availableSwitch.value = false;
      Api.changeCarAvailability(0.toString(), carId);
    }else if(tempCarList[index].availableSwitch.value == false){
      tempCarList[index].availableSwitch.value = true;
      Api.changeCarAvailability(1.toString(), carId);
    }

  }

  deleteCarFromMyList(index){
    int delete_id = tempCarList[index].id;
    loading.value = true;
    Api.check_internet().then((internet){
      if(internet){
        Api.deleteCar(delete_id).then((value){
          if(value){
            print('Delete');
            loading.value = false;
            tempCarList.removeAt(index);
          }else{
            loading.value = false;
            print('Not delete');
          }
        });
      }else{
        loading.value = false;
        print('Field');
      }
      // getCarList(companyId);
    });

  }

  filterSearchResults(String query) {
    List<MyCar> dummySearchList = <MyCar>[];
    dummySearchList.addAll(myCarList);
    if(query.isNotEmpty) {
      List<MyCar> dummyListData = <MyCar>[];
      for (var car in dummySearchList) {
        if(car.title.toLowerCase().contains(query)) {
          dummyListData.add(car);
        }
      }
        tempCarList.clear();
        tempCarList.addAll(dummyListData);
      return;
    } else {
        tempCarList.clear();
        tempCarList.addAll(myCarList);

    }
  }

  goToEditCarPage(index){
    tempCarList[index].editLoading.value = true;
    Api.getCarInfo(tempCarList[index].id).then((value) {
      tempCarList[index].editLoading.value = false;
      if(value != null){
        brand = tempCarList[index].brand.obs;
        model = tempCarList[index].model.obs;
        year = tempCarList[index].year.toString().obs;
        color = tempCarList[index].color.obs;
        price = tempCarList[index].pricPerDay.toString().obs;
        pricePerMonth = tempCarList[index].pricePerMonth.toString().obs;
        carId = tempCarList[index].id.toString().obs;
        brandId = tempCarList[index].brandId.toString().obs;
        available = tempCarList[index].avilable.toString().obs;
        modelId = tempCarList[index].modelId.toString().obs;
        location=tempCarList[index].location.obs;
        carImages = value.images.obs;
        Get.to(()=>EditCar());
      }else{
        //todo error msg
      }
    });


  }

}