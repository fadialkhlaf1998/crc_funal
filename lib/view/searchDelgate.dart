import 'package:crc_version_1/app_localization.dart';
import 'package:crc_version_1/controller/car_list_controller.dart';
import 'package:crc_version_1/helper/api.dart';
import 'package:crc_version_1/helper/app.dart';
import 'package:crc_version_1/helper/myTheme.dart';
import 'package:crc_version_1/model/search_suggestion.dart';
import 'package:crc_version_1/view/cars_list.dart';
import 'package:crc_version_1/widget/background_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';




class SearchDeligate extends SearchDelegate<String> {

  // IntroductionController introController;
  List<SearchSuggestion> searchSuggestion = <SearchSuggestion>[];
  SearchDeligate({required this.searchSuggestion});
  CarListController carListController = Get.find();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      query.isEmpty ?
      const Visibility(
        child: Text(''),
        visible: false
      ) : IconButton(
        icon: Icon(Icons.close, color: Colors.white,size: 23),
        onPressed: () {
          query="";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back,size: 23,color: Colors.white),
      onPressed: () {
        Get.back();
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
      appBarTheme: AppBarTheme(
        color: MyTheme.isDarkTheme.value?Colors.grey[600]:App.primary,
        // color: App.greySettingPage,
        elevation: 0,
      ),

      textSelectionTheme:  TextSelectionThemeData(
        cursorColor: App.primary
      ),
      hintColor: Colors.white,
      textTheme: TextTheme(
        headline6: TextStyle(
          fontSize: 14,
          color:Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }


  @override
  Widget buildResults(BuildContext context) {
    final suggestions = searchSuggestion.where((elm) {
      return (elm.title.toLowerCase().contains(query.toLowerCase())||elm.brand.toLowerCase().contains(query.toLowerCase()));
    });
    return suggestions.isEmpty ?
    Stack(
      children: [
        BackgroundPage(),
        Container(
            height: Get.height,
            width: Get.width,
            // color: App.grey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(App_Localization.of(context).translate("no_results_matched"),
                  style: TextStyle(
                    fontSize: 14,
                    color: MyTheme.isDarkTheme.value?Colors.white:App.darkGrey,
                    fontWeight: FontWeight.normal,
                  ),
                )
              ],
            )
        ),
      ],
    ) :
    Stack(
      children: [
        BackgroundPage(),
        Container(
            height: Get.height,
            width: Get.width,
            // color: App.grey,
            child: query.isEmpty
                ? Center()
                : ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10 ,vertical: 10),
                    child: ListTile(
                      // leading: const Icon(Icons.car),
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      style: ListTileStyle.drawer,
                      leading: Container(
                        width: 75,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            // shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(Api.imageUrl+suggestions.elementAt(index).image),
                                fit: BoxFit.cover
                            )
                        ),
                      ),
                      title: Text(suggestions.elementAt(index).brand + " "
                          +suggestions.elementAt(index).model,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: MyTheme.isDarkTheme.value?Colors.white:App.darkGrey,
                            overflow: TextOverflow.ellipsis
                        ),
                      ),

                      onTap: (){
                        //todo filter
                        close(context, "");
                        Get.to(()=>CarsList(true));
                        carListController.search(suggestions.elementAt(index).brand+" "+suggestions.elementAt(index).model);
                      },
                    )
                );
              },
            )
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = searchSuggestion.where((elm) {
      return (elm.title.toLowerCase().contains(query.toLowerCase())||elm.brand.toLowerCase().contains(query.toLowerCase()));
    });
    return suggestions.isEmpty ?
    Stack(
      children: [
        BackgroundPage(),
        Container(
            height: Get.height,
            width: Get.width,
            // color: App.grey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(App_Localization.of(context).translate("no_results_matched"),
                  style: TextStyle(
                    fontSize: 14,
                    color: MyTheme.isDarkTheme.value?Colors.white:App.darkGrey,
                    fontWeight: FontWeight.normal,
                  ),
                )
              ],
            )
        ),
      ],
    ) :
    Stack(
      children: [
        BackgroundPage(),
        query.isEmpty
            ? Center()
            : Container(
            height: Get.height,
            width: Get.width,
            // color: App.grey,
            child: ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10 ,vertical: 10),
                  child: ListTile(
                    // leading: const Icon(Icons.car),
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    style: ListTileStyle.drawer,
                    leading: Container(
                      width: 75,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(Api.imageUrl+suggestions.elementAt(index).image),
                          fit: BoxFit.cover
                        )
                      ),
                    ),
                    title: Text(suggestions.elementAt(index).brand + " "
                        +suggestions.elementAt(index).model,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: MyTheme.isDarkTheme.value?Colors.white:App.darkGrey,
                          overflow: TextOverflow.ellipsis
                      ),
                    ),

                    onTap: (){
                      //todo filter
                      close(context, "");
                      Get.to(()=>CarsList(true));
                      carListController.search(suggestions.elementAt(index).brand+" "+suggestions.elementAt(index).model);
                    },
                  )
                );
              },
            )
        ),
      ],
    );
  }
}