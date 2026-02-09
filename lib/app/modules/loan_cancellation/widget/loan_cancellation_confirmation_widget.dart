import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../common_widgets/bottom_sheet_widget.dart';
import '../../../common_widgets/gradient_button.dart';
import '../../../common_widgets/vertical_spacer.dart';
import '../../../theme/app_colors.dart';

class LoanCancellationConfirmationWidget extends StatelessWidget {
  final Function() onContinue;
  final Function() onGoBack;
  const LoanCancellationConfirmationWidget(
      {Key? key, required this.onContinue, required this.onGoBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
        childPadding: const EdgeInsets.all(23),
        child: Column(
          children: [
            _confirmationTextWidget(),
            verticalSpacer(32),
            Row(
              children: [
                Expanded(
                  child: GradientButton(
                    onPressed: onContinue,
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
                Expanded(child: _goBackButton()),
              ],
            )
          ],
        ));
  }

  Widget _confirmationTextWidget() {
    return const Text(
      "Are you sure you want to cancel your Loan?",
      style: TextStyle(
        color: navyBlueColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _goBackButton() {
    return GradientButton(
      title: "Go back",
      enabled: false,
      onPressed: () {},
      onDisablePressed: onGoBack,
    );
  }
}
