import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmDialog extends StatelessWidget {


  final double width;
  final double height;
  final String title;
  final String button1Text;
  final VoidCallback button1Pressed;

  final bool openDialog;


  ConfirmDialog({
    required this.width,
    required this.height,
    required this.title,
    required this.button1Text,
    required this.button1Pressed,
    required this.openDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          child: openDialog
          ? Container(
            width: Get.width,
            height: Get.height,
            color: Theme.of(context).dividerColor.withOpacity(0.5),
          )
          : Text(''),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
          width:  Get.width * width,
          height: openDialog ? height : 0,
          decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: Container(
              height: height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Text(
                      title,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).dividerColor,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: button1Pressed,
                    child: Container(
                      width: Get.width * 0.35,
                      height: 40,
                      color: Colors.transparent,
                      child: Center(
                        child: Text(
                            button1Text,
                            style: TextStyle(
                                fontSize: 15
                            )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
