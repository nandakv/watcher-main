import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../../../common_widgets/bottom_sheet_widget.dart';
import 'kyc_steps_status_widget.dart';

class AadhaarStepInfoBottomSheet extends StatelessWidget {
  const AadhaarStepInfoBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      childPadding:
          const EdgeInsets.only(left: 32, right: 32, bottom: 32, top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Complete your KYC",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: darkBlueColor),
          ),
          verticalSpacer(24),
          KycStepsStatusWidget(
            kycStepperLocation: KycStepperLocation.bottomSheet,
          ),
        ],
      ),
    );
  }
}
