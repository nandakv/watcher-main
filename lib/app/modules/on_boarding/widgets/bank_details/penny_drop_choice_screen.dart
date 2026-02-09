import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/res.dart';

import '../../../../common_widgets/gradient_button.dart';
import '../../../../common_widgets/info_bulb_widget.dart';
import '../../../../common_widgets/onboarding_step_of_widget.dart';
import '../../../../common_widgets/square_tile_widget.dart';
import '../../../../theme/app_colors.dart';
import '../../../withdrawal_screen/widgets/withdrawal/widgets/arrow_pointer.dart';
import 'bank_details_logic.dart';
import 'widgets/bank_name_widget.dart';

class PennyDropChoiceScreen extends StatelessWidget {
  PennyDropChoiceScreen({Key? key}) : super(key: key);

  final logic = Get.find<BankDetailsLogic>();

  Row _secureText() {
    return Row(
      children: [
        SvgPicture.asset(Res.green_shield_svg),
        const SizedBox(
          width: 10,
        ),
        const Expanded(
          child: Text(
            "Verify your bank account details for a secure deposit.",
            style: TextStyle(
                fontFamily: 'Figtree',
                fontSize: 10,
                height: 1.4,
                color: Color(0xff404040)),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BankDetailsLogic>(
      builder: (logic) {
        return _pennyDropTypeSelection();
      },
    );
  }

  Widget _pennyDropTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const OnboardingStepOfWidget(
                      title: "Bank Verification",
                    ),
                    verticalSpacer(9),
                    _secureText(),
                    verticalSpacer(30),
                    BankNameSearchWidget(),
                    verticalSpacer(30),
                    _pennyDropTypeSelectionWidget(),
                    verticalSpacer(20),
                  ],
                ),
              ],
            ),
          ),
        ),
        verticalSpacer(12),
        configureContinueButton(logic),
        verticalSpacer(20),
      ],
    );
  }

  Widget _infoWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      child: InfoBulbWidget(
        text: logic.computeInfoText(),
        border: Border.all(
          color: skyBlueColor,
          width: 1,
        ),
      ),
    );
  }

  Widget configureContinueButton(BankDetailsLogic bankDetailsLogic) {
    return Center(
      child: GradientButton(
        onPressed: () => bankDetailsLogic.onPennyTestingTypeContinue(),
        enabled: logic.isBankSelected,
        isLoading: logic.isButtonLoading,
        title: logic.computeBankCtaTitle(),
      ),
    );
  }

  SizedBox verticalSpacer(double verticalHeight) {
    return SizedBox(
      height: verticalHeight,
    );
  }

  TextStyle _titleTextStyle() {
    return const TextStyle(
      fontFamily: 'Figtree',
      fontSize: 12,
      height: 1.6,
      color: Color(0xff707070),
    );
  }

  Widget _pennyDropTypeSelectionWidget() {
    return GetBuilder<BankDetailsLogic>(
      id: logic.VERIFICATION_TYPE_ID,
      builder: (logic) {
        if (!logic.isBankSelected) {
          return const SizedBox();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose method to verify",
              style: _titleTextStyle(),
            ),
            verticalSpacer(12),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _tileWidget(
                  PennyTestingType.reverse,
                  isRecommended: true,
                ),
                const SizedBox(
                  width: 15,
                ),
                _tileWidget(
                  PennyTestingType.forward,
                ),
                const SizedBox(
                  width: 15,
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                _infoWidget(),
                _arrowAboveInfoWidget(),
              ],
            ),
          ],
        );
      },
    );
  }

  SquareTileWidget _tileWidget(
    PennyTestingType pennyTestingType, {
    bool isRecommended = false,
  }) {
    return SquareTileWidget(
      isRecommended: isRecommended,
      onTap: () => logic.onVerificationTypeSelection(pennyTestingType),
      isSelected: logic.userSelectedPennyTestingType == pennyTestingType,
      title: _computeTitle(pennyTestingType),
      icon: _computeIcon(pennyTestingType),
      autoIconColor: false,
      iconSize: 30,
    );
  }

  _computeTitle(PennyTestingType pennyTestingType) {
    if (pennyTestingType == PennyTestingType.forward) return "Bank Details";
    return "Verification";
  }

  _computeIcon(PennyTestingType pennyTestingType) {
    if (pennyTestingType == PennyTestingType.forward) {
      return logic.userSelectedPennyTestingType == PennyTestingType.forward
          ? Res.pennyTestingBankWhiteSVG
          : Res.pennyTestingBankBlueSVG;
    }

    return logic.userSelectedPennyTestingType == PennyTestingType.reverse
        ? Res.upi_white_logo
        : Res.upi_blue_logo;
  }

  Align _arrowAboveInfoWidget() {
    return Align(
      alignment: _computeArrowPainterLocation(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45),
        child: CustomPaint(
          painter: ArrowPainter(
            color: lightSkyBlueColor,
            border: Border.all(
              color: skyBlueColor,
              width: 1,
            ),
          ),
          child: const SizedBox(
            width: 16, // Adjust the size as needed
            height: 8,
          ),
        ),
      ),
    );
  }

  Alignment _computeArrowPainterLocation() {
    ///added null check in the parent widget
    switch (logic.userSelectedPennyTestingType) {
      case PennyTestingType.reverse:
        return Alignment.centerLeft;
      case PennyTestingType.forward:
        return Alignment.center;
    }
  }
}
