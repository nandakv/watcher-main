import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:privo/app/common_widgets/privo_text_form_field/privo_text_form_field.dart';
import 'package:privo/app/theme/app_colors.dart';
import '../app/modules/authentication/sign_in_screen/widget/sign_in_field_validator.dart';
import '../app/modules/on_boarding/widgets/offer_upgrade_bank_selection/offer_upgrade_bank_selection_logic.dart';
import '../app/utils/app_text_styles.dart';

class MobileTextField extends StatelessWidget with SignInFieldValidator {
  MobileTextField({super.key});

  final logic = Get.find<OfferUpgradeBankSelectionLogic>();

  @override
  Widget build(BuildContext context) {
    return _mobileTextField();
  }

  GetBuilder<OfferUpgradeBankSelectionLogic> _mobileTextField() {
    return GetBuilder<OfferUpgradeBankSelectionLogic>(
      id: logic.MOBILE_TEXT_FIELD_ID,
      builder: (logic) {
        return PrivoTextFormField(
          controller: logic.mobileNumberController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validateMobileNumber,
          maxLength: 10,
          autofocus: true,
          onChanged: (value) => logic.setNumber = value,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          style: AppTextStyles.bodyLSemiBold(color: secondaryDarkColor),
          decoration: _mobileNumberTextFieldInputDecoration(),
          id: 'PRIVO_MOBILE_FIELD_ID',
        );
      },
    );
  }

  InputDecoration _mobileNumberTextFieldInputDecoration() {
    return InputDecoration(
      counterText: '',
      prefixIcon: Text(
        '+91  ',
        style: AppTextStyles.bodyLSemiBold(
            color: appBarTitleColor.withOpacity(
                0.5)), //this is as per new design system(in design calculation is different)
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      focusedBorder: const UnderlineInputBorder(
        borderSide:
            BorderSide(color: Colors.grey), // Change to grey when focused
      ),
      //    errorText: logic.mobileErrorText,
    );
  }
}
