import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';

import '../../../../res.dart';
import '../../../common_widgets/bottom_sheet_widget.dart';
import '../../../common_widgets/vertical_spacer.dart';
import '../../../theme/app_colors.dart';

class WithdrawalBlockingWidget extends StatelessWidget {
  final String title;
  final String message;
  final Function()? onOKPressed;

  const WithdrawalBlockingWidget({
    Key? key,
    required this.title,
    required this.message,
    this.onOKPressed,
  }) : super(key: key);

  Widget _titleWidget() {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: darkBlueColor,
      ),
    );
  }

  Widget _messageTextWidget() {
    return Expanded(
      child: Text(
        message,
        style: GoogleFonts.poppins(
          fontSize: 10,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _messageWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: offWhiteColor,
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SvgPicture.asset(Res.danger),
          const SizedBox(
            width: 12,
          ),
          _messageTextWidget(),
        ],
      ),
    );
  }

  Widget _ctaButton() {
    return GradientButton(
      onPressed: () {
        Get.back();
        onOKPressed?.call();
      },
      title: "Okay",
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      childPadding: const EdgeInsets.all(24),
      enableCloseIconButton: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleWidget(),
          verticalSpacer(16),
          _messageWidget(),
          verticalSpacer(26),
          _ctaButton(),
        ],
      ),
    );
  }
}
