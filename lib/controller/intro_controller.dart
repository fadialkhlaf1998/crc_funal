import 'package:crc_version_1/helper/api.dart';
import 'package:crc_version_1/helper/global.dart';
import 'package:crc_version_1/helper/store.dart';
import 'package:crc_version_1/model/intro.dart';
import 'package:crc_version_1/model/search_suggestion.dart';
import 'package:crc_version_1/view/home.dart';
import 'package:crc_version_1/view/login.dart';
import 'package:crc_version_1/view/no_internet.dart';
import 'package:get/get.dart';

class IntroController extends GetxController{
  List<Brands> brands = <Brands>[];
  List<Colors> colors = <Colors>[];
  List<SearchSuggestion> searchSuggestion = <SearchSuggestion>[];

  @override
  void onInit() {
    super.onInit();
    get_data();
  }

  get_data(){
    Api.check_internet().then((internet) {
      if(internet){
        Api.get_data().then((data) {
          brands=data.brands;
          colors=data.colors;
          searchSuggestion=data.searchSuggestions;
          get_page();
        });
      }else{
        Get.to(()=>NoInternet())!.then((value) {
          get_data();
        });
      }
    });
  }

  get_page(){
      Store.Load_login().then((value) {
        print(value.email);
      if(Global.loginInfo!.email=="non"){
          Future.delayed(Duration(milliseconds: 1000)).then((value) {
            Get.offAll(() => LogIn());
          });
        }else{
          Api.login(Global.loginInfo!.email, Global.loginInfo!.pass).then((company) {

            Global.company_id = company.id;
            Global.companyImage.value = company.profileImage;
            Global.companyTitle = company.title;
            Global.company = company;
            Future.delayed(const Duration(milliseconds: 1000)).then((value) {
              Get.offAll(()=>Home());
            });
          });
        }
      });

  }

}