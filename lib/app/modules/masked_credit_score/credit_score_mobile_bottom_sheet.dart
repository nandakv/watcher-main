import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/credit_report/credit_report_helper_mixin.dart';
import 'package:privo/app/modules/credit_report/credit_report_logic.dart';

import '../../../components/button.dart';
import '../../../components/radio_tile.dart';
import '../../common_widgets/bottom_sheet_widget.dart';
import '../../common_widgets/common_text_fields/text_field_decoration.dart';
import '../../common_widgets/privo_text_form_field/privo_text_form_field.dart';
import '../../common_widgets/vertical_spacer.dart';
import '../../theme/app_colors.dart';
import '../../utils/app_text_styles.dart';

class CreditScoreMobileBottomSheet extends StatelessWidget
{
  final CreditReportLogic logic = Get.find<CreditReportLogic>();

   CreditScoreMobileBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: BottomSheetWidget(
          childPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 21.42.h),
          enableCloseIconButton: true,
          onCloseClicked:logic.maskedBackClicked,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTitle(),
              verticalSpacer(12.h),
              _buildDescription(),
              verticalSpacer(24.h),
              if (logic.maskedMobileNumbers.isNotEmpty) ConstrainedBox(
                constraints:  BoxConstraints(maxHeight: 350.h),
                child: RawScrollbar(
                  thickness: 5,
                  thumbVisibility: true,
                  mainAxisMargin: 10.0,
                  thumbColor: lightGrayColor,
                  radius: const Radius.circular(40),
                  child:_buildRadioButtons(),
                ),
              ),
              _buildMaskedTextField(),
              verticalSpacer(32.h),
              _buildContinueButton(),
              verticalSpacer(20.h),
              _buildBottomTitle(),
              verticalSpacer(4.h),
            ],
          ),
        ),
      );

  }

  Widget _buildTitle() {
    return Text(
      "Verify your mobile number",
      style: AppTextStyles.headingSMedium(color: darkBlueColor),
    );
  }

  Widget _buildDescription() {
    return Text(
      "We found multiple numbers linked to your credit report. Select one and verify with OTP",
      style: AppTextStyles.bodySRegular(color: primaryDarkColor),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildRadioButtons() {
    return GetBuilder<CreditReportLogic>(
      id: logic.RADIO_BUTTON_ID,
      builder: (_) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: logic.maskedMobileNumbers.length,
          itemBuilder: (_, index) => Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: RadioTile<String>(
              label: "+91 ${logic.maskedMobileNumbers[index]}",
              groupValue: logic.radioGroupValue,
              value: logic.maskedMobileNumbers[index],
              onChange: (val) => logic.radioGroupValue = val ?? "",
            ),
          ),
        );
      },
    );
  }

  Widget _buildMaskedTextField() {
    return GetBuilder<CreditReportLogic>(
      id: logic.MASKED_TEXT_FIELD,
      builder: (_) {
        return logic.radioGroupValue.isNotEmpty
            ? Padding(
          padding: EdgeInsets.only(top: 16.h),
                child: PrivoTextFormField(
                  id: logic.MASKED_TEXT_FIELD,
                  controller: logic.phoneController,
                  maxLength: 10,
                  onChanged: (val) {
                    logic.mobileTextField(val);
                  },
                  validator: (value) => logic.validateMaskedMobileNumber(value,
                      maskedValue: logic.radioGroupValue),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: _mobileTextFieldDecoration(),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }

  InputDecoration _mobileTextFieldDecoration() {
    return textFieldDecoration(
      counterWidget: const SizedBox.shrink(),
      label: "Enter the selected number",
      prefix: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Text(
          '+91 ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: primaryDarkColor,
          ),
        ),
      ),
    );
  }

  /// Continue Button
  Widget _buildContinueButton() {
    return GetBuilder<CreditReportLogic>(
      id: logic.BOTTOM_SHEET_CONTINUE_CTA,
      builder: (_) {
        return Button(
          buttonSize: ButtonSize.large,
          buttonType: ButtonType.primary,
          title: "Continue",
          onPressed: () {
            logic.toGetOTP();
          },
          isLoading: logic.isLoading,
          enabled: logic.isMobileNumberSelected,
        );
      },
    );
  }

  Widget _buildBottomTitle() {
    return InkWell(
      onTap: () {
        logic.numberNotFoundClicked();
      },
      child: Text(
        "I didn't find my number",
        style: AppTextStyles.bodyMMedium(color: appBarTitleColor),
      ),
    );
  }
}