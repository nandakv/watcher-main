import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import '../theme/app_colors.dart';
import 'gradient_button.dart';

class SkipBottomSheet extends StatelessWidget {
  String title;
  String subTitle;
  Function? onTapSkipYes;

  SkipBottomSheet(
      {super.key,
      required this.title,
      required this.subTitle,
      this.onTapSkipYes,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: _titleTextStyle(),
            ),
            verticalSpacer(12),
            Text(
              subTitle,
              textAlign: TextAlign.center,
              style: subTitleTextStyle(),
            ),
            verticalSpacer(30),
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(width: 1, color: navyBlueColor),
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        )
                    ),
                    child:  const Text("No",style:TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: navyBlueColor,
                        fontFamily: 'Figtree'),),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 2,
                  child: GradientButton(
                      title: "Yes",
                      onPressed: () {
                        onTapSkipYes!();
                      },
                  ),

                ),
              ],
            ),
            verticalSpacer(30),
          ],
        ),
      ),
    );
  }

  TextStyle subTitleTextStyle() {
    return const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: primaryDarkColor,
        fontFamily: 'Figtree');
  }

  TextStyle _titleTextStyle() {
    return const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryDarkColor,
        fontFamily: 'Figtree');
  }
}
