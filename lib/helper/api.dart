import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crc_version_1/model/car.dart';
import 'package:crc_version_1/model/company.dart';
import 'package:crc_version_1/model/intro.dart';
import 'package:crc_version_1/model/my_car.dart';
import 'package:crc_version_1/model/person_for_company.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class Api {

  static String url = "https://www.carrentalclub.ae/";
  static String imageUrl = "https://www.carrentalclub.ae/uploads/";

  static Future<bool> check_internet()async{
    // return false;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      return true;
    }else{
      return false;
    }

  }

  static Future<Intro> get_data()async{
   
    var request = http.Request('GET', Uri.parse(url+'api/start_up'));
    
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var jsondata = await response.stream.bytesToString();
      return Intro.fromJson(jsonDecode(jsondata));
    }
    else {
      print('-*********************-');
      print(response.reasonPhrase);
    return Intro(brands: <Brands>[], colors: <Colors>[]);
    }

  }

  static Future<Company> login(String username,String password)async{
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse(url+'api/login_company'));
    request.body = json.encode({
      "username": username,
      "pass": password
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonData = await response.stream.bytesToString();
      var data = jsonDecode(jsonData) as List;
      return Company.fromJson(data[0]);
    }
    else {
      return Company(id: -1, username: '', password: '', profileImage: '', coverImage: '', title: '',customerOrders: Orders(rejected: [], pending: [], accepted: []),myOrders: Orders(rejected: [], pending: [], accepted: []));
    }
  }

  static Future register(String companyName, String contactPhone, String contactPhoneCode, String phone, String phoneCode, String emirate) async {
    var headers= {
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse(url + 'api/register-request'));
    request.body = json.encode({
      "company_name": companyName,
      "contact_phone": contactPhone,
      "contact_phone_code": contactPhoneCode,
      "phone": phone,
      "phone_code": phoneCode,
      "emirate": emirate,
      "area": ""
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }

  static Future<List<Car>> filter(String year,String brand, String model, String color, String price, String sort ) async{
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse(url + 'api/car_filter'));
    request.body = json.encode({
      "year": year,
      "brand": brand,
      "model": model,
      "color": color,
      "price": price,
      "sort": sort
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsondata = await response.stream.bytesToString();
      var list = jsonDecode(jsondata) as List;
      List<Car> cars = <Car>[];
      for(var c in list){
        cars.add(Car.fromMap(c));
      }
      return cars;
    }
    else {
     return <Car>[];
    }

  }

  static Future addPerson(String name,File image, String phone, String languages, double companyId)async{

    var request = http.MultipartRequest('POST', Uri.parse(url + 'api/contact_person'));
    request.fields.addAll({
      'name': name,
      'phone': phone,
      'languages': languages,
      'company_id': companyId.toString()
    });
    request.files.add(await http.MultipartFile.fromPath('file',image.path));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('Success');
    }
    else {
      print('Error');
    }

  }

  static Future addCar(String brand,String brandId, String model,String modelId,String year, String color,String location, List<File> images, String price,double companyId,String price_per_month) async{
    var request = http.MultipartRequest('POST', Uri.parse(url + 'api/car'));
    request.fields.addAll({
      'title': brand + ' - ' + model,
      'search': brand + ' - ' + model,
      'avilable': '1',
      'company_id': companyId.toString(),
      'brand_id': brandId,
      'pric_per_day': price,
      'doors': '4',
      'passengers': '4',
      'location': location,
      'color': color,
      'model_id': modelId,
      'year': year,
      'price_per_month' : price_per_month,
      'price_per_hour' : price_per_month
    });

    for (int i = 0; i < images.length; i++) {
      request.files.add(await http.MultipartFile.fromPath('files', images[i].path));
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('Success');
    }
    else {
      print('Field');
    }

  }

  static Future<List<MyCar>> getMyCarsList(int companyId)async{
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse(url + 'api/car_for_company'));
    request.body = json.encode({
      "company_id": companyId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsondata = await response.stream.bytesToString();
      var list = jsonDecode(jsondata) as List;
      List<MyCar> myCars = <MyCar>[];
      for(var c in list){
        myCars.add(MyCar.fromMap(c));
      }
      return myCars;
    }
    else {
      return <MyCar>[];
    }
  }

  static Future <List<PersonForCompany>> getPeopleList(int companyId)async{
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse(url + 'api/contact_person_for_company_without_availbilty'));
    request.body = json.encode({
      "company_id": companyId.toString()
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsondata = await response.stream.bytesToString();
      var list = jsonDecode(jsondata) as List;
      List<PersonForCompany> personsList = <PersonForCompany>[];
      for(var c in list){
        personsList.add(PersonForCompany.fromMap(c));
      }
      return personsList;
    }
    else {
      return <PersonForCompany>[];
    }

  }

  static Future deleteCar(int id)async {
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('DELETE', Uri.parse(url + 'api/car'));
    request.body = json.encode({
      "id": id.toString()
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('Success');
      return true;
    }
    else {
      print('Field');
      return false;
    }

  }

  static Future deletePerson(int id)async{
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('DELETE', Uri.parse(url + 'api/contact_person'));
    request.body = json.encode({
      "id": id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('Success');
      return true;
    }
    else {
      return false;
    }


  }

  static Future changeCarAvailability(String availability,int carId)async{
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse(url + 'api/update_avaliblity'));
    request.body = json.encode({
      "avilable": availability,
      "id": carId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('Success');
    }
    else {
      print('Field');
    }

  }

  static Future <List<PersonForCompany>> getCompanyContactInfo(int id)async{
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse(url + 'api/contact_person_for_company'));
    request.body = json.encode({
      "company_id": id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsondata = await response.stream.bytesToString();
      var list = jsonDecode(jsondata) as List;
      List<PersonForCompany> personsList = <PersonForCompany>[];
      for(var c in list){
        personsList.add(PersonForCompany.fromMap(c));
      }
      return personsList;
    }
    else {
      return <PersonForCompany>[];
    }

  }

  static Future<Car?> getCarInfo(int id)async {
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse(url + 'api/car_info'));
    request.body = json.encode({
      "id": id
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String data = (await response.stream.bytesToString());
      print(data);
      var jsonData  = jsonDecode(data) ;
      return Car.fromMap(jsonData);
    }
    else {
      return null;
    }

  }

  static Future updateCarInfo(String brand,String brandId, String model,String modelId,String year, String color,String location, List<File> images,List<File> newImagesList, String price,double companyId, String carId,String avilable,String pricePerMonth)async{
    var request = http.MultipartRequest('PUT', Uri.parse(url + 'api/car'));
    request.fields.addAll({
      'title': brand + ' - ' + model,
      'search': brand + ' - ' + model,
      'avilable': avilable,
      'company_id': companyId.toString(),
      'brand_id': brandId,
      'pric_per_day': price,
      'doors': '4',
      'passengers': '4',
      'location': location,
      'color': color,
      'model_id': modelId,
      'year': year,
      'id': carId,
      'price_per_month' : pricePerMonth
    });

    for (int i = 0; i < images.length; i++) {
      File f = await _fileFromImageUrl(url + "uploads/" + images[i].path);
      request.files.add(await http.MultipartFile.fromPath('files', f.path));
    }

    for(int i = 0; i < newImagesList.length; i++){
      request.files.add(await http.MultipartFile.fromPath('files', newImagesList[i].path));
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return true;
    }
    else {
      return false;
    }

  }

  static Future<File> _fileFromImageUrl(String path) async {
    final response = await http.get(Uri.parse(path));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File(join(documentDirectory.path, DateTime.now().millisecondsSinceEpoch.toString()+'.png'));
    file.writeAsBytesSync(response.bodyBytes);
    return file;
  }

  static Future changePersonAvailability(int available , int companyId , int id) async{
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse(url+'api/contact_person_avilable'));
    request.body = json.encode({
      "avilable": available,
      "id": id,
      "company_id": companyId,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsondata = await response.stream.bytesToString();
      return true;
    }
    else {
      return false;
    }
  }

  static Future updatePersonInformation(String name, String phone,String languages, String companyId,String id,File personImage,checkImageStatus)async{

    var request = http.MultipartRequest('PUT', Uri.parse(url + 'api/contact_person'));
    request.fields.addAll({
      'name': name,
      'phone': phone,
      'languages': languages,
      'company_id': companyId,
      'id': id
    });

    if(checkImageStatus == 1){
      print('-------------- \nUpload image from gallery \n-------------');
      request.files.add(await http.MultipartFile.fromPath('file', personImage.path));
    }else if (checkImageStatus == 2){
      print('-------------- \nUpload image from assets / No photo /  \n-------------');
      final byteData = await rootBundle.load(personImage.path);
      final file = File('${(await getTemporaryDirectory()).path}/profile_picture.png');
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
    }else{
      print('-------------- \n the same photo / no change happen/ \n-------------');
      File f = await _fileFromImageUrl(url + "uploads/" + personImage.path);
      request.files.add(await http.MultipartFile.fromPath('file', f.path));
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('Successfully update');
      return true;
    }
    else {
      print(response.reasonPhrase);
      print('Failed');
      return false;
    }

  }

  static Future updateCompanyImage(String companyId,String image)async{

    var request = http.MultipartRequest('PUT', Uri.parse(url + 'api/company_image'));
    request.fields.addAll({
      'company_id': companyId
    });
    request.files.add(await http.MultipartFile.fromPath('file',image));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return true;
    }
    else {
      return false;
    }

  }

  static Future tracker(String fromCompanyId, String toCompanyId)async{
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse(url + 'api/tracker'));
    request.body = json.encode({
      "_to": toCompanyId,
      "_from": fromCompanyId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('Success');
      return true;
    }
    else {
      print('Field');
      return false;
    }

  }


  static Future<bool> orderState(int state , int id)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('PUT', Uri.parse(url+'api/order'));
    request.body = json.encode({
      "state": state,
      "id": id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
    print(response.reasonPhrase);
    return false;
    }

  }


  static Future<bool> addOrder(DateTime from,DateTime to, int from_company,int to_company,int car_id,double total)async{
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'connect.sid=s%3AtbiStyqTq9XZ7-XDXcxL0sULphBSCZUl.mQeHm%2FVsmfYK1J4cYZ4bfnLT%2BbOzYLfIIM0u1VfOkQM'
    };
    //"2020/08/14 4:50"
    var request = http.Request('POST', Uri.parse('https://www.carrentalclub.ae/api/order'));
    request.body = json.encode({
      "_from": from.toString(),
      "_to": to.toString(),
      "from_compnay": from_company,
      "to_company": to_company,
      "car_id": car_id,
      "total": total
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
    print(response.reasonPhrase);
    return false;
    }

  }
}