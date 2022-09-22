
import 'package:crc_version_1/helper/global.dart';
import 'package:crc_version_1/model/login_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Store {
  static Future<LoginInfo> Load_login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    LoginInfo loginInfo = LoginInfo(email: "non", pass: "non");
    loginInfo.email=prefs.getString("email")??"non";
    loginInfo.pass=prefs.getString("pass")??"non";
    Global.loginInfo = loginInfo;
    return Global.loginInfo!;

  }

  static Save_login()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", Global.loginInfo!.email);
    prefs.setString("pass", Global.loginInfo!.pass);
  }

  static logout()async{
    Global.company_id=-1;
    Global.company = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("email");
    prefs.remove("pass");
  }

  static saveTheme(bool val)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("light", val);
  }

  static Future<bool> loadTheme()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("light")??true;
  }
}