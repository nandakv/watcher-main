import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/onboarding_step_of_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/common_widgets/square_tile_widget.dart';
import 'package:privo/app/models/supported_banks_model.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../../../../res.dart';
import '../../../../../common_widgets/info_bulb_widget.dart';
import '../../../../withdrawal_screen/widgets/withdrawal/widgets/arrow_pointer.dart';
import '../e_mandate_logic.dart';
import 'powered_by_npci_widget.dart';

class JusPayMandateTypeSelectionWidget extends StatelessWidget {
  JusPayMandateTypeSelectionWidget({
    Key? key,
    required this.jusPayMandateCombination,
  }) : super(key: key);

  final JusPayMandateCombination jusPayMandateCombination;

  final logic = Get.find<EMandateLogic>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const OnboardingStepOfWidget(
                    title: "Set up Auto-Pay",
                  ),
                  const VerticalSpacer(6),
                  _verifyTextWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                  _computeJusPaySelectionWidget(),
                ],
              ),
            ),
          ),
          const PoweredByNPCIWidget(),
          GetBuilder<EMandateLogic>(
            id: logic.BUTTON_KEY,
            builder: (logic) {
              return GradientButton(
                enabled: logic.isButtonEnabled,
                onPressed: logic.onSetupEMandateContinueTapped,
                isLoading: logic.isButtonLoading,
                title: logic.computeJusPayScreenCTAText(),
              );
            },
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Row _verifyTextWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(Res.green_shield_svg),
        const SizedBox(
          width: 5,
        ),
        const Text(
          "Verify your bank account details for a secure transaction",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 10,
            color: primaryDarkColor,
          ),
        ),
      ],
    );
  }

  Widget _computeJusPaySelectionWidget() {
    switch (jusPayMandateCombination) {
      case JusPayMandateCombination.upi:
        return _upiOnlyWidget();
      default:
        return _jusPayMandateSelectionWidget();
    }
  }

  ///if [jusPayMandateCombination] is only upi
  Widget _upiOnlyWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _upiTextField(),
        const SizedBox(
          height: 30,
        ),
        const InfoBulbWidget(
          text:
              "₹1 will be debited from your account and refunded within 24 hours.",
        ),
      ],
    );
  }

  GetBuilder _upiTextField() {
    return GetBuilder<EMandateLogic>(
      id: logic.UPI_TEXTFIELD__KEY,
      builder: (logic) {
        return TextField(
          controller: logic.upiAddressController,
          style: const TextStyle(
            fontFamily: "Figtree",
            color: primaryDarkColor,
            fontWeight: FontWeight.w400,
          ),
          decoration: _upiTextFieldDecoration(),
          onChanged: (value) => logic.validateUpiAddressText(),
        );
      },
    );
  }

  InputDecoration _upiTextFieldDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 0),
      alignLabelWithHint: true,
      suffix: logic.upiAddressErrorText.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SvgPicture.asset(
                Res.failedTriangleSVG,
                height: 16,
              ),
            ),
      errorText:
          logic.upiAddressErrorText.isEmpty ? null : logic.upiAddressErrorText,
      errorStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 10,
        color: red,
        fontFamily: 'Figtree',
      ),
      label: _upiTextFieldLabel(),
    );
  }

  Text _upiTextFieldLabel() {
    return const Text.rich(
      TextSpan(
        text: "Enter valid VPA/UPI address ",
        style: TextStyle(
          fontFamily: 'Figtree',
          fontWeight: FontWeight.w300,
          color: secondaryDarkColor,
        ),
        children: [
          TextSpan(
            text: "*",
            style: TextStyle(
              fontFamily: 'Figtree',
              fontWeight: FontWeight.w300,
              color: red,
            ),
          )
        ],
      ),
    );
  }

  Widget _jusPayMandateSelectionWidget() {
    return GetBuilder<EMandateLogic>(
      id: logic.MANDATE_TYPE_WIDGET_ID,
      builder: (logic) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select a method to set up Auto-Pay",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: secondaryDarkColor,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _computeJusPayTiles(),
            ),
            const SizedBox(
              height: 20,
            ),
            if (logic.selectedMandateType != null)
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

  Container _infoWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      child: InfoBulbWidget(
        text: _computeInfoText(),
        border: Border.all(
          color: skyBlueColor,
          width: 0.6,
        ),
        child: logic.selectedMandateType == JusPayMandateType.upi
            ? _textFieldInsideInfoWidget()
            : null,
      ),
    );
  }

  Align _arrowAboveInfoWidget() {
    return Align(
      alignment: _computeArrowPainterLocation(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45),
        child: CustomPaint(
          painter: ArrowPainter(
            color: logic.selectedMandateType == JusPayMandateType.upi
                ? Colors.white
                : lightSkyBlueColor,
            border: Border.all(
              color: skyBlueColor,
              width: 0.6,
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

  Container _textFieldInsideInfoWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20,
        top: 10,
      ),
      child: _upiTextField(),
    );
  }

  Alignment _computeArrowPainterLocation() {
    ///added null check in the parent widget
    switch (logic.selectedMandateType!) {
      case JusPayMandateType.upi:
        return Alignment.centerLeft;
      case JusPayMandateType.eNach:
        return Alignment.center;
    }
  }

  String _computeInfoText() {
    ///added null check in the parent widget
    switch (logic.selectedMandateType!) {
      case JusPayMandateType.upi:
        return "₹1 will be debited from your account and refunded within 24 hours.";
      case JusPayMandateType.eNach:
        return "Keep your net banking and card details handy for a quick and easy setup.";
    }
  }

  List<Widget> _computeJusPayTiles() {
    switch (logic.jusPayMandateCombination) {
      case JusPayMandateCombination.upi:
      case JusPayMandateCombination.eNach:
        return [];
      case JusPayMandateCombination.all:
        return [
          _tileWidget(JusPayMandateType.upi),
          const SizedBox(
            width: 15,
          ),
          _tileWidget(JusPayMandateType.eNach),
          const SizedBox(
            width: 15,
          ),
          ..._buildEmptySpace(1),
        ];
    }
  }

  List<Widget> _buildEmptySpace(int count) {
    return List.generate(count, (index) => const Spacer());
  }

  SquareTileWidget _tileWidget(JusPayMandateType jusPayMandateType) {
    return SquareTileWidget(
      isRecommended: jusPayMandateType == JusPayMandateType.upi,
      onTap: () => logic.onTapJusPayTypeTile(jusPayMandateType),
      isSelected: logic.selectedMandateType == jusPayMandateType,
      title: _computeJusPayTileTitle(jusPayMandateType),
      icon: _computeJusPayTileIcon(jusPayMandateType),
      autoIconColor: false,
      iconHorizontalPadding:
          jusPayMandateType == JusPayMandateType.upi ? 20 : 0,
    );
  }

  String _computeJusPayTileTitle(JusPayMandateType jusPayMandateType) {
    Map<JusPayMandateType, String> titleMap = {
      JusPayMandateType.upi: "through UPI",
      JusPayMandateType.eNach: "with eNACH",
    };
    return titleMap[jusPayMandateType] ?? "through UPI";
  }

  String _computeJusPayTileIcon(JusPayMandateType jusPayMandateType) {
    Map<JusPayMandateType, String> titleMap = {
      JusPayMandateType.upi: logic.selectedMandateType == JusPayMandateType.upi
          ? Res.upi_white_logo
          : Res.upi_blue_logo,
      JusPayMandateType.eNach:
          logic.selectedMandateType == JusPayMandateType.eNach
              ? Res.eNachLiteSVG
              : Res.eNachDarkSVG,
    };
    return titleMap[jusPayMandateType] ?? Res.upi_white_logo;
  }
}
