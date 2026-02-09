import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/fin_sights/fin_sights_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/utils/text_styles.dart';
import 'package:privo/res.dart';

class FinsightsFailureBottomSheet extends StatelessWidget {
  const FinsightsFailureBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      enableCloseIconButton: false,
      childPadding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 48,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(Res.alertRedSVG),
          const VerticalSpacer(16),
          const Text(
            "Oops! Something went wrong",
            textAlign: TextAlign.center,
          ).headingSMedium(
            color: darkBlueColor,
          ),
          const VerticalSpacer(16),
          const Text(
            "We are having trouble loading the data. Please try again in some time",
            textAlign: TextAlign.center,
          ).bodySRegular(
            color: secondaryDarkColor,
          ),
          const VerticalSpacer(48),
          GradientButton(
            onPressed: () => Get.back(result: true),
            title: "Try again",
            fillWidth: false,
            edgeInsets: const EdgeInsets.symmetric(
              horizontal: 48,
              vertical: 15,
            ),
          ),
          const VerticalSpacer(14),
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Go to homepage"),
          ),
        ],
      ),
    );
  }
}
