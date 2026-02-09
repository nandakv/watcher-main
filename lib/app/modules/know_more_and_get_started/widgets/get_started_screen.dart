import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/onboarding_timeline_widget/onboarding_timeline_widget.dart';
import 'package:privo/app/common_widgets/privo_button.dart';
import 'package:privo/app/common_widgets/privo_text_form_field/privo_text_form_field.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/know_more_and_get_started/know_more_get_started_logic.dart';
import 'package:privo/app/modules/know_more_and_get_started/widgets/documents_you_need_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/no_leading_space_formatter.dart';

class GetStartedScreen extends StatelessWidget {
  GetStartedScreen({Key? key}) : super(key: key);

  final KnowMoreGetStartedLogic logic = Get.find<KnowMoreGetStartedLogic>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _getStartedTopWidget(),
          verticalSpacer(12),
          _getStartedBottomWidget(),
        ],
      ),
    );
  }

  Widget _getStartedBottomWidget() {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: Column(
        children: [
          _stepperWidget(),
          verticalSpacer(36),
          if (logic.isSBD) _documentsYouNeedWidget(),
        ],
      ),
    );
  }

  Widget _stepperWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subtitleWidget("Get Loan in a Few Easy Steps"),
        verticalSpacer(6),
        _stepperInfoText(),
        verticalSpacer(24),
        OnBoardingTimelineWidget(
          loanProductCode: logic.lpc,
        ),
      ],
    );
  }

  Widget _stepperInfoText() {
    return const Text(
      "Complete the following steps to get your loan",
      style: TextStyle(
          color: secondaryDarkColor, fontSize: 10, fontWeight: FontWeight.w500),
    );
  }

  Widget _documentsYouNeedWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subtitleWidget("Documents You Need"),
        verticalSpacer(16),
        DocumentsYouNeedWidget(),
        verticalSpacer(20),
      ],
    );
  }

  Widget _subtitleWidget(String subtitle) {
    return Text(
      subtitle,
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontWeight: FontWeight.w600, fontSize: 12, color: navyBlueColor),
    );
  }

  Widget _getStartedTopWidget() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff5BC4F0).withOpacity(0.1),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          SvgPicture.asset(logic.getStartedillustration),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _titleWidget(),
                verticalSpacer(12),
                _messageText(),
                verticalSpacer(24),
                _leadFormWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _leadFormWidget() {
    return SizedBox(
      width: Get.size.width * 0.5,
      child: Column(
        children: [
          PrivoTextFormField(
            id: logic.desiredAmountId,
            controller: logic.desiredAmountController,
            decoration: _textFieldDecoration(
              label: "Desired Amount",
            ).copyWith(
              prefixText: "₹ ",
            ),
            maxLength: 9,
            validator: logic.desiredAmountValidation,
            onChanged: (_) => logic.isFormValid(),
            keyboardType: TextInputType.number,
            inputFormatters: [
              NumberToRupeesFormatter(),
            ],
          ),
          verticalSpacer(12),
          PrivoTextFormField(
            id: logic.purposeId,
            controller: logic.purposeController,
            decoration: _textFieldDecoration(
              label: "Purpose",
            ),
            dropDownTitle: "Purpose",
            values: logic.purposeList,
            onChanged: (_) => logic.isFormValid(),
            type: PrivoTextFormFieldType.dropDown,
          ),
          verticalSpacer(12),
          PrivoTextFormField(
            id: logic.tenureId,
            controller: logic.tenureController,
            type: PrivoTextFormFieldType.dropDown,
            values: logic.tenureList,
            decoration: _textFieldDecoration(
              label: "Tenure",
            ),
            dropDownTitle: "Tenure",
            onChanged: (_) => logic.isFormValid(),
          ),
          verticalSpacer(36),
          _ctaButton(),
          verticalSpacer(12)
        ],
      ),
    );
  }

  Widget _ctaButton() {
    return GetBuilder<KnowMoreGetStartedLogic>(
        id: logic.CONTINUE_BUTTON_ID,
        builder: (logic) {
          return Padding(
            padding: const EdgeInsets.only(right: 36.0),
            child: PrivoButton(
              onPressed: logic.onContinueTap,
              enabled: logic.isButtonEnabled,
            ),
          );
        });
  }

  InputDecoration _textFieldDecoration({
    required String label,
    String hint = "",
  }) {
    return InputDecoration(
      hintText: hint,
      counterText: "",
      hintStyle:
          const TextStyle(color: Color(0xffA8A8A8), fontFamily: 'Figtree'),
      label: RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            fontFamily: 'Figtree',
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Color(0xFF707070),
            letterSpacing: 0.16,
          ),
        ),
      ),
      prefixStyle: const TextStyle(
        fontFamily: 'Figtree',
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: primaryDarkColor,
        letterSpacing: 0.16,
      ),
      errorMaxLines: 2,
      contentPadding: const EdgeInsets.only(bottom: 5),
      border: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFF707070),
        ),
      ),
      suffixIconConstraints: const BoxConstraints(
        maxWidth: 32,
      ),
    );
  }

  Widget _titleWidget() {
    return Text(
      logic.title,
      style: GoogleFonts.poppins(
        color: darkBlueColor,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _messageText() {
    return Text(
      logic.message,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        height: 1.6,
        color: secondaryDarkColor,
      ),
    );
  }
}
