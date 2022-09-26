import 'package:crc_version_1/app_localization.dart';
import 'package:crc_version_1/controller/edit_person_controller.dart';
import 'package:crc_version_1/controller/people_list_controller.dart';
import 'package:crc_version_1/helper/api.dart';
import 'package:crc_version_1/helper/app.dart';
import 'package:crc_version_1/helper/global.dart';
import 'package:crc_version_1/helper/myTheme.dart';
import 'package:crc_version_1/view/add_people.dart';
import 'package:crc_version_1/view/edit_person.dart';
import 'package:crc_version_1/widget/logo_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:toggle_switch/toggle_switch.dart';

class PeopleList extends StatelessWidget {

  PeopleListController peopleListController = Get.put(PeopleListController());
  //EditPersonController editPersonController = Get.put(EditPersonController());

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
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: peopleListController.loading.value == true ?
                Container(
                  width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.89,
                    child: Lottie.asset('assets/images/Animation.json')
                ) : _body1(context),
              ),
              _appBar(context),
              // _addBtn(context),
            ],
          ),
        ),
      );
    });
  }


  _appBar(context){
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.08+55,
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(right: 5,left: 5),
                      child: IconButton(
                        onPressed: (){
                          Get.back();
                        },
                        icon: const Icon(Icons.arrow_back_ios,size: 20,),
                      )
                  ),
                  LogoContainer(width: 0.35, height: 0.07, logo: 'logo_orange'),
                  SizedBox(width: 50,)
                ],
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  Get.to(()=>AddPeople())!..then((value) {
                    peopleListController.getInfo(Global.company_id);
                  });
                },
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 45,
                    decoration: BoxDecoration(
                        color: App.primary,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        // Icon(Icons.add,color: Colors.white,),
                        Text(App_Localization.of(context).translate("add_people"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15)),
                        // Icon(Icons.add,color: Colors.transparent,),
                      ],
                    )
                ),
              )
            ],
          ),
        ),

      ],
    );
  }
  _addBtn(context){
    return GestureDetector(
      onTap: (){
        Get.to(()=>AddPeople());
      },
      child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 45,
          decoration: BoxDecoration(
              color: App.primary,
              borderRadius: BorderRadius.circular(10)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Icon(Icons.add,color: Colors.white,),
              Text(App_Localization.of(context).translate("add_people"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15)),
              // Icon(Icons.add,color: Colors.transparent,),
            ],
          )
      ),
    );
  }
  _body(context){
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.95,
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
            child: Obx((){
              print( peopleListController.myPeopleList.isEmpty);
              return peopleListController.myPeopleList.isEmpty
                  ? Container(
                width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Center(
                      child: Text(
                        App_Localization.of(context).translate('there_are_no_people_at_the_moment'),
                        style: Theme.of(context).textTheme.bodyText2
                      ),
                    ),
              )
                  :ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: peopleListController.myPeopleList.length,
                  itemBuilder:(context, index){
                    return Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            children: [
                            Expanded(
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
                                          image: NetworkImage(Api.url + 'uploads/' +  peopleListController.myPeopleList[index].image),
                                          // colorFilter: ColorFilter.mode(
                                          //   Colors.black.withOpacity(0.4),
                                          //   BlendMode.darken,
                                          // ),
                                        )
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                              SizedBox(width: 5),
                              Expanded(
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
                                          peopleListController.myPeopleList[index].name,
                                          maxLines: 1,
                                          style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontWeight: FontWeight.bold,fontSize: 16),
                                        ),

                                        Text(
                                          peopleListController.myPeopleList[index].languages,
                                          style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 15 ),
                                        ),
                                        Divider(thickness: 1,color: MyTheme.isDarkTheme.value?Colors.white.withOpacity(0.5):Colors.black.withOpacity(0.2),height: 1,),
                                        Container(
                                          // color: Colors.red,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(App_Localization.of(context).translate('available_to_rent_or_no'),style:  TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontSize: 15, fontWeight: FontWeight.normal)),


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
                              )

                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  // color: Colors.green,
                                  child: Center(
                                      child: Obx(() => peopleListController.myPeopleList[index].availableSwitch.value
                                          ?LinearProgressIndicator():Container(
                                        // color: Colors.red,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                                onTap: (){
                                                  // print(myCarListController);
                                                  // myCarListController.goToEditCarPage(index);
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
                                                  // myCarListController.deleteCarFromMyList(index);
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
                                      ),)
                                  ),
                                ),),
                              Expanded(
                                flex: 3,
                                child: Center(
                                  child: Obx(() => SizedBox(
                                    height: 25,
                                    // width: 62,
                                    child: ToggleSwitch(
                                      initialLabelIndex: peopleListController.myPeopleList[index].availableSwitch.value?0:1,
                                      totalSwitches: 2,
                                      labels: [
                                        'Yes',
                                        'No',
                                      ],
                                      animationDuration: 200,
                                      fontSize: 15,
                                      // minWidth: 61,
                                      customWidths: [60,60],
                                      // activeBgColor: [
                                      //   Colors.green,
                                      //   Colors.red
                                      // ],
                                      // activeFgColor:Colors.green,
                                      animate: true,
                                      inactiveBgColor: Colors.grey,
                                      activeBgColors: [[Colors.green],[Colors.red]],
                                      onToggle: (realIndex) {
                                        print('switched to: $index');
                                        // myCarListController.changeAvailability(index);
                                      },
                                    ),
                                  )),
                                ),)
                            ],
                          ),
                        ),
                        Divider(thickness: 1, indent: 25,endIndent: 25,color: Theme.of(context).dividerColor.withOpacity(0.2),height: 20,),
                      ],
                    );
                  }
              );
            }),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  _archive(){
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: peopleListController.myPeopleList.length,
      itemBuilder: (context, index){
        return  Column(
          children: [
            const SizedBox(height: 20),
            Obx((){
              return Container(
                height:  MediaQuery.of(context).size.height * 0.32,
                width:  MediaQuery.of(context).size.width * 0.9,
                // color: Colors.red,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06),
                      decoration: BoxDecoration(
                          color: Theme.of(context).dividerColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Container(
                        // color: Colors.red,
                        decoration: BoxDecoration(
                            color: MyTheme.isDarkTheme.value?App.greySettingPage:Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                      onTap: (){
                                        peopleListController.currentIndex = index.obs;
                                        //editPersonController.personIndex = index.obs;
                                        Get.to(()=>EditPerson());
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit,size: 20,color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,),
                                            const SizedBox(width: 2),
                                            Text(App_Localization.of(context).translate('edit'),style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontSize: 15, fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                      )
                                  ),
                                  GestureDetector(
                                      onTap: (){
                                        peopleListController.deletePersonFromTheList(index);
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete,size: 20,color: MyTheme.isDarkTheme.value?Colors.white:Colors.black),
                                            SizedBox(width: 2),
                                            Text(App_Localization.of(context).translate('delete'),style:  TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontSize: 15, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Column(
                                children: [
                                  Divider(thickness: 1,height: 20,indent: 10,endIndent: 10,color: MyTheme.isDarkTheme.value?Colors.white:Colors.black.withOpacity(0.2),),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.85,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(App_Localization.of(context).translate('hid_or_show'),style:  TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontSize: 15, fontWeight: FontWeight.bold)),
                                        Container(
                                          height: 30,
                                          width: MediaQuery.of(context).size.width * 0.1,
                                          child:  Switch(
                                            activeColor: Theme.of(context).primaryColor,
                                            value: peopleListController.myPeopleList[index].availableSwitch.value,
                                            onChanged: (bool value) {
                                              peopleListController.changeAvailability(index);
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.width * 0.2,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).dividerColor,
                                border: Border.all(width: 1,color:Theme.of(context).dividerColor.withOpacity(0.3)),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(Api.url + 'uploads/' + peopleListController.myPeopleList[index].image),
                                )
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(peopleListController.myPeopleList[index].name,style:  TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text(peopleListController.myPeopleList[index].languages,style:  TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black.withOpacity(0.5),fontSize: 13, fontWeight: FontWeight.normal)),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.phone,size: 20,color: Colors.white),
                              ),
                              const SizedBox(width: 10),
                              Text(peopleListController.myPeopleList[index].phone,style:  TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontSize: 15, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }

  _body1(context){
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.95,
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08+45),
            child: Obx((){
              print( peopleListController.myPeopleList.isEmpty);
              return peopleListController.myPeopleList.isEmpty
                  ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.8,
                child: Center(
                  child: Text(
                      App_Localization.of(context).translate('there_are_no_people_at_the_moment'),
                      style: Theme.of(context).textTheme.bodyText2
                  ),
                ),
              )
                  :ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 20),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: peopleListController.myPeopleList.length,
                  itemBuilder:(context, index){
                    return Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            children: [
                              Expanded(
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
                                              image: NetworkImage(Api.url + 'uploads/' +  peopleListController.myPeopleList[index].image),
                                              // colorFilter: ColorFilter.mode(
                                              //   Colors.black.withOpacity(0.4),
                                              //   BlendMode.darken,
                                              // ),
                                            )
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
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
                                          peopleListController.myPeopleList[index].name,
                                          maxLines: 1,
                                          style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontWeight: FontWeight.bold,fontSize: 16),
                                        ),

                                        Text(
                                          peopleListController.myPeopleList[index].languages,
                                          style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 15 ),
                                        ),
                                        Divider(thickness: 1,color: MyTheme.isDarkTheme.value?Colors.white.withOpacity(0.5):Colors.black.withOpacity(0.2),height: 1,),
                                        Container(
                                          // color: Colors.red,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  // color: Theme.of(context).primaryColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(Icons.phone,size: 18,color: App.primary),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(peopleListController.myPeopleList[index].phone,style:  TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontSize: 15, fontWeight: FontWeight.normal)),


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
                              )

                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  // color: Colors.green,
                                  child: Center(
                                      child: Container(
                                        // color: Colors.red,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                                onTap: (){
                                                  peopleListController.currentIndex = index.obs;
                                                  Get.to(()=>EditPerson());
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.edit, color:  MyTheme.isDarkTheme.value?Colors.white:Colors.black,size: 22),
                                                    SizedBox(width: 3),
                                                    Text(App_Localization.of(context).translate('edit'), style: TextStyle(color:  MyTheme.isDarkTheme.value?Colors.white:Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
                                                  ],
                                                )
                                            ),
                                            GestureDetector(
                                                onTap: (){
                                                  peopleListController.deletePersonFromTheList(index);
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.delete, color:  MyTheme.isDarkTheme.value?Colors.white:Colors.black,size: 22),
                                                    SizedBox(width: 3),
                                                    Text(App_Localization.of(context).translate('delete'), style: TextStyle(color:  MyTheme.isDarkTheme.value?Colors.white:Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
                                                  ],
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                  ),
                                ),),
                              Expanded(
                                flex: 3,
                                child: Center(
                                  child: Obx(() => Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Spacer(),
                                      Text(App_Localization.of(context).translate("available"),style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black),),
                                      SizedBox(width: 10,),
                                      SizedBox(
                                        height: 25,
                                        // width: 62,
                                        child: ToggleSwitch(
                                          initialLabelIndex: peopleListController.myPeopleList[index].availableSwitch.value?0:1,
                                          totalSwitches: 2,
                                          labels: [
                                            'Yes',
                                            'No',
                                          ],
                                          animationDuration: 200,
                                          fontSize: 15,
                                          // minWidth: 61,
                                          customWidths: [60,60],
                                          // activeBgColor: [
                                          //   Colors.green,
                                          //   Colors.red
                                          // ],
                                          // activeFgColor:Colors.green,
                                          animate: true,
                                          inactiveBgColor: Colors.grey,
                                          activeBgColors: [[Colors.green],[Colors.red]],
                                          onToggle: (realIndex) {
                                            print('switched to: $index');
                                            peopleListController.changeAvailability(index);
                                            // myCarListController.changeAvailability(index);
                                          },
                                        ),
                                      ),
                                    ],
                                  )),
                                ),)
                            ],
                          ),
                        ),
                        Divider(thickness: 1, indent: 25,endIndent: 25,color: Theme.of(context).dividerColor.withOpacity(0.2),height: 20,),
                      ],
                    );
                  }
              );
            }),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

}
