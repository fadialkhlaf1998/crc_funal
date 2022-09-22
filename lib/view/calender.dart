import 'package:crc_version_1/app_localization.dart';
import 'package:crc_version_1/helper/app.dart';
import 'package:crc_version_1/widget/custom_button.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class MyRangeCalender extends StatelessWidget {
  int car_id;
  double hr_price;
  double day_price;
  RxDouble total = 0.0.obs;

  MyRangeCalender(this.car_id, this.hr_price, this.day_price);

  List<String> hrs = [
    "12:00 AM", "12:30 AM",
    "01:00 AM", "01:30 AM",
    "02:00 AM", "02:30 AM",
    "03:00 AM", "03:30 AM",
    "04:00 AM", "04:30 AM",
    "05:00 AM", "05:30 AM",
    "06:00 AM", "06:30 AM",
    "07:00 AM", "07:30 AM",
    "08:00 AM", "08:30 AM",
    "09:00 AM", "09:30 AM",
    "10:00 AM", "10:30 AM",
    "11:00 AM", "11:30 AM",
    "12:00 PM", "12:30 PM",
    "01:00 PM", "01:30 PM",
    "02:00 PM", "02:30 PM",
    "03:00 PM", "03:30 PM",
    "04:00 PM", "04:30 PM",
    "05:00 PM", "05:30 PM",
    "06:00 PM", "06:30 PM",
    "07:00 PM", "07:30 PM",
    "08:00 PM", "08:30 PM",
    "09:00 PM", "09:30 PM",
    "10:00 PM", "10:30 PM",
    "11:00 PM", "11:30 PM",
  ];
  RxString range = "".obs;
  RxBool pickUpValidate = true.obs;
  Rx<String> pickUp ="12:00 AM".obs;
  RxBool dropOffValidate = true.obs;
  Rx<String> dropOff ="12:00 AM".obs;
  void onSelectionDateChanges(var args) {
    if (args.value is PickerDateRange ) {
      range.value = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      print(range.value);
      getTotal(day_price, hr_price);
    } else if (args.value is DateTime) {
      // selectedDate.value = args.value.toString();
    } else if (args.value is List<DateTime>) {
      // dateCount.value = args.value.length.toString();
    } else {
      // rangeCount.value = args.value.length.toString();
    }
  }

  double getTotal(double daily,double hourly){
    double subTotal = 0.0;
    DateTime begin = getDate(range.value.split("-")[0], pickUp.value);
    DateTime end = getDate(range.value.split("-")[1], dropOff.value);
    int comparDays=end.difference(begin).inDays;
    comparDays=comparDays+1;
    print(comparDays);
    int pickIndex = hrs.indexOf(pickUp.value);
    int dropIndex = hrs.indexOf(dropOff.value);

    if(dropIndex - pickIndex > 4 ){
      subTotal = (daily * (comparDays+1)).toDouble();
    }else{
      subTotal = (daily * comparDays).toDouble();
    }
    print(subTotal);
    total.value = subTotal;
    return subTotal;
    // if(selectRentalModel.value == 0){
    //   //daily
    //
    //
    // }else{
    //   int counter = dropIndex - pickIndex ;
    //   if(counter.isOdd) {
    //     subTotal.value = (counter + 1) * car!.hourlyPrice / 2;
    //   }else{
    //     subTotal.value = counter * car!.hourlyPrice / 2;
    //   }
    // }

    // vat.value = subTotal * 5 /100;
    // total.value = subTotal.value + vat.value;
  }
  getDate(String date,String hr){
    int hour = int .parse(hr.split(":")[0]);
    int min = int .parse(hr.split(":")[1].split(" ")[0]);
    String amPm = hr.split(":")[1].split(" ")[1].toLowerCase();
    if(amPm == "pm"){
      hour = hour + 12 ;
    }
    return DateTime(int.parse(date.split("/")[2]),
        int.parse(date.split("/")[1]),
        int.parse(date.split("/")[0]),
        hour,
        min
    );
  }

  submit(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => SafeArea(
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: Get.height,
                    spreadRadius: Get.height
                )
              ]
          ),
          child: Center(
            child: Stack(
              children: [

                Container(width: Get.width,height: Get.height,

                  child: Center(
                    child:  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 360+20+100+20+50+5+50+20,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Container(
                              width: Get.width * 0.9,
                              height: 50,

                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    total.value>0
                                        ?Text(App_Localization.of(context).translate("total")+": "+total.value.toStringAsFixed(2),style: TextStyle(fontWeight: FontWeight.bold),)
                                        :Text("Please select date to calc price",style: TextStyle(fontWeight: FontWeight.bold),)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              width: Get.width * 0.9,
                              height: 310,
                              decoration: BoxDecoration(
                                  color: App.grey,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Column(
                                children: [

                                  SfDateRangePicker(
                                    onSelectionChanged: onSelectionDateChanges,
                                    selectionMode: DateRangePickerSelectionMode.range,
                                    minDate: DateTime.now(),
                                    view: DateRangePickerView.month,
                                    monthViewSettings: DateRangePickerMonthViewSettings(
                                      viewHeaderStyle: DateRangePickerViewHeaderStyle(
                                        textStyle: TextStyle(
                                            color: Colors.white.withOpacity(0.5),
                                            fontSize: 14
                                        ),
                                        backgroundColor: App.lightGrey.withOpacity(0.5),
                                      ),
                                    ),
                                    selectionTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14
                                    ),
                                    monthCellStyle: const DateRangePickerMonthCellStyle(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14
                                      ),
                                      disabledDatesTextStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          decoration: TextDecoration.lineThrough
                                      ),
                                    ),
                                    yearCellStyle: const DateRangePickerYearCellStyle(
                                      disabledDatesTextStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          decoration: TextDecoration.lineThrough
                                      ),
                                      todayTextStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14
                                      ),
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14
                                      ),
                                    ),
                                    rangeSelectionColor: Colors.grey.withOpacity(0.5),
                                    rangeTextStyle: const TextStyle(
                                      color: Colors.white,
                                      // fontSize: CommonTextStyle.smallTextStyle
                                    ),
                                    headerStyle: const DateRangePickerHeaderStyle(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,)
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                                width: Get.width * 0.9,

                                height: 100,
                                decoration: BoxDecoration(
                                    color: App.grey,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: pickUpDropOffTime(context)
                            ),
                            SizedBox(height: 20),
                            GestureDetector(
                              onTap: (){
                                submit();
                              },
                              child: Container(
                                width: Get.width * 0.8,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: App.primary,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Center(
                                  child: Text("Submit",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back_ios))
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
  pickUpDropOffTime(BuildContext context) {
    return Container(
      width: Get.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Center(
                  child: Text("Pick Up",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                width: Get.width * 0.4,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    border: Border.all(
                      color: !pickUpValidate.value && pickUp.value=="non"? Colors.red : App.grey,
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    dropdownMaxHeight: 200,
                    isExpanded: true,
                    dropdownDecoration: BoxDecoration(
                      color: App.grey,
                    ),
                    buttonPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hint: Text("Pick Up",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    iconEnabledColor: Colors.white,
                    value: pickUp.value=="non"? null : pickUp.value,
                    items: hrs.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      );
                    }).toList(),
                    underline: Container(),
                    onChanged: (val) {
                      pickUp.value= val.toString();
                    },
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Center(
                  child: Text("Drop Off",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                width: Get.width * 0.4,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    border: Border.all(
                      color: !dropOffValidate.value && dropOff.value=="non"? Colors.red : App.grey,
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    dropdownMaxHeight: 200,
                    isExpanded: true,
                    dropdownDecoration: BoxDecoration(
                      color: App.grey,
                    ),
                    buttonPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hint: Text("Drop Off",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.normal
                      ),
                    ),
                    iconEnabledColor: Colors.white,
                    value: dropOff.value=="non"? null : dropOff.value,
                    items: hrs.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      );
                    }).toList(),
                    underline: Container(),
                    onChanged: (val) {
                      dropOff.value= val.toString();
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}