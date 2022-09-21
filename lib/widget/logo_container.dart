import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LogoContainer extends StatelessWidget {

  double width;
  double height;
  String logo;


  LogoContainer({
    required this.width,
    required this.height,
    required this.logo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * width,
      height: Get.height * height,
     child: SvgPicture.asset('assets/logo/$logo.svg', fit: BoxFit.contain,),
    );
  }
}
