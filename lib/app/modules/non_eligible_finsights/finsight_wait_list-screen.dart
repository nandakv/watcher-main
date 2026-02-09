import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import '../../../components/button.dart';
import '../home_screen_module/home_screen_logic.dart';
import 'non_eligible_finsights_logic.dart';

class FinSightWaitListScreen extends StatefulWidget {
  const FinSightWaitListScreen({super.key});

  @override
  State<FinSightWaitListScreen> createState() => _FinSightWaitListScreenState();
}

class _FinSightWaitListScreenState extends State<FinSightWaitListScreen> {
  FinSightWaitListType waitListItem = FinSightWaitListType.waitListView;

  final logic = Get.find<HomeScreenLogic>();
  @override
  void initState() {
    var arguments = Get.arguments;
    if (arguments['waitlist'] != null) {
      waitListItem = arguments['waitlist'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                top: 34.h, bottom: 24.h, left: 28.w, right: 28.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    VerticalSpacer(30.h),
                    Text(
                      waitListItem.title,
                      style: AppTextStyles.headingMSemiBold(
                          color: appBarTitleColor),
                    ),
                    VerticalSpacer(12.h),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        waitListItem.subTitle,
                        style: AppTextStyles.bodySRegular(color: darkBlueColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SvgPicture.asset(
                  waitListItem.image,
                ),
                GetBuilder<HomeScreenLogic>(
                    id:"waiting_button",
                    builder: (logic) {
                      return Button(
                        isLoading: logic.isLoading,
                        buttonType: ButtonType.primary,
                        buttonSize: ButtonSize.large,
                        title: waitListItem.buttonTitle,
                        onPressed: () {
                          logic.onWaitListButtonTap(waitListItem.buttonTitle);
                        },
                        fillWidth: true,
                      );
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
