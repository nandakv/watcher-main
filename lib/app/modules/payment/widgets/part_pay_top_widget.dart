import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/payment/payment_logic.dart';
import 'package:privo/app/modules/payment/widgets/reason_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/no_leading_space_formatter.dart';

class PartPayTopWidget extends StatelessWidget {
  PartPayTopWidget();

  final logic = Get.find<PaymentLogic>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: _blueCardDecoration(),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text("Enter an Amount",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFFFF3EB))),
              _partPayAmountTextField(),
              verticalSpacer(5),
              _loanAmountErrorWidget(),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _limitDetail("Available Limit",
                        "₹${AppFunctions().parseIntoCommaFormat(
                            logic.partPaymentInfoModel.availableLimit
                                .toString())}"),
                    _limitDetail("Sanctioned Limit",
                        "₹${AppFunctions().parseIntoCommaFormat(
                            logic.partPaymentInfoModel.sanctionedLimit
                                .toString())}"),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        ReasonWidget(),
        const SizedBox(
          height: 20,
        ),
        _titleWidget("Part-payment overview"),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _titleWidget(String title,
      {double size = 14,
        FontWeight fontWeight = FontWeight.w600,
        Color color = darkBlueColor}) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: size,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }

  Column _limitDetail(String title, String value) {
    return Column(
      children: [
        Text(title, style: _availableLimitTextStyle()),
        Text(value, style: _availableLimitTextStyle()),
      ],
    );
  }

  TextStyle _availableLimitTextStyle() {
    return TextStyle(
        fontSize: 10, fontWeight: FontWeight.w400, color: Color(0xFFFFF3EB));
  }

  IntrinsicWidth _partPayAmountTextField() {
    return IntrinsicWidth(
      child: GetBuilder<PaymentLogic>(
          id: logic.PART_PAY_ERROR_TEXT,
          builder: (logic) {
        return TextField(
          controller: logic.partPayAmountTextController,
          enabled: !logic.isPageLoading,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 28,
            color: offWhiteColor,
          ),
          inputFormatters: [
            NumberToRupeesFormatter(),
          ],
          maxLength: 12,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          cursorColor: offWhiteColor,
          decoration: _loanAmountTextFieldDecoration(),
          onChanged: logic.onPartPayAmountChanged,
        );
      }),
    );
  }

  Widget _loanAmountErrorWidget() {
    return GetBuilder<PaymentLogic>(
      builder: (logic) {
        return logic.errorText.isNotEmpty
            ? Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.info,
                  color: lightRedColor,
                  size: 12,
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: Text(
                    logic.errorText,
                    style: _errorAmountTextStyle(),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        )
            : const SizedBox();
      },
    );
  }

  TextStyle _errorAmountTextStyle() {
    return const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      color: lightRedColor,
    );
  }

  InputDecoration _loanAmountTextFieldDecoration() {
    return InputDecoration(
        counterText: "",
        prefixText: "₹ ",
        prefixStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 28,
          color: offWhiteColor,
        ),
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none);
  }

  BoxDecoration _blueCardDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      gradient: const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          postRegistrationEnabledGradientColor1,
          postRegistrationEnabledGradientColor2,
        ],
      ),
    );
  }
}
