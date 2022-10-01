import 'package:crc_version_1/app_localization.dart';
import 'package:crc_version_1/controller/home_controller.dart';
import 'package:crc_version_1/helper/app.dart';
import 'package:crc_version_1/helper/myTheme.dart';
import 'package:crc_version_1/model/search_suggestion.dart';
import 'package:crc_version_1/view/searchDelgate.dart';
// import 'package:crc_version_1/view/search_delegate.dart';
import 'package:crc_version_1/widget/background_page.dart';
import 'package:crc_version_1/widget/logo_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:new_version/new_version.dart';


class Home extends StatelessWidget {

  HomeController homeController = Get.put(HomeController());

  // _checkVersion(BuildContext context)async{
  //   final newVersion = NewVersion(
  //     iOSId: "com.Maxart.Crc",
  //     androidId: 'com.maxart.crc_version_1',
  //   );
  //   final state = await newVersion.getVersionStatus();
  //   if(state!.canUpdate){
  //     newVersion.showUpdateDialog(context: context, versionStatus: state);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
   // _checkVersion(context);
    return WillPopScope(
      onWillPop: ()async{
        if (homeController.modelOption.value){
          homeController.modelOption.value = false;
          return false;
        }else{
          Get.back();
          return true;
        }
      },
      child: Obx((){
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: SafeArea(
            child: Stack(
              children: [
                BackgroundPage(),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30,),
                      _header(context),
                      const SizedBox(height: 30,),
                      _search(context),
                      const SizedBox(height: 30,),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: !homeController.modelOption.value ?
                         homeController.tempBrandsList.isEmpty
                             ? Text(App_Localization.of(context).translate('there_are_no_car_with_this_name'))
                             : _brandBody(context)
                             : AnimatedSwitcher(
                          duration: Duration(milliseconds: 0),
                          child: homeController.tempModelsList.isEmpty
                              ? Text(App_Localization.of(context).translate('there_are_no_car_with_this_model_name'))
                              : _modelsBody(context),
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }


  _header(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height  * 0.15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            child:  homeController.modelOption.value ? SizedBox(
              width: 90,
              child: GestureDetector(
                onTap: (){
                  FocusManager.instance.primaryFocus?.unfocus();
                  homeController.goToBrandMenu();
                },
                child: Icon(Icons.arrow_back_ios, color: Theme.of(context).dividerColor,),
              ),
            ) : SizedBox(width: 90),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LogoContainer(width: 0.35, height: 0.07, logo: 'logo_orange'),
              SizedBox(height: 7),
              Text(App_Localization.of(context).translate('welcome_to_crc'), style: Theme.of(context).textTheme.headline2),
              !homeController.modelOption.value ?
                Text(App_Localization.of(context).translate('please_select_car_brand'), style: Theme.of(context).textTheme.bodyText2)
                    :Text(App_Localization.of(context).translate('please_select_the_vehicle_type'), style: Theme.of(context).textTheme.bodyText2) ,
            ],
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            child:  !homeController.modelOption.value ? SizedBox(
              width: 90,
              child: GestureDetector(
                onTap: (){
                  FocusManager.instance.primaryFocus?.unfocus();
                  homeController.getAll();
                  // homeController.getAll();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(App_Localization.of(context).translate('all_car'),style: Theme.of(context).textTheme.headline3,))
              ),
            ) : SizedBox(width: 90),
          ),
          //SizedBox(width: 50,)
        ],
      ),
    );
  }

  _search(context){
    return GestureDetector(
      onTap: (){
        showSearch(
          context: context,
          delegate: SearchDeligate(searchSuggestion: homeController.searchSuggestion.value),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor,),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 10,),
            Icon(Icons.search,color: Theme.of(context).dividerColor,),
            SizedBox(width: 10,),
            Text(App_Localization.of(context).translate('search_for_car_rent'),style:TextStyle(color: Theme.of(context).dividerColor,fontSize: 14),)
          ],
        )
        // TextField(
        //   onChanged: (value){
        //     homeController.filterSearchResults(value);
        //   },
        //   onTap: (){
        //     showSearch(
        //       context: context,
        //       delegate: SearchDeligate(searchSuggestion: homeController.searchSuggestion.value),
        //     );
        //
        //   },
        //   style: Theme.of(context).textTheme.bodyText2,
        //   controller: homeController.editingController,
        //   decoration: InputDecoration(
        //     contentPadding: const EdgeInsets.only(bottom: 0),
        //       labelText: App_Localization.of(context).translate('search_for_car_rent'),
        //       labelStyle: TextStyle(color: Theme.of(context).dividerColor,fontSize: 14),
        //       prefixIcon: Icon(Icons.search,color: Theme.of(context).dividerColor,),
        //       prefixIconColor: Theme.of(context).primaryColor,
        //       focusedBorder: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(10),
        //         borderSide: BorderSide(width: 1,color: Theme.of(context).primaryColor),
        //       ),
        //       border: OutlineInputBorder(
        //         borderSide: BorderSide(width: 1,color: Theme.of(context).dividerColor.withOpacity(0.5)),
        //         borderRadius: BorderRadius.circular(10),),
        //     enabledBorder: OutlineInputBorder(
        //       borderSide: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.3)),
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //   ),
        //
        // ),
      ),
    );
  }

  _searchBar(BuildContext context){
    return GestureDetector(
      onTap: (){
        // final result = await showSearch(
        //     context: context,
        //     delegate: SearchTextField(suggestion_list: [], homeController: homeController ));
      },
      child:  Container(
        width: MediaQuery.of(context).size.width  * 0.9,
        height: 35,
        decoration: BoxDecoration(
          color: App.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.only(right: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                print('222222222222222');
                FocusManager.instance.primaryFocus?.unfocus();

              },
              icon: const Icon(
                Icons.search,
              ),
            ),
            Text(App_Localization.of(context).translate('search_here'),style: Theme.of(context).textTheme.headline3)
          ],
        ),
      ),
    );
  }

  _brandBody(context){
    return Obx((){
     return Container(
        width: MediaQuery.of(context).size.width*0.9,
        height: MediaQuery.of(context).size.height * 0.68,
        child: GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 30),
          itemCount: homeController.tempBrandsList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.9,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemBuilder: (context,index){
            return GestureDetector(
              onTap: (){
                homeController.chooseBrand(index);
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 4 ,
                height: MediaQuery.of(context).size.width / 4 ,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: MyTheme.isDarkTheme.value ?Colors.white :Colors.black)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 6 ,
                      height: MediaQuery.of(context).size.width / 6 ,

                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(

                          decoration: BoxDecoration(
                            // color: Colors.red,
                              image: DecorationImage(
                                image: NetworkImage(homeController.tempBrandsList[index].image),
                                // fit: BoxFit.fitHeight
                              )
                          ),
                        ),
                      ),
                    ),
                    Text(homeController.tempBrandsList[index].title.toString(),style: TextStyle(color: MyTheme.isDarkTheme.value ?Colors.white :Colors.black,fontWeight: FontWeight.bold),),
                    Text(homeController.tempBrandsList[index].count.toString()+" Cars",style: TextStyle(color: MyTheme.isDarkTheme.value ?Colors.white.withOpacity(0.5) :Colors.black.withOpacity(0.5)),),

                  ],
                ),
              ),
            );
          },

        ),
      );
    });
  }

  _modelsBody(context){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.68,
      child:SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: (){
                    homeController.getAllModels();
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width * 0.85,
                    child:Text(App_Localization.of(context).translate('all_models'), style: Theme.of(context).textTheme.headline3),
                  ),
                ),
                Divider(color: Theme.of(context).dividerColor.withOpacity(0.2),thickness: 1,indent: 30,endIndent: 35,)
              ],
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: homeController.tempModelsList.length,//homeController.brands[homeController.brandIndex.value].models.length,
              itemBuilder: (context, index){
                return Obx((){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: (){
                          homeController.chooseModel(index);
                        },
                        child: Container(
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: MediaQuery.of(context).size.height * 0.04,
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(homeController.tempModelsList[index].title, style: Theme.of(context).textTheme.headline3),
                            ],
                          ),
                        ),
                      ),
                      Divider(color: Theme.of(context).dividerColor.withOpacity(0.2),thickness: 1,indent: 30,endIndent: 35,)
                    ],
                  );
                });
              },
            ),
            SizedBox(height: 30)
          ],
        ),
      ),
    );
  }
}



class SearchTextField extends SearchDelegate<String> {
  final List<String> suggestion_list;
  String? result;
  // HomeController homeController;

  SearchTextField(
      {required this.suggestion_list});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [query.isEmpty ? Visibility( child: Text(''), visible: false) : IconButton(
        icon: Icon(Icons.search, color: Colors.white,),
        onPressed: () {
          close(context, query);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Get.back();
      },
    );
  }


  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
      appBarTheme: AppBarTheme(
        color: App.primary, //new AppBar color
        elevation: 0,
      ),
      hintColor: Colors.white,
      textTheme: TextTheme(
        headline6: TextStyle(
            color: Colors.white
        ),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestions = suggestion_list.where((name) {
      return name.toLowerCase().contains(query.toLowerCase());
    });
   // homeController.get_products_by_search(query, context);
    close(context, query);
    return Center(
      child: CircularProgressIndicator(
        color: App.primary,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = suggestion_list.where((name) {
      return name.toLowerCase().contains(query.toLowerCase());
    });
    return Container(
      color: App.primary,
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
              suggestions.elementAt(index),
              style: TextStyle(color: App.primary),
            ),
            onTap: () {
              query = suggestions.elementAt(index);
              close(context, query);
            },
          );
        },
      ),
    );
  }
}