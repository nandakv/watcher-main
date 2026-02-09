import 'package:privo/app/common_widgets/blue_button.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PinkErrorDialog extends StatelessWidget {
  String? title;
  String? subtitle;
   PinkErrorDialog({Key? key,this.title,this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              Container(
                width: double.maxFinite,
                height: Get.height * 0.7,
                decoration: BoxDecoration(
                    color: darkPinkDialogColor,
                    borderRadius: BorderRadius.circular(40)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                    alignment: Alignment.bottomCenter,
                    height: Get.height * 0.7,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: pinkishDialogColor,
                        borderRadius: BorderRadius.circular(40)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                                onTap: () => Get.back(),
                                child: SvgPicture.asset(
                                  Res.rounded_clear_icon,
                                  fit: BoxFit.scaleDown,
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Image.asset(Res.error_dialog_illustration),
                           Text(
                            title ?? "Uh oh!",
                            style: const TextStyle(
                              fontSize: 24,
                              color: Color(0xffD11313),
                            ),
                          ),
                           Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                             subtitle ?? "Sorry, we were unable to verify your bank account",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xff4A4B53),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: BlueButton(
                              onPressed: () => Get.back(),
                              buttonColor: activeButtonColor,
                              title: "Try Again",
                            ),
                          )
                        ],
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
