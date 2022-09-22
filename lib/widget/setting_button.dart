import 'package:crc_version_1/app_localization.dart';
import 'package:flutter/material.dart';

class SettingButton extends StatelessWidget {

  VoidCallback onTap;
  String text;


  SettingButton({
    required this.onTap,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width * 0.9,
            height: 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(App_Localization.of(context).translate(text), style: Theme.of(context).textTheme.bodyText1,),
                const Icon(Icons.arrow_forward_ios, size: 20),
              ],
            ),
          ),
        ),
        Divider(thickness: 1, indent: 25,endIndent: 25,color: Theme.of(context).dividerColor.withOpacity(0.3),),
      ],
    );
  }
}
