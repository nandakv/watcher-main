import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/having_trouble_widget.dart';
import 'package:privo/app/common_widgets/privo_button.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/res.dart';
import '../../components/button.dart';
import '../firebase/analytics.dart';
import '../services/lpc_service.dart';
import '../utils/multi_lpc_faq.dart';
import '../utils/web_engage_constant.dart';

class FailurePage extends StatelessWidget {
  final String title;
  final String message;
  final String illustration;
  final String ctaTitle;
  final Function() onCtaClicked;
  final bool isSkip;
  final Function? onSkipClicked;
  final Function()? onBackClicked;
  final Widget? bottomWidget;
  final bool enableContactCTA;
  final bool showV2ContactDetails;

  const FailurePage({
    Key? key,
    required this.title,
    required this.message,
    required this.illustration,
    required this.ctaTitle,
    required this.onCtaClicked,
    this.isSkip = false,
    this.onSkipClicked,
    this.onBackClicked,
    this.bottomWidget,
    this.enableContactCTA = false,
    this.showV2ContactDetails = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.viewPaddingOf(context).top),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _appBar(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Column(
                children: [
                  const Spacer(),
                  SvgPicture.asset(illustration),
                  VerticalSpacer(52.h),
                  _titleText(),
                  VerticalSpacer(14.h),
                  _messageText(),
                  VerticalSpacer(32.h),
                  if (!isSkip) _ctaButton(),
                  const Spacer(flex: 7),
                  if (bottomWidget != null) bottomWidget!,
                  if (enableContactCTA) ...[
                    HavingTroubleWidget(
                      screenName: '',
                      showV2ContactDetails: showV2ContactDetails,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isSkip) buildSkipAndCTA()
        ],
      ),
    );
  }

  Column buildSkipAndCTA() {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 56.0.w),
            child: Button(
              buttonType: ButtonType.primary,
              buttonSize: ButtonSize.large,
              title: ctaTitle,
              onPressed: onCtaClicked,
              fillWidth: true,
            )),
        verticalSpacer(8.h),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 56.0.w),
            child: Button(
              buttonType: ButtonType.secondary,
              buttonSize: ButtonSize.large,
              title: "Skip for now",
              onPressed: () {
                onSkipClicked!();
              },
              fillWidth: true,
            )),
        verticalSpacer(20.h)
      ],
    );
  }

  Widget _appBar() {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: onBackClicked ??
                () {
                  Get.back();
                  if (isSkip) {
                    AppAnalytics.trackWebEngageEventWithAttribute(
                        eventName: WebEngageConstants.udyamScreenClosed,
                        attributeName: {"Document_Retrieved": "No"});
                  }
                },
            icon: SvgPicture.asset(Res.close_mark_svg),
          ),
        ],
      ),
    );
  }

  Text _messageText() {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: AppTextStyles.bodySMedium(color: darkBlueColor),
    );
  }

  Text _titleText() {
    return Text(title,
        textAlign: TextAlign.center,
        style: AppTextStyles.headingMSemiBold(color: navyBlueColor));
  }

  Widget _ctaButton() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 56.0.w),
        child: Button(
          buttonType: ButtonType.primary,
          buttonSize: ButtonSize.medium,
          title: ctaTitle,
          onPressed: onCtaClicked,
          fillWidth: true,
        ));
  }

  Widget _helpButton() {
    return InkWell(
      onTap: () {
        MultiLPCFaq(lpcCard: LPCService.instance.activeCard)
            .openMultiLPCBottomSheet(
          onPressContinue: () {},
        );
      },
      child: SvgPicture.asset(Res.helpAppBar),
    );
  }
}
