import 'package:crc_version_1/helper/myTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BackgroundPage extends StatelessWidget {
  const BackgroundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      child: MyTheme.isDarkTheme.value
          ? Image.asset('assets/background/dark_background.jpg', fit: BoxFit.cover)
          : Image.asset('assets/background/light_background.jpg', fit: BoxFit.cover)
    );
  }
}
