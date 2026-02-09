import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/polling_title_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/res.dart';

class SuccessScreen extends StatelessWidget {
  final String title;
  final String subTitle;
  final String img;
  final bool enableCloseIconButton;
  final Function? onCloseClicked;

  const SuccessScreen(
      {Key? key,
        required this.title,
        required this.subTitle,
        this.enableCloseIconButton = false,
        this.onCloseClicked,
        required this.img})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (enableCloseIconButton)
          Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
            child: Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  if (onCloseClicked != null) {
                    onCloseClicked!();
                  } else {
                    Get.back();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.4),
                  child: SvgPicture.asset(
                    Res.close_mark_svg,
                    width: 13.15,
                    height: 13.15,
                  ),
                ),
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.viewPaddingOf(context).top),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  PollingTitleWidget(title: title),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    subTitle,
                    style: AppTextStyles.bodySMedium(color: darkBlueColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  SvgPicture.asset(img),
                  SizedBox(
                    height: 20.h,
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