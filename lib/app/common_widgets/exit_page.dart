import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/having_trouble_widget.dart';
import 'package:privo/app/common_widgets/privo_button.dart';
import 'package:privo/app/common_widgets/rejection_details_bottom_sheet.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/app_form_rejection_model.dart';
import 'package:privo/app/modules/home_screen_module/widgets/offer_zone_section/top_up_offer_rejection_screen.dart';
import 'package:privo/app/modules/on_boarding/on_boarding_logic.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:privo/app/utils/web_engage_constant.dart';
import 'package:privo/res.dart';

class ExitPage extends StatelessWidget {
  ExitPage({
    Key? key,
    required this.assetImage,
    this.showButton = true,
  }) : super(key: key);

  final String assetImage;
  final bool? showButton;

  final logic = Get.find<OnBoardingLogic>();

  @override
  Widget build(BuildContext context) {
    return LPCService.instance.isLpcCardTopUp
        ? const TopUpOfferRejectionScreen()
        : SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: SvgPicture.asset(Res.close_mark_svg),
                  ),
                ),
                _computeRejectionScreens(),
                const Spacer(),
                HavingTroubleWidget(
                  screenName: 'REJECTION_SCREEN',
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
  }

  Widget _computeRejectionScreens() {
    switch (logic.appFormRejectionModel.rejectionType) {
      case RejectionType.location:
      case RejectionType.kyc:
      case RejectionType.panCard:
        return _rejectionScreen();
      case RejectionType.general:
        return _rejectionScreenForCommonRejectionType();
    }
  }

  Widget _rejectionScreen() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                logic.appFormRejectionModel.rejectionType.title,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: navyBlueColor,
                ),
                textAlign: TextAlign.center,
              ),
              const VerticalSpacer(16),
              Text(
                logic.appFormRejectionModel.rejectionType.message,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: darkBlueColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const VerticalSpacer(16),
        Align(
          alignment: _computeIllustrationAlignment(),
          child: SvgPicture.asset(
            logic.appFormRejectionModel.rejectionType.image,
          ),
        ),
      ],
    );
  }

  Alignment _computeIllustrationAlignment() {
    return logic.appFormRejectionModel.rejectionType == RejectionType.location
        ? Alignment.center
        : Alignment.centerRight;
  }

  Widget _rejectionScreenForCommonRejectionType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(Res.generalRejectionSVG),
        const VerticalSpacer(16),
        Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                logic.appFormRejectionModel.rejectionType.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: navyBlueColor,
                ),
              ),
              const VerticalSpacer(16),
              Text(
                logic.appFormRejectionModel.rejectionType.message,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: darkBlueColor,
                ),
                textAlign: TextAlign.center,
              ),
              const VerticalSpacer(30),
              GradientButton(
                edgeInsets: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 8,
                ),
                fillWidth: false,
                onPressed: () {
                  AppAnalytics.trackWebEngageEventWithAttribute(
                    eventName: WebEngageConstants.knowWhyPopped,
                  );
                  Get.bottomSheet(
                    RejectionDetailsBottomSheet(),
                    isDismissible: false,
                  );
                },
                title: "Know Why",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
