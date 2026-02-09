import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import '../../../components/skeletons/skeletons.dart';
import '../../../res.dart';
import '../../theme/app_colors.dart';
import 'my_account_widget_in_drawer_logic.dart';

class MyAccountWidgetInDrawer extends StatefulWidget {
  const MyAccountWidgetInDrawer({Key? key}) : super(key: key);

  @override
  State<MyAccountWidgetInDrawer> createState() =>
      _MyAccountWidgetInDrawerState();
}

class _MyAccountWidgetInDrawerState extends State<MyAccountWidgetInDrawer>
    with AfterLayoutMixin {
  final logic = Get.put(MyAccountWidgetInDrawerLogic());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyAccountWidgetInDrawerLogic>(
      builder: (logic) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: logic.isLoading
              ? _myAccountLoadingSkeleton()
              : _myAccountWidget(),
        );
      },
    );
  }

  SkeletonTheme _myAccountLoadingSkeleton() {
    return SkeletonTheme(
      shimmerGradient: const LinearGradient(
        colors: [
          Colors.grey,
          Colors.white,
          Colors.grey,
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 5,
          ),
          const SkeletonAvatar(
            style: SkeletonAvatarStyle(
              height: 106,
              width: 106,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SkeletonLine(
            style: SkeletonLineStyle(
              alignment: Alignment.center,
              height: 16,
              width: 100,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SkeletonLine(
            style: SkeletonLineStyle(
              alignment: Alignment.center,
              height: 8,
              width: 60,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SkeletonLine(
            style: SkeletonLineStyle(
              alignment: Alignment.center,
              height: 8,
              width: 80,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  Column _myAccountWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF1C478D), width: 1),
              borderRadius: BorderRadius.circular(58),
            ),
            child: SvgPicture.asset(
              Res.profileUser,
              height: 106,
              width: 106,
              colorFilter: const ColorFilter.mode(
                Color(0xff707070),
                BlendMode.srcATop,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          logic.myAccountModel.name,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: navyBlueColor,
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          "***** *${logic.myAccountModel.phoneNumber.substring(6, 10)}",
          style: AppTextStyles.bodyXSRegular(color: secondaryDarkColor),
        ),
        const SizedBox(
          height: 8,
        ),
         Text(
          logic.myAccountModel.email,
          style: AppTextStyles.bodyXSRegular(color: secondaryDarkColor),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.fetchDetails();
  }
}
