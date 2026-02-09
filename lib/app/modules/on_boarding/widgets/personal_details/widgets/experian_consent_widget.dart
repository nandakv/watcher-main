import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';

class ExperianConsentWidget extends StatelessWidget {
  final String title;
  final String consentInfo;
  final Function() onContinue;
  final Function() onTnCClicked;
  const ExperianConsentWidget(
      {super.key,
      required this.title,
      required this.consentInfo,
      required this.onContinue,
      required this.onTnCClicked});

  Widget _titleWidget() {
    return Text(
      title,
      style: GoogleFonts.poppins(
        color: navyBlueColor,
        fontWeight: FontWeight.w500,
        fontSize: 20,
      ),
    );
  }

  Widget _consentInfoWidget() {
    return Text(
      consentInfo,
      style: const TextStyle(
        fontSize: 12,
        color: secondaryDarkColor,
      ),
    );
  }

  Widget _consentTextWidget() {
    return InkWell(
      onTap: onTnCClicked,
      child: const Text(
        "By clicking on continue, I agree to Experian’s T&C",
        style: TextStyle(
          color: blueColor,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buttonWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 42.0),
      child: GradientButton(
        onPressed: onContinue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
        childPadding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 24,
        ),
        enableCloseIconButton: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleWidget(),
            const VerticalSpacer(8),
            _consentInfoWidget(),
            const VerticalSpacer(24),
            _consentTextWidget(),
            const VerticalSpacer(24),
            _buttonWidget(),
          ],
        ));
  }
}
