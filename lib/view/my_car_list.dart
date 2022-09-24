import 'package:crc_version_1/app_localization.dart';
import 'package:crc_version_1/controller/my_car_list_controller.dart';
import 'package:crc_version_1/helper/api.dart';
import 'package:crc_version_1/helper/myTheme.dart';
import 'package:crc_version_1/view/edit_car.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:crc_version_1/widget/logo_container.dart';

class MyCarList extends StatelessWidget {

  MyCarListController myCarListController = Get.put(MyCarListController());
  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Obx((){
      return Scaffold(
        body: SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              _body(context),
              // _filterInterface(context),
              // _sortInterface(context),
              _app_bar(context),
            ],
          ),
        ),
      );
    });
  }


  _body(context){
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.07),
      child: SingleChildScrollView(
          child: Column(
          children: [
            SizedBox( height: MediaQuery.of(context).size.height * 0.02),
            _search(context),
            SizedBox( height: MediaQuery.of(context).size.height * 0.02),
            myCarListController.loading.value ? Container(
                width: MediaQuery.of(context).size.width,
                height:  MediaQuery.of(context).size.height * 0.89,
                child: Lottie.asset('assets/images/Animation.json')) :
               myCarListController.tempCarList.isEmpty
                   ? Container(
                width: MediaQuery.of(context).size.width,
                height:  MediaQuery.of(context).size.height * 0.7,
                child: Center(child: Text(App_Localization.of(context).translate('you_do_not_own_any_car_with_that_name'),
                  style: Theme.of(context).textTheme.bodyText2,)),
              ) :
             ListView.builder(
              shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: myCarListController.tempCarList.length,
                itemBuilder:(context, index){
                  return Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Row(
                          children: [
                            _carImage(context, index),
                            SizedBox(width: 5),
                            _carDetails(context,index),
                          ],
                        ),
                      ),
                      Divider(thickness: 1, indent: 25,endIndent: 25,color: Theme.of(context).dividerColor.withOpacity(0.2),height: 40,),
                    ],
                  );
                }
            )
          ],
        ),
      ),
    );
  }

  _carImage(context,index){
    return Expanded(
      flex: 2,
      child: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(Api.url + 'uploads/' + myCarListController.tempCarList[index].image),
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.darken,
                  ),
                )
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: (){
                      // print(myCarListController);
                        myCarListController.goToEditCarPage(index);
                      },
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: Colors.white,size: 22),
                        SizedBox(width: 3),
                        Text(App_Localization.of(context).translate('edit'), style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    )
                  ),
                  GestureDetector(
                    onTap: (){
                      myCarListController.deleteCarFromMyList(index);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.white,size: 22),
                        SizedBox(width: 3),
                        Text(App_Localization.of(context).translate('delete'), style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  _carDetails(context,index){
    return Expanded(
      flex: 3,
      child: Container(
        width: MediaQuery.of(context).size.width*0.55,
        child: Container(
          // width: MediaQuery.of(context).size.width*0.53,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                myCarListController.tempCarList[index].brand
                    + ' - ' + myCarListController.tempCarList[index].model,
                maxLines: 1,
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(
                App_Localization.of(context).translate('daily_rent') + ' ' + myCarListController.tempCarList[index].pricPerDay.toString()
                    + ' ' + App_Localization.of(context).translate('aed'),
                style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 15 ),
              ),
              Divider(thickness: 1,color: MyTheme.isDarkTheme.value?Colors.white.withOpacity(0.5):Colors.black.withOpacity(0.2),height: 1,),
              Container(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(App_Localization.of(context).translate('hid_or_show'),style:  TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontSize: 15, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                      child: Switch(value: myCarListController.tempCarList[index].availableSwitch.value, onChanged: (value){
                        myCarListController.changeAvailability(index);
                      },),
                    )
                  ],
                ),
              )

              // SizedBox(height: 10,),
              // Divider(thickness: 1,color: Theme.of(context).dividerColor.withOpacity(0.1),indent: 1,endIndent: 10,height: 10,),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     Text(App_Localization.of(context).translate('hid_or_show'),style: TextStyle(color: Theme.of(context).dividerColor, fontSize: 12, fontWeight: FontWeight.bold )),
              //
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
  _app_bar(context){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
              padding: const EdgeInsets.only(right: 5,left: 5),
              child: IconButton(
                onPressed: (){
                  Get.back();
                },
                icon: Icon(Icons.arrow_back_ios,size: 20,),
              )
          ),
          LogoContainer(width: 0.35, height: 0.07, logo: 'logo_orange'),
          // Container(
          //   width: 100,
          //   height: MediaQuery.of(context).size.height * 0.05,
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: MyTheme.isDarkTheme.value ? AssetImage('assets/images/logo_dark.png') :  AssetImage('assets/images/logo_light.png')
          //     )
          //   ),
          // ),
          // Container(
          //   child: GestureDetector(
          //     onTap: (){
          //       myCarListController.openFiler();
          //     },
          //     child: Row(
          //       children: [
          //         Container(
          //           width: 20,
          //           height: 20,
          //           child: SvgPicture.asset('assets/images/filter.svg',
          //             color: myCarListController.checkFilterOpen.value ? Theme.of(context).primaryColor : Theme.of(context).dividerColor,
          //           ),
          //         ),
          //         const SizedBox(width: 10),
          //         Text(
          //           App_Localization.of(context).translate('filter'),
          //           style: TextStyle(
          //               color: myCarListController.checkFilterOpen.value ? Theme.of(context).primaryColor : Theme.of(context).dividerColor,
          //               fontSize: 18,
          //               fontWeight: FontWeight.bold
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // VerticalDivider(
          //   indent: 20,
          //   endIndent: 20,
          //   thickness: 1,
          //   color: Theme.of(context).dividerColor,
          // ),
          // Container(
          //   child: GestureDetector(
          //     onTap: (){
          //       myCarListController.openSort();
          //     },
          //     child: Row(
          //       children: [
          //         Container(
          //           width: 18,
          //           height: 18,
          //           child: SvgPicture.asset('assets/images/sort.svg',
          //               color: myCarListController.checkSortOpen.value ? Theme.of(context).primaryColor : Theme.of(context).dividerColor),
          //         ),
          //         const SizedBox(width: 10),
          //         Text(
          //           App_Localization.of(context).translate('sort'),
          //           style: TextStyle(
          //             color: myCarListController.checkSortOpen.value ?
          //             Theme.of(context).primaryColor : Theme.of(context).dividerColor,
          //             fontWeight: FontWeight.bold,
          //             fontSize: 18,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
         const SizedBox(width: 40),
        ],
      ),
    );
  }
  _search(context){
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 45,
      child: TextField(
        onChanged: (value){
          myCarListController.filterSearchResults(value);
        },
        style: Theme.of(context).textTheme.bodyText2,
        controller: editingController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
            labelText: App_Localization.of(context).translate('search'),
            labelStyle: TextStyle(color: Theme.of(context).dividerColor),
            hintText: App_Localization.of(context).translate('search'),
            hintStyle: Theme.of(context).textTheme.bodyText2,
            prefixIcon: Icon(Icons.search,color: Theme.of(context).dividerColor,),
            prefixIconColor: Theme.of(context).primaryColor,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 1,color: Theme.of(context).primaryColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 1,color: Theme.of(context).dividerColor.withOpacity(0.5)),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),)),
      ),
    );
  }


  // _filterInterface(context){
  //   return AnimatedContainer(
  //     width: MediaQuery.of(context).size.width,
  //     height: myCarListController.checkFilterOpen.value ? MediaQuery.of(context).size.height  * 0.6 : 10,
  //     decoration: BoxDecoration(
  //       color: Theme.of(context).backgroundColor,
  //       borderRadius: const BorderRadius.only(
  //         bottomLeft: Radius.circular(10),
  //         bottomRight: Radius.circular(10),
  //       ),
  //     ),
  //     duration: Duration(milliseconds: 800),
  //     curve: Curves.fastOutSlowIn,
  //     child: SingleChildScrollView(
  //       child: Column(
  //         //alignment: Alignment.bottomCenter,
  //         children: [
  //           AnimatedContainer(
  //             duration: Duration(milliseconds: 800),
  //             curve: Curves.fastOutSlowIn,
  //             height: myCarListController.checkFilterOpen.value ? MediaQuery.of(context).size.height  * 0.52 : 10,
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   SizedBox(height: MediaQuery.of(context).size.height  * 0.1,),
  //                   _yearFilterMenu(context),
  //                   const SizedBox(height: 10,),
  //                   _brandFilterMenu(context),
  //                   AnimatedSwitcher(
  //                       duration: const Duration(milliseconds: 500),
  //                       child: myCarListController.brandFilter.value != '%'
  //                           ? Column(children: [const SizedBox(height: 10,) ,_modelFilterMenu(context),const SizedBox(height: 10,)],)
  //                           : Text('')
  //                   ),
  //                   _colorFilterMenu(context),
  //                   const SizedBox(height: 10,),
  //                   _priceFilterMenu(context),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           AnimatedContainer(
  //               duration: const Duration(milliseconds: 900),
  //               curve: Curves.fastOutSlowIn,
  //               decoration: BoxDecoration(
  //                 color: Theme.of(context).backgroundColor,
  //                 borderRadius: const BorderRadius.only(
  //                     bottomLeft: Radius.circular(10),
  //                     bottomRight: Radius.circular(10)
  //                 ),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Theme.of(context).dividerColor.withOpacity(0.2),
  //                     spreadRadius: 1,
  //                     blurRadius: 7,
  //                     offset: Offset(0, -1),
  //                   ),
  //                 ],
  //               ),
  //               width: MediaQuery.of(context).size.width,
  //               height: myCarListController.checkFilterOpen.value ? MediaQuery.of(context).size.height  * 0.08 : 0,
  //               child: Container(
  //                 width: MediaQuery.of(context).size.width * 0.9,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     GestureDetector(
  //                       onTap: (){
  //                         myCarListController.getFilterResult();
  //                       },
  //                       child: Container(
  //                         margin: EdgeInsets.symmetric(horizontal: 20),
  //                         width: MediaQuery.of(context).size.width * 0.2,
  //                         height: MediaQuery.of(context).size.height * 0.04,
  //                         decoration: BoxDecoration(
  //                           color: Theme.of(context).primaryColor,
  //                           borderRadius: BorderRadius.circular(5),
  //                         ),
  //                         child: Center(
  //                           child: Text(
  //                             App_Localization.of(context).translate('done'),
  //                             style: TextStyle(
  //                                 color: Theme.of(context).backgroundColor,
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 15
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     Container(
  //                       margin: EdgeInsets.symmetric(horizontal: 10),
  //                       child: IconButton(
  //                         onPressed: (){
  //                           carListController.clearFilterValue();
  //                         },
  //                         icon: Icon(Icons.delete_outline),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               )
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // _yearFilterMenu(context){
  //   return AnimatedContainer(
  //     duration: const Duration(milliseconds: 800),
  //     curve: Curves.fastOutSlowIn,
  //     width: MediaQuery.of(context).size.width * 0.9,
  //     height: carListController.yearListOpen.value ? MediaQuery.of(context).size.height * 0.11 : 30,
  //     child: SingleChildScrollView(
  //       physics: !carListController.yearListOpen.value ? const NeverScrollableScrollPhysics() :null,
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           GestureDetector(
  //               onTap: (){
  //                 carListController.openYearFilterList();
  //               },
  //               child: Container(
  //                 color: Colors.transparent,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(App_Localization.of(context).translate('year'), style: Theme.of(context).textTheme.headline2,),
  //                     carListController.yearListOpen.value ?  Icon(Icons.keyboard_arrow_up_outlined) : Icon(Icons.keyboard_arrow_down_outlined),
  //                   ],
  //                 ),
  //               )
  //           ),
  //           const SizedBox(height: 15),
  //           Container(
  //               height: 30,
  //               child: ListView.builder(
  //                 scrollDirection: Axis.horizontal,
  //                 shrinkWrap: true,
  //                 physics: const ClampingScrollPhysics(),
  //                 itemCount: carListController.yearModelList.length,
  //                 itemBuilder: (context, index){
  //                   return Row(
  //                     children: [
  //                       Obx((){
  //                         return  GestureDetector(
  //                           onTap: (){
  //                             carListController.chooseYearFilter(index);
  //                           },
  //                           child: Container(
  //                             width: 50,
  //                             decoration: BoxDecoration(
  //                                 color: !carListController.yearModelListCheck[index] == true
  //                                     ? Theme.of(context).backgroundColor
  //                                     : Theme.of(context).primaryColor,
  //                                 borderRadius: BorderRadius.circular(10),
  //                                 border: Border.all(color: Theme.of(context).dividerColor,width: 1)
  //                             ),
  //                             child: Center(
  //                               child:  Text(
  //                                 carListController.yearModelList[index].toString(),
  //                                 style: TextStyle(
  //                                     color: carListController.yearModelListCheck[index] == true
  //                                         ? Colors.white
  //                                         : Theme.of(context).dividerColor
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         );
  //                       }),
  //                       SizedBox(width: 10,),
  //                     ],
  //                   );
  //                 },
  //               )
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // _brandFilterMenu(context){
  //   return AnimatedContainer(
  //     duration: Duration(milliseconds: 800),
  //     curve: Curves.fastOutSlowIn,
  //     width: MediaQuery.of(context).size.width * 0.9,
  //     height: carListController.brandListOpen.value ? MediaQuery.of(context).size.height * 0.11 : 30,
  //     child: SingleChildScrollView(
  //       physics: !carListController.brandListOpen.value ? const NeverScrollableScrollPhysics() : null,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           GestureDetector(
  //               onTap: (){
  //                 carListController.openBrandFilterList();
  //               },
  //               child: Container(
  //                 color: Colors.transparent,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(App_Localization.of(context).translate('brand'), style: Theme.of(context).textTheme.headline2,maxLines: 2,),
  //                     carListController.brandListOpen.value ?  Icon(Icons.keyboard_arrow_up_outlined) : Icon(Icons.keyboard_arrow_down_outlined),
  //                   ],
  //                 ),
  //               )
  //           ),
  //           const SizedBox(height: 15),
  //           Container(
  //             height: 30,
  //             child: ListView.builder(
  //               scrollDirection: Axis.horizontal,
  //               itemCount: introController.brands.length,
  //               itemBuilder: (context, index){
  //                 return Row(
  //                   children: [
  //                     Obx((){
  //                       return  GestureDetector(
  //                         onTap: (){
  //                           carListController.chooseBrandFilter(index);
  //                         },
  //                         child: Container(
  //                           width: 80,
  //                           decoration: BoxDecoration(
  //                               color: !carListController.brandListCheck![index] == true
  //                                   ? Theme.of(context).backgroundColor
  //                                   : Theme.of(context).primaryColor,
  //                               borderRadius: BorderRadius.circular(10),
  //                               border: Border.all(color: Theme.of(context).dividerColor,width: 1)
  //                           ),
  //                           child: Center(
  //                             child: Text(
  //                               introController.brands[index].title,textAlign: TextAlign.center,
  //                               style: TextStyle(
  //                                   color: !carListController.brandListCheck![index] == true
  //                                       ? Theme.of(context).dividerColor
  //                                       : Colors.white,
  //                                   fontSize: 11,fontWeight: FontWeight.bold),),
  //                           ),
  //                         ),
  //                       );
  //                     }),
  //                     SizedBox(width: 8,),
  //                   ],
  //                 );
  //               },
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // _modelFilterMenu(context){
  //   return AnimatedContainer(
  //     duration: const Duration(milliseconds: 800),
  //     curve: Curves.fastOutSlowIn,
  //     width: MediaQuery.of(context).size.width * 0.9,
  //     height: carListController.carModelListOpen.value ? MediaQuery.of(context).size.height * 0.11 : 30,
  //     child: SingleChildScrollView(
  //       physics: !carListController.carModelListOpen.value ? const NeverScrollableScrollPhysics() :null,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           GestureDetector(
  //               onTap: (){
  //                 carListController.openCarModelFilterList();
  //               },
  //               child: Container(
  //                 color: Colors.transparent,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Center(
  //                       child: Text(App_Localization.of(context).translate('car_model'), style: Theme.of(context).textTheme.headline2,),
  //                     ),
  //                     carListController.carModelListOpen.value ?  Icon(Icons.keyboard_arrow_up_outlined) : Icon(Icons.keyboard_arrow_down_outlined),
  //                   ],
  //                 ),
  //               )
  //           ),
  //           const SizedBox(height: 15),
  //           Container(
  //             height: 30,
  //             child: ListView.builder(
  //               scrollDirection: Axis.horizontal,
  //               itemCount: introController.brands[carListController.selectedBrand.value].models.length,
  //               itemBuilder: (context, index){
  //                 return Row(
  //                   children: [
  //                     Obx((){
  //                       return  GestureDetector(
  //                         onTap: (){
  //                           carListController.chooseModelFilter(index);
  //                         },
  //                         child: Container(
  //                           width: 90,
  //                           decoration: BoxDecoration(
  //                               color: !carListController.modelListCheck![index] == true
  //                                   ? Theme.of(context).backgroundColor
  //                                   : Theme.of(context).primaryColor,
  //                               borderRadius: BorderRadius.circular(10),
  //                               border: Border.all(color: Theme.of(context).dividerColor,width: 1)
  //                           ),
  //                           child: Center(
  //                             child: Text(
  //                               introController.brands[carListController.selectedBrand.value].models[index].title,textAlign: TextAlign.center,
  //                               maxLines: 1,
  //                               overflow: TextOverflow.ellipsis,
  //                               style: TextStyle(
  //                                   color: !carListController.modelListCheck![index] == true
  //                                       ? Theme.of(context).dividerColor
  //                                       : Theme.of(context).backgroundColor,
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.bold),),
  //                           ),
  //                         ),
  //                       );
  //                     }),
  //                     SizedBox(width: 8,),
  //                   ],
  //                 );
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // _colorFilterMenu(context){
  //   return AnimatedContainer(
  //     duration: const Duration(milliseconds: 800),
  //     curve: Curves.fastOutSlowIn,
  //     width: MediaQuery.of(context).size.width * 0.9,
  //     height: carListController.colorListOpen.value ? MediaQuery.of(context).size.height * 0.11 : 30,
  //     child: SingleChildScrollView(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           GestureDetector(
  //               onTap: (){
  //                 carListController.openColorFilterList();
  //               },
  //               child: Container(
  //                 color: Colors.transparent,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(App_Localization.of(context).translate('color'), style: Theme.of(context).textTheme.headline2,),
  //                     carListController.colorListOpen.value ?  Icon(Icons.keyboard_arrow_up_outlined) : Icon(Icons.keyboard_arrow_down_outlined),
  //                   ],
  //                 ),
  //               )
  //           ),
  //           const SizedBox(height: 15),
  //           Container(
  //             height: 30,
  //             child: ListView.builder(
  //               scrollDirection: Axis.horizontal,
  //               itemCount: introController.colors.length,
  //               itemBuilder: (context, index){
  //                 return Row(
  //                   children: [
  //                     Obx((){
  //                       return GestureDetector(
  //                         onTap: (){
  //                           carListController.chooseColorFilter(index);
  //                         },
  //                         child: Container(
  //                           width: 80,
  //                           decoration: BoxDecoration(
  //                               color: !carListController.colorListFilter![index] == true
  //                                   ? Theme.of(context).backgroundColor
  //                                   : Theme.of(context).primaryColor,
  //                               borderRadius: BorderRadius.circular(10),
  //                               border: Border.all(color: Theme.of(context).dividerColor,width: 1)
  //                           ),
  //                           child: Center(
  //                             child: Text(
  //                               introController.colors[index].title,
  //                               textAlign: TextAlign.center,
  //                               style: TextStyle(
  //                                   color: !carListController.colorListFilter![index] == true
  //                                       ? Theme.of(context).dividerColor
  //                                       : Theme.of(context).backgroundColor ,
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.bold),),
  //                           ),
  //                         ),
  //                       );
  //                     }),
  //                     SizedBox(width: 8,),
  //                   ],
  //                 );
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // _priceFilterMenu(context){
  //   return Obx((){
  //     return Container(
  //         child: Row(
  //           children: [
  //             const SizedBox(width: 15,),
  //             Container(
  //               child: Text('0',style: Theme.of(context).textTheme.headline3,),
  //             ),
  //             Expanded(
  //               child: Slider(
  //                 value: carListController.myValue!.value,
  //                 min: 0,
  //                 max: carListController.max!.value,
  //                 divisions: 50,
  //                 activeColor: Theme.of(context).primaryColor,
  //                 inactiveColor: Theme.of(context).primaryColor.withOpacity(0.2),
  //                 label: carListController.myValue!.value.round().toString() + ' AED',
  //                 onChanged: (value){
  //                   setState(() {
  //                     carListController.myValue!.value = value;
  //                   });
  //                 },
  //               ),
  //             ),
  //             Container(
  //               child: Text(carListController.max!.value.round().toString() + ' AED',style: Theme.of(context).textTheme.headline3,),
  //             ),
  //             const SizedBox(width: 15,),
  //           ],
  //         )
  //     );
  //   });
  // }
  //
  // _sortInterface(context){
  //   return AnimatedContainer(
  //     width: MediaQuery.of(context).size.width,
  //     height: carListController.checkSortOpen.value ? MediaQuery.of(context).size.height  * 0.25 : 10,
  //     decoration: BoxDecoration(
  //       color: Theme.of(context).backgroundColor,
  //       borderRadius: const BorderRadius.only(
  //         bottomLeft: Radius.circular(10),
  //         bottomRight: Radius.circular(10),
  //       ),
  //     ),
  //     duration: Duration(milliseconds: 800),
  //     curve: Curves.fastOutSlowIn,
  //     child: SingleChildScrollView(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           SizedBox(height: MediaQuery.of(context).size.height  * 0.1,),
  //           Column(
  //             children: [
  //               GestureDetector(
  //                 onTap: (){
  //                   carListController.selectSortType();
  //                 },
  //                 child: Container(
  //                   width: MediaQuery.of(context).size.width * 0.9,
  //                   height: 40,
  //                   decoration: BoxDecoration(
  //                     color: carListController.sortFilter.value == "ASC"
  //                         ? Colors.grey.withOpacity(0.2)
  //                         : Colors.transparent,
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                   child: Center(
  //                     child: Text(
  //                       'Price Low to high',
  //                       style: TextStyle(
  //                           color: carListController.sortFilter.value == 'ASC'
  //                               ? Theme.of(context).primaryColor
  //                               : Theme.of(context).dividerColor,
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.bold),),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(height: 10,),
  //               GestureDetector(
  //                 onTap: (){
  //                   carListController.selectSortType();
  //                 },
  //                 child: Container(
  //                   width: MediaQuery.of(context).size.width * 0.9,
  //                   height: 40,
  //                   decoration: BoxDecoration(
  //                     color:carListController.sortFilter.value != "ASC"
  //                         ? Colors.grey.withOpacity(0.2)
  //                         : Colors.transparent,
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                   child: Center(
  //                     child: Text(
  //                       'Price high to low',
  //                       style: TextStyle(
  //                           color: carListController.sortFilter.value != 'ASC'
  //                               ? Theme.of(context).primaryColor
  //                               : Theme.of(context).dividerColor,
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.bold),),
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  _background(context){
    return GestureDetector(
      onTap: (){
        myCarListController.checkSortOpen.value = false;
        myCarListController.checkFilterOpen.value = false;
      },
      child:  AnimatedSwitcher(
        duration: Duration(milliseconds: 800),
        child: myCarListController.checkFilterOpen.value || myCarListController.checkSortOpen.value ? Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).dividerColor.withOpacity(0.7),
        ) : Text(''),
      ),
    );
  }



}

