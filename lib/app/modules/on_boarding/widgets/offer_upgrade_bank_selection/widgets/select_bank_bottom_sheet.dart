import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/privo_text_form_field/privo_text_form_field.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../../../common_widgets/gradient_button.dart';
import '../offer_upgrade_bank_selection_logic.dart';
import 'bank_statement_method_selection_widget.dart';

class SelectBankBottomSheet extends StatelessWidget {
  SelectBankBottomSheet({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  final logic = Get.find<OfferUpgradeBankSelectionLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OfferUpgradeBankSelectionLogic>(
      builder: (logic) {
        return Form(
          key: logic.bankValidationKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: darkBlueColor,
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              const Text(
                "Select a method to upload your bank statement",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: secondaryDarkColor,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              _bankTextField(),
              const SizedBox(
                height: 30,
              ),
              if (logic.bankStatementUploadCombination != null)
                BankStatementUploadOptionSelectionWidget(
                  bankStatementUploadCombination:
                      logic.bankStatementUploadCombination!,
                ),
              const SizedBox(
                height: 20,
              ),
              GetBuilder<OfferUpgradeBankSelectionLogic>(
                id: logic.CONTINUE_BUTTON_ID,
                builder: (logic) {
                  return Center(
                    child: GradientButton(
                      edgeInsets: const EdgeInsets.symmetric(
                        horizontal: 44,
                        vertical: 14,
                      ),
                      fillWidth: false,
                      onPressed: () => logic.onBankSelectionContinuePressed(logic.selectedBankStatementUploadOption),
                      title: "Continue",
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bankTextField() {
    return GetBuilder<OfferUpgradeBankSelectionLogic>(
      id: logic.BANK_TEXT_FIELD_ID,
      builder: (logic) {
        return PrivoTextFormField(
          id: "",
          readOnly: true,
          onTap: logic.onTapBankTextField,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: logic.selectedBankController,
          decoration: InputDecoration(
            suffix: const Icon(Icons.chevron_right),
            labelText: "Select your Bank",
            errorText: logic.bankTextFieldError,
            errorMaxLines: 2,
            errorStyle: const TextStyle(
              color: Color(0xffEE3D4B),
              fontWeight: FontWeight.normal,
              letterSpacing: 0.16,
              fontSize: 12,
            ),
            helperStyle: const TextStyle(
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.italic,
              letterSpacing: 0.16,
              color: Color(0xff7E8088),
            ),
          ),
          validator: logic.validateBankTextField,
        );
      },
    );
  }
}
