import 'package:crc_version_1/app_localization.dart';
import 'package:crc_version_1/controller/login_controller.dart';
import 'package:crc_version_1/controller/signup_controller.dart';
import 'package:crc_version_1/helper/app.dart';
import 'package:crc_version_1/helper/myTheme.dart';
import 'package:crc_version_1/view/home.dart';
import 'package:crc_version_1/widget/background_page.dart';
import 'package:crc_version_1/widget/confirm_dialog.dart';
import 'package:crc_version_1/widget/custom_button.dart';
import 'package:crc_version_1/widget/logo_container.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lottie/lottie.dart';
import 'package:intl_phone_field/countries.dart';


class LogIn extends StatelessWidget {

  LoginController loginController = Get.put(LoginController());
  SignUpController signUpController = Get.put(SignUpController());
  final formGlobalKey = GlobalKey<FormState>();
  final formGlobalKey2 = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: SafeArea(
        child: Obx((){
          return Stack(
            children: [
              BackgroundPage(),
              SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: loginController.loading.value ?
                  Container(
                    child: Lottie.asset('assets/images/Animation.json'),
                  )
                      : Container(
                        height: Get.height - (MediaQuery.of(context).padding.bottom + MediaQuery.of(context).padding.top),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            
                            Container(
                                height: Get.height * 0.3,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                    child: LogoContainer(width: 0.9, height: 0.14, logo: 'logo_orange'))),
                            Container(
                              // height: Get.height * 0.6,
                              child: AnimatedSwitcher(
                                transitionBuilder: (Widget child, Animation<double> animation) {
                                  return ScaleTransition(scale: animation, child: child);
                                },
                                duration: const Duration(milliseconds: 250),
                                child: !loginController.sign_up_option.value ? _signInSection(context) :  _signUpOptions(context),
                              ),
                            ),
                           // Container(
                           //   padding: EdgeInsets.only(bottom: 20, top: 10),
                           //   child: AnimatedSwitcher(
                           //     duration: Duration(milliseconds: 300),
                           //     child:  loginController.sign_up_option.value
                           //           ? GestureDetector(
                           //         onTap: (){
                           //           loginController.sign_up_option.value  = false;
                           //         },
                           //         child: Text('Return to login',style: TextStyle(fontSize: 14, color: Colors.white)),
                           //       )
                           //           : Text('Only for Car Rental Company',style: TextStyle(fontSize: 12, color: Colors.white)),
                           //   )
                           // )
                          ],
                  ),
                      )
                ),
              ),
              ConfirmDialog(
                  width: 0.8,
                  height: 400,
                  title: App_Localization.of(context).translate('successfully_register'),
                  button1Pressed: (){
                    signUpController.checkOpenDialog.value = false;
                  },
                  button1Text: 'Done',
                  openDialog: signUpController.checkOpenDialog.value
              )
            ],
          );
        }),
      ),
    );
  }
  _signInSection(context){
    return Form(
      key: formGlobalKey,
      child: Container(
        child: Column(
          children: [
            Container(
             width: MediaQuery.of(context).size.width * 0.9,
              child: TextFormField(
                style: Theme.of(context).textTheme.headline3,
                controller: loginController.username,
                validator: (email) {
                  if (email!.isEmpty) {
                    return App_Localization.of(context).translate('username_cannot_be_empty');
                  }
                  return null;
                },
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
                  prefixIcon:
                  Icon(Icons.person, color: Theme.of(context).primaryColor),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1, color:Theme.of(context).dividerColor),
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 1, color:Theme.of(context).dividerColor)
                  ),
                  labelStyle: Theme.of(context).textTheme.bodyText2,
                  labelText: App_Localization.of(context).translate('username'),
                  hintText: App_Localization.of(context).translate('enter_your_username'),
                  hintStyle: Theme.of(context).textTheme.headline4,
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextFormField(
                  style: Theme.of(context).textTheme.headline3,
                  obscureText: !loginController.showPassword.value ? true : false,
                  obscuringCharacter: '*',
                  controller: loginController.password,
                  validator: (pass) {
                    if(pass!.isEmpty){
                      return App_Localization.of(context).translate('password_empty');
                    }
                    else if (pass.length < 6) {
                      return App_Localization.of(context).translate('password_length');
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    errorStyle: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
                    prefixIcon:
                    Icon(Icons.vpn_key, color: Theme.of(context).primaryColor),
                    suffixIcon: !loginController.showPassword.value
                            ? GestureDetector(
                          onTap: (){
                            loginController.showPassword.value = !loginController.showPassword.value;
                          },
                            child: Icon(Icons.visibility_outlined, color: App.grey))
                            : GestureDetector(
                             onTap: (){
                               loginController.showPassword.value = !loginController.showPassword.value;
                          },
                               child:  Icon(Icons.visibility_off_outlined, color: App.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 1, color:Theme.of(context).dividerColor),
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 1, color:Theme.of(context).dividerColor)
                    ),
                    labelStyle:Theme.of(context).textTheme.bodyText2,
                    labelText: App_Localization.of(context).translate('password'),
                    hintText: App_Localization.of(context).translate('enter_your_password'),
                    hintStyle: Theme.of(context).textTheme.headline4,
                  ),
                  keyboardType: TextInputType.visiblePassword),
            ),
            const SizedBox(height: 50),
            CustomButton(
                width: 0.9, height: 55, text:  App_Localization.of(context).translate('login'),
                onPressed: () async {
                  if(formGlobalKey.currentState!.validate()){
                    loginController.submite(context);
                  }else{
                    print('false');
                  }
                },
                color: App.grey,
                borderRadius: 5,
                borderColor: Colors.white,
                borderWidth: 1,
                border: false,
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            CustomButton(
              width: 0.9,
              height: 55,
              text: App_Localization.of(context).translate('register'),
              onPressed: () async {
                loginController.sign_up_option.value = true;
              },
              color: App.primary,
              borderRadius: 5,
              borderColor: Colors.white,
              borderWidth: 1,
              border: false,
              textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            CustomButton(
              width: 0.9,
              height: 55,
              text: App_Localization.of(context).translate('visit_as_guest'),
              onPressed: () async {
                Get.offAll(()=>Home());

              },
              color: Theme.of(context).dividerColor,
              borderRadius: 5,
              borderColor: Colors.white,
              borderWidth: 1,
              border: false,
              textStyle: TextStyle(
                  color: Theme.of(context).backgroundColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

          ],
        ),
      ),
    );
  }

  _signUpOptions(context){
    return Form(
      key: formGlobalKey2,
      child: Container(
        // height: MediaQuery.of(context).size.height * 0.2,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextFormField(
                style: Theme.of(context).textTheme.headline3,
                controller: signUpController.companyName,
                validator: (email) {
                  if (email!.isEmpty) {
                    // return App_Localization.of(context).translate('company_name_cannot_be_empty');
                    return "";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1, color:Theme.of(context).dividerColor),
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 1, color:Theme.of(context).dividerColor)
                  ),
                  labelStyle: Theme.of(context).textTheme.bodyText2,
                  labelText: App_Localization.of(context).translate('company_name'),
                  // hintText: App_Localization.of(context).translate('company_name'),
                  // hintStyle: Theme.of(context).textTheme.headline4,
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            const SizedBox(height: 25),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextFormField(
                style: Theme.of(context).textTheme.headline3,
                controller: signUpController.contactPersonPhone,
                validator: (contactPersonPhone) {
                  if (contactPersonPhone!.isEmpty) {
                    return "";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1, color:Theme.of(context).dividerColor),
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 1, color:Theme.of(context).dividerColor)
                  ),
                  labelStyle: Theme.of(context).textTheme.bodyText2,
                  labelText: App_Localization.of(context).translate('enter_contact_person_number'),
                  // hintText: App_Localization.of(context).translate('company_name'),
                  // hintStyle: Theme.of(context).textTheme.headline4,
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            // Container(
            //     width: Get.width * 0.9,
            //     child: IntlPhoneField(
            //       style: TextStyle(color: Theme.of(context).dividerColor),
            //       controller: signUpController.contactPersonPhone,
            //       cursorColor: Colors.white,
            //       keyboardType: TextInputType.number,
            //       decoration: InputDecoration(
            //         errorStyle: const TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
            //         hintText: App_Localization.of(context).translate('enter_contact_person_number'),
            //         hintStyle:  TextStyle(
            //             color: App.grey,
            //             fontSize: 14
            //         ),
            //
            //         focusedBorder: UnderlineInputBorder(
            //           borderSide: BorderSide(color: signUpController.validateContactNumber.value ?  Colors.red : Theme.of(context).dividerColor.withOpacity(0.5))
            //         ),
            //         border: UnderlineInputBorder(
            //             borderSide: BorderSide(color: signUpController.validateContactNumber.value ?  Colors.red : Theme.of(context).dividerColor.withOpacity(0.5))
            //         ),
            //         enabledBorder: UnderlineInputBorder(
            //             borderSide: BorderSide(color: signUpController.validateContactNumber.value ?  Colors.red : Theme.of(context).dividerColor.withOpacity(0.5))
            //         ),
            //       ),
            //       initialCountryCode: 'AE',
            //       disableLengthCheck: true,
            //       dropdownIcon: Icon(Icons.arrow_drop_down_outlined,color:  Theme.of(context).dividerColor.withOpacity(0.5)),
            //       dropdownTextStyle: TextStyle(
            //           color: Colors.white,
            //           fontSize: 14
            //       ),
            //       flagsButtonMargin: const EdgeInsets.symmetric(horizontal: 10),
            //       showDropdownIcon: true,
            //       dropdownIconPosition: IconPosition.trailing,
            //       onChanged: (phone) {
            //         int max = countries.firstWhere((element) => element.code == phone.countryISOCode).maxLength;
            //         if(signUpController.contactPersonPhone.text.length > max){
            //           signUpController.contactPersonPhone.text = signUpController.contactPersonPhone.text.substring(0,max);
            //         }
            //         signUpController.contactPhoneCode.value = phone.countryCode;
            //       },
            //     ),
            // ),
            const SizedBox(height: 25),
            Container(
              width: Get.width * 0.9,
              child: IntlPhoneField(
                style: TextStyle(color: Theme.of(context).dividerColor),
                controller: signUpController.phoneNumber,
                cursorColor: Colors.white,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
                  hintText: App_Localization.of(context).translate('enter_phone_number'),
                  hintStyle:  TextStyle(
                      color: App.grey,
                      fontSize: 14
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: signUpController.validatePhone.value ?  Colors.red : Theme.of(context).dividerColor.withOpacity(0.5))
                  ),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: signUpController.validatePhone.value ?  Colors.red : Theme.of(context).dividerColor.withOpacity(0.5))
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: signUpController.validatePhone.value ?  Colors.red : Theme.of(context).dividerColor.withOpacity(0.5))
                  ),
                ),
                initialCountryCode: 'AE',
                disableLengthCheck: true,
                dropdownIcon: Icon(Icons.arrow_drop_down_outlined,color:  Theme.of(context).dividerColor.withOpacity(0.5)),
                dropdownTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14
                ),
                flagsButtonMargin: const EdgeInsets.symmetric(horizontal: 10),
                showDropdownIcon: true,
                dropdownIconPosition: IconPosition.trailing,
                onChanged: (phone) {
                  int max = countries.firstWhere((element) => element.code == phone.countryISOCode).maxLength;
                  if(signUpController.phoneNumber.text.length > max){
                    signUpController.phoneNumber.text = signUpController.phoneNumber.text.substring(0,max);
                  }
                  signUpController.phoneCode.value = phone.countryCode;
                },
              ),
            ),
            const SizedBox(height: 25),
            Container(
              width: Get.width * 0.9,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.transparent,
                  border: Border(
                    bottom: BorderSide(color: signUpController.pickUpValidate.value && signUpController.pickEmirate.value=="non"? Colors.red : App.grey,)
                  ),

              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  dropdownMaxHeight: 200,
                  isExpanded: true,
                  iconSize: 23,
                  dropdownDecoration: BoxDecoration(
                    color: App.grey,
                  ),
                  buttonPadding: const EdgeInsets.symmetric(horizontal: 10),
                  hint: Text(App_Localization.of(context).translate("emirates"),
                    style: TextStyle(
                        color: Theme.of(context).dividerColor,
                        fontSize: 14,
                        fontWeight: FontWeight.normal
                    ),
                  ),
                  iconEnabledColor: App.lightGrey,
                  value: signUpController.pickEmirate.value=="non"? null : signUpController.pickEmirate.value,
                  items: signUpController.pickUpEmirates.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                        style: TextStyle(
                            color: Theme.of(context).dividerColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                        ),
                      ),
                    );
                  }).toList(),
                  underline: Container(),
                  onChanged: (val) {
                    signUpController.pickEmirate.value = val.toString();
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            CustomButton(
                width: 0.9, height: 55,
                text: App_Localization.of(context).translate('register'),
              onPressed: () async {
                if(formGlobalKey2.currentState!.validate()){
                }else{
                  print('false');
                }
                signUpController.register(context);
              },
                color: App.primary,
                borderRadius: 5, borderColor: Colors.white, borderWidth: 1, border: false,
              textStyle: TextStyle(
                  color: Theme.of(context).dividerColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: (){
                loginController.sign_up_option.value  = false;
              },
              child:             Text(App_Localization.of(context).translate("login"),style: TextStyle(color: MyTheme.isDarkTheme.value?Colors.white:Colors.black,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
            )
            //
          ],
        ),
      ),
    );
  }

}